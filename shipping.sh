source common.sh

echo -e "\e[32m>>>>>>>>install mavan<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[32m>>>>>>>>add user<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>creat app dir<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>>>download content<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[32m>>>>>>>>unzip<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip
cd /app

echo -e "\e[32m>>>>>>>>download dependences<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[32m>>>>>>>>service file<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service


echo -e "\e[32m>>>>>>>>install mysqls<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[32m>>>>>>>>load shema<<<<<<<<<\e[0m"
mysql -h mysql-dev.sonydevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[32m>>>>>>>>start service<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping