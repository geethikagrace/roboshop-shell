app_user=roboshop


func_print_head() {
  echo -e "\e[36m>>>>>>>> $1 <<<<<<<<<\e[0m"
}
  func_schema_setup() {
   if [  "$schema_setup" == "mongo"  ]; then
      func_print_head "copy mongodb repo"
      cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

     func_print_head "install mongo clint"
     yum install mongodb-org-shell -y

     func_print_head "install mongodb client"
    mongo --host mongodb-dev.sonydevops.online </app/schema/${component}.js
  fi


  if [ "$schema_setup" == "mysql"  ]; then
      func_print_head "download  mavan dependences"
      mvn clean package
      mv target/shipping-1.0.jar shipping.jar


      func_print_head"install mysql client"
      yum install mysql -y


      func_print_head "load schema"
      mysql -h mysql-dev.sonydevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
  fi
}

func_app_prereq() {

    func_print_head "add application user"
    useradd ${app_user}

    func_print_head "creat application directory"
    rm -rf /app
    mkdir /app

    func_print_head "download  application content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    cd /app

    func_print_head "extract application content"
    unzip /tmp/${component}.zip
}

   func_systemd_setup() {

    func_print_head "setup systemd"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

    func_print_head "start ${component}service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl start ${component}
   }



func_nodejs() {
  func_print_head "configuring nodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

 func_print_head "install nodejs"
  yum install nodejs -y

 func_app_prereq

 func_print_head "install nodejs dependences"
  npm install

  func_schema_setup
  func_systemd_setup

  }
  
  func_java() {

    func_print_head "install mavan"
    yum install maven -y

    func_app_prereq

    func_print_head"install mysql client"
    yum install mysql -y

    func_print_head "download  mavan dependences"
    mvn clean package
    mv target/${component}-1.0.jar ${component}.jar

    func_schema_setup

    func_systemd_setup

  }
