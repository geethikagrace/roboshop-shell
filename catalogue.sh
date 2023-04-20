script=$(realpath "$0")
script_path=$(dirname  "$script")
source ${script_path}/common.sh

component=catalogue

func_nodejs

echo -e "\e[32m>>>>>>>>copy mongodb<<<<<<<<<\e[0m"
cp ${script_path}/mongodb.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>install mongodb clint<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[32m>>>>>>>>load schema<<<<<<<<<\e[0m"
mongo --host mongodb-dev.sonydevops.online </app/schema/catalogue.js