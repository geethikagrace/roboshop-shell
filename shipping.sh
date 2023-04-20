script_=$(realpath "$0")
script_path=$(dirname '$script')
source ${script_path}/common.sh
mysql_root_password=$1

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
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service


echo -e "\e[32m>>>>>>>>install mysqls<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[32m>>>>>>>>load shema<<<<<<<<<\e[0m"
mysql -h mysql-dev.sonydevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql

echo -e "\e[32m>>>>>>>>start service<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping