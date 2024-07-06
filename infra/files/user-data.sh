#!/bin/bash

wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install -y unzip
sudo apt-get install -y dotnet-host
sudo apt install -y dotnet-runtime-8.0
sudo apt install -y aspnetcore-runtime-8.0
