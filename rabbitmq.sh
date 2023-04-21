script=$(realpath "$0")
script_path=$(dirname  "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1


if [  -z "$rabbitmq_appuser_password"];
then
  echo input rabbitmq appuser password missing
  exit
fi


func_print_head "module enable"
dnf module enable redis:remi-6.2 -y &>>$redirect_log
func_status_check $?


func_print_head "setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$redirect_log
func_status_check $?

func_print_head "setup rabbitmq  repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$redirect_log
func_status_check $?

func_print_head"install erlang"
yum install erlang -y &>>$redirect_log
func_status_check $?

func_print_head "install rebbitmq"
yum install rabbitmq-server -y &>>$redirect_log
func_status_check $?

func_print_head  "start rebbitmq"
systemctl enable rabbitmq-server &>>$redirect_log
systemctl restart rabbitmq-server &>>$redirect_log
func_status_check $?

func_print_head "add application user in rabbitmq"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$redirect_log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".* "  &>>$redirect_log
func_status_check $?