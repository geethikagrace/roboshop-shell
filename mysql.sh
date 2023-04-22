script=$(realpath "$0")
script_path=$(dirname  "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [  -z "$mysql_root_password" ];
then
  echo input mysql root  password missing
  exit
fi


func_print_head "deleting default content"
dnf module disable mysql -y &>>$redirect_log
func_status_check $?

func_print_head "copy mysql repo"
cp ${script_path}/mysql.repo  /etc/yum.repos.d/mysql.repo &>>$redirect_log
func_status_check $?

func_print_head "install my sql "
yum install mysql-community-server -y &>>$redirect_log
func_status_check $?

func_print_head "start mysql"
systemctl enable mysqld &>>$redirect_log
systemctl restart mysqld &>>$redirect_log
func_status_check $?

func_print_head "reset my sql passwd"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$redirect_log
func_status_check $?