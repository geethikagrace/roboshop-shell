script=$(realpath "$0")
script_path=$(dirname  "$script")
source ${script_path}/common.sh





func_print_head "install nginx"
    yum install nginx -y &>>$redirect_log
    func_status_check $?

func_print_head "copy config file"
    cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$redirect_log
    func_status_check $?



func_print_head "removing old content"
    rm -rf /usr/share/nginx/html/*  &>>$redirect_log
    func_status_check $?



func_print_head "downloading  roboshop content"
   curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$redirect_log
   func_status_check $?
   cd /usr/share/nginx/html &>>$redirect_log
   func_status_check $?


func_print_head "unziping"
    unzip /tmp/frontend.zip &>>$redirect_log
    func_status_check $?



func_print_head "restarting nginx"
     systemctl enable nginx &>>$redirect_log
     systemctl restart nginx &>>$redirect_log
     func_status_check $?
