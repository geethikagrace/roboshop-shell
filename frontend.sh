script_=$(realpath "$0")
script_path=$(dirname '$script')
source ${script_path}/common.sh


echo -e "\e[36m>>>>>>>>install nginx<<<<<<<<<\e[0m"
yum install nginx -y
echo -e "\e[36m>>>>>>>>conf file copy<<<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[36m>>>>>>>>removing content<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[36m>>>>>>>>downloading content<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
echo -e "\e[36m>>>>>>>>unziping<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip
echo -e "\e[36m>>>>>>>>restart<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx
