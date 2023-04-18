echo -e "\e[34m>>>>>>>>installing remi repo<<<<<<<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[34m>>>>>>>>module enable<<<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[34m>>>>>>>>install redis<<<<<<<<<\e[0m"
yum install redis -y

echo -e "\e[34m>>>>>>>>changing conf<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[34m>>>>>>>>restating redis<<<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis