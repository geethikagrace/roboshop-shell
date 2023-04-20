script=$(realpath "$0")
script_path=$(dirname  "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [  -z "$rabbitmq_appuser_password"];
then
  echo input rabbitmq appuser password missing
  exit
fi


echo -e "\e[32m>>>>>>>>install paython<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[32m>>>>>>>>add user<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>add dir<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>>>download contents<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

echo -e "\e[32m>>>>>>>>unzip<<<<<<<<<\e[0m"
unzip /tmp/payment.zip
cd /app

echo -e "\e[32m>>>>>>>install requirements<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[32m>>>>>>>>configuring nodeJS repos<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|"  ${script_path}/payment.service
cp ${script_path}/payment.service  /etc/systemd/system/payment.service

echo -e "\e[32m>>>>>>>>restart payment<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment