provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22]
}

resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}



resource "aws_instance" "datadog-1" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = "datadog2"

  provisioner "file" {
    source      = "scriptubuntu.sh"
    destination = "/home/ubuntu/scriptubuntu.sh"
  }

  provisioner "remote-exec" {
    inline = [
	"sudo chmod u+x /home/ubuntu/scriptubuntu.sh",
	"sudo /home/ubuntu/scriptubuntu.sh",
    ]
  }



connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/Users/jesusoctavioacostasantos/git/infra/terra/datadog/datadog2.pem")
  }


  tags = {
    "Name"      = "datadog1"
    "Terraform" = "true"
  }
}
