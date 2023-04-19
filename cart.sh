echo -e "\e[32m>>>>>>>>configuring nodeJS repos<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m>>>>>>>>install nodejs<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[32m>>>>>>>>Add application user<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[32m>>>>>>>>Add application directorys<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>>>downloding nodejs repos<<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[32m>>>>>>>>unzip app contents<<<<<<<<<\e[0m"
unzip /tmp/cart.zip

echo -e "\e[32m>>>>>>>>install nodejs dependences<<<<<<<<<\e[0m"
npm install

echo -e "\e[32m>>>>>>>>copy catalogue systemD file<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[32m>>>>>>>>start user service<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
