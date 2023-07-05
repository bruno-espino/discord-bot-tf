#!/bin/bash -xe
yum update
yum install -y ruby wget git jq
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. /.nvm/nvm.sh
nvm install --lts
echo ". /.nvm/nvm.sh" >> ~/.bashrc
source ~/.bashrc
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto
service codedeploy-agent start
service codedeploy-agent enable