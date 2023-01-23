#!/bin/bash

echo "Setting up Angular MEAN Frontend"
sudo npm install @angular/cli -g
sudo ng new MEAN
cd MEAN
sudo npm install bootstrap
sudo sed 's/"src\/styles.css"/"node_modules\/bootstrap\/dist\/css\/bootstrap.min.css\",\n              "src\/styles.css"/' angular.json

echo "Starting MEAN Frontend"
sudo ng serve
