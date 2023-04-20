app_user=roboshop


print_head() {
  echo -e "\e[36m>>>>>>>> $1 <<<<<<<<<\e[0m"
}

schema_setup() {
  echo -e "\e[32m>>>>>>>>copy mongodb<<<<<<<<<\e[0m"
  cp ${script_path}/mongodb.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[32m>>>>>>>>install mongodb clint<<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y

  echo -e "\e[32m>>>>>>>>load schema<<<<<<<<<\e[0m"
  mongo --host mongodb-dev.sonydevops.online </app/schema/${component}.js
}

func_nodejs() {
  print_head "configuring nodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

 print_head "install nodejs"
  yum install nodejs -y

  print_head "Add application user"
  useradd ${app_user}

  print_head "Add application directory"
  rm -rf /app
  mkdir /app

  print_head "downloding nodejs repos"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "unzip app contents"
  unzip /tmp/${component}.zip

 print_head "install nodejs dependences"
  npm install

print_head "copy catalogue systemD file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

 print_head "start catalogue service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  schema_setup
  }
