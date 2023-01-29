#!bin/bash

echo "Installing MongoDB 6"
sudo wget -q -O - https://www.mongodb.org/static/pgp/server-6.0.pub | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb.gpg     
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod.service
sudo systemctl status mongod
sudo systemctl enable mongod

echo "Installing Node JS 19"
sudo curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

echo "Setting up Angular MEAN Frontend"
sudo npm install @angular/cli -g
sudo ng new MEAN
cd MEAN/ 
sudo npm install bootstrap
cd src/app/
sudo ng g class models/tutorial --type=model
sudo ng g c components/add-tutorial
sudo ng g c components/tutorial-details
sudo ng g c components/tutorials-list
sudo ng g s services/tutorial
