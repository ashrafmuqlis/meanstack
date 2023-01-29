#!bin/bash

file1="127.0.0.1"
file2=`hostname -I | xargs`

echo $file1, $file2

echo "sudo sed -ie '21 s/"$file1, $file2/$file1"/' /etc/mongod.conf" > mongo_script.sh

bash ./mongo_script.sh

sudo systemctl restart mongod.service

echo "sudo sed -i 's/"$file2"/localhost/' MEAN/src/app/services/tutorial.service.ts" > mongo_script.sh

sudo bash ./mongo_script.sh

echo "sudo sed -i 's/"$file2"/localhost/' MEAN/backend/server.js" > mongo_script.sh

sudo bash ./mongo_script.sh
