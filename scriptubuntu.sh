#!/bin/bash

# Update the  OS  and  install the  APT transport for downloading via the HTTP Secure protocol (HTTPS).
sudo apt-get update -y
sudo apt-get install apt-transport-https -y
#
#
# Add the Datadog apt key  to auth on the datadog repo and add the datadog repo.
sudo sh -c "echo 'deb https://apt.datadoghq.com/ stable 7' > /etc/apt/sources.list.d/datadog.list"
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 A2923DFF56EDA6E76E55E492D3A80E30382E94DE
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 D75CEA17048B9ACBF186794B32637D44F14F620E
#
#
# Update the list of the repos and the content of the datadog repo.
sudo apt-get update -y
#
#
# Install the datosdog agent
sudo apt-get install datadog-agent -y
#
#
# Configure the datadog agent and the apikey
sudo sh -c "sed 's/api_key:.*/api_key: 4597c86cf1a8b62feb39bb54a826a554/' /etc/datadog-agent/datadog.yaml.example > /etc/datadog-agent/datadog.yaml"
#
#
sudo sh -c "sed -i 's/# site:.*/site: datadoghq.com/' /etc/datadog-agent/datadog.yaml"
#
sudo sh -c "sed -i 's/# logs_enabled:.*/logs_enabled: true/' /etc/datadog-agent/datadog.yaml"
#
sudo systemctl restart datadog-agent.service
#
# select basic example 4597c86cf1a8b62feb39bb54a826a5544597c86cf1a8b62feb39bb54a826a554
#here goes the selector
