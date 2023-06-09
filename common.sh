app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
redirect_log=/tmp/roboshop.log
rm -f $redirect_log

func_print_head() {
  echo -e "\e[35m>>>>>>>> $1 <<<<<<<<<\e[0m"
  echo -e "\e[36m>>>>>>>> $1 <<<<<<<<<\e[0m" &>>$redirect_log
}
func_status_check()  {
  if [ $1 -eq 0 ]; then
        echo -e "\e[32mSUCCESS\e[0m"
      else
          echo -e "\e[31mFAILURE\e[0m"
          echo "refer the log file /tmp/roboshop.log for more information"
          exit 1
      fi

}
  func_schema_setup() {
   if [  "$schema_setup" == "mongo"  ]; then
      func_print_head "copy mongodb repo"
      cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$redirect_log
      func_status_check $?

      func_print_head "install mongo clint"
      yum install mongodb-org-shell -y &>>$redirect_log
      func_status_check $?

      func_print_head "install mongodb client"
      mongo --host mongodb-dev.sonydevops.online </app/schema/${component}.js &>>$redirect_log
      func_status_check $?
  fi


  if [ "$schema_setup" == "mysql"  ]; then

      func_print_head  "install mysql client"
      yum install mysql -y &>>$redirect_log
      func_status_check $?


      func_print_head "load schema"
      mysql -h mysql-dev.sonydevops.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$redirect_log
      func_status_check $?
  fi
}

func_app_prereq() {

    func_print_head "add application user"
    id ${app_user} &>>$redirect_log
    if [ $? -ne  0 ]; then
    useradd ${app_user} &>>$redirect_log
    fi
    func_status_check $?

    func_print_head "creat application directory"
    rm -rf /app &>>$redirect_log
    mkdir /app &>>$redirect_log
    func_status_check $?

    func_print_head "download  application content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$redirect_log
    func_status_check $?


    func_print_head "extract application content"
    cd /app
    unzip /tmp/${component}.zip &>>$redirect_log
    func_status_check $?
}

func_systemd_setup() {

    func_print_head "setup systemd"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$redirect_log
    func_status_check $?

    func_print_head "start ${component} service"
    systemctl daemon-reload  &>>$redirect_log
    systemctl enable ${component}  &>>$redirect_log
    systemctl restart ${component}  &>>$redirect_log
    func_status_check $?
   }



func_nodejs() {
  func_print_head "configuring nodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$redirect_log
  func_status_check $?

  func_print_head "install nodejs"
  yum install nodejs -y &>>$redirect_log
  func_status_check $?

  func_app_prereq

  func_print_head "install nodejs dependences"
  npm install &>>$redirect_log
  func_status_check $?

  func_schema_setup
  func_systemd_setup
  func_status_check $?

  }
  
  func_java() {
    func_print_head "instll maven"
    yum install maven -y &>>$redirect_log
    func_status_check $?

    func_app_prereq

    func_print_head "download  mavan dependences"
    mvn clean package &>>$redirect_log
    func_status_check $?
    mv target/${component}-1.0.jar ${component}.jar &>>$redirect_log

    func_schema_setup

    func_systemd_setup

  }

  func_python_pay() {

    func_print_head "install paython"
    yum install python36 gcc python3-devel -y &>>$redirect_log
    func_status_check $?

    func_app_prereq

    func_print_head "install python dependences"
    pip3.6 install -r requirements.txt &>>$redirect_log
    func_status_check $?

    func_print_head "update passwords in systemd service file"
    sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|"  ${script_path}/${component}.service &>>$redirect_log
    func_status_check $?

    func_systemd_setup

}