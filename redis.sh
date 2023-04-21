script=$(realpath "$0")
script_path=$(dirname  "$script")
source ${script_path}/common.sh



func_print_head "installing remi repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$redirect_log
func_status_check $?

func_print_head "module enable"
dnf module enable redis:remi-6.2 -y &>>$redirect_log
func_status_check $?

func_print_head "install redis"
yum install redis -y &>>$redirect_log
func_status_check $?

func_print_head "update redis lisen address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$redirect_log
func_status_check $?

func_print_head "restating redis"
systemctl enable redis &>>$redirect_log
systemctl restart redis &>>$redirect_log
func_status_check $?