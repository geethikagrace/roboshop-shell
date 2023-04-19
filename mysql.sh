echo -e "\e[35m>>>>>>>>deleting default content<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[35m>>>>>>>>copy mysql repo <<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mysql.repo  /etc/yum.repos.d/mysql.repo

echo -e "\e[35m>>>>>>>>install my sql <<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[35m>>>>>>>>start mysql <<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[35m>>>>>>>>reset my sql passwd <<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
