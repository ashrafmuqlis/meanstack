#!/bin/bash

echo "Creating Angular Backend Environment"
sudo mkdir MEAN/backend
cd MEAN/backend
sudo npm init -y
sudo npm install cors express mongoose --save
