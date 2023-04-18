echo -e "\e[32m>>>>>>>>configuring nodeJS repos<<<<<<<<<\[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m>>>>>>>>install nodejs<<<<<<<<<\[0m"
yum install nodejs -y

echo -e "\e[32m>>>>>>>>Add application user<<<<<<<<<\[0m"
useradd roboshop

echo -e "\e[32m>>>>>>>>Add application directory<<<<<<<<<\[0m"
mkdir /app

echo -e "\e[32m>>>>>>>>downloding npdejs repos<<<<<<<<<\[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[32m>>>>>>>>unzip app contents<<<<<<<<<\[0m"
unzip /tmp/catalogue.zip

echo -e "\e[32m>>>>>>>>install nodejs dependences<<<<<<<<<\[0m"
npm install
echo -e "\e[32m>>>>>>>>copy catalogue systemD file<<<<<<<<<\[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[32m>>>>>>>>start catalogue service<<<<<<<<<\[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
echo -e "\e[32m>>>>>>>>copy mongodb<<<<<<<<<\[0m"
cp mongodb.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[32m>>>>>>>>install mongodb clint<<<<<<<<<\[0m"
yum install mongodb-org-shell -y
echo -e "\e[32m>>>>>>>>load schema<<<<<<<<<\[0m"
mongo --host mongodb-dev.sonydevops.online </app/schema/catalogue.js