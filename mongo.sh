script=$(realpath "$0")
script_path=$(dirname  "$script")
source ${script_path}/common.sh



    func_print_head "mongo repo"
    cp ${script_path}  /etc/yum.repos.d/mongo.repo &>>$redirect_log
    func_status_check $?

    func_print_head "install mongodb"
    yum install mongodb-org -y &>>$redirect_log
    func_status_check $?

    func_print_head "changing default Ip address"
    sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$redirect_log
    func_status_check $?

    func_print_head "restarting mongodb"
    systemctl enable mongod &>>$redirect_log
    systemctl restart mongod &>>$redirect_log
    func_status_check $?
