app_user=roboshop
log_file=/tmp/roboshop.log

func_print_head()
{
  echo -e "\e[36m$1\e[0m"
  echo -e "\e[36m$1\e[0m" &>>$log_file
}
func_nodejs()
{
  func_print_head "configuring and downloading nodejs"
  dnf module disable nodejs -y &>>$log_file
  dnf module enable nodejs:18 -y &>>$log_file
  dnf install nodejs -y &>>$log_file
  func_stat_check $?
  func_app_prereq
  func_print_head "Downloading Nodejs dependencies"
  npm install &>>$log_file
  func_stat_check $?

  func_systemd
  func_schema_setup
}
func_java()
{
  func_print_head "Installing Maven"
  dnf install maven -y &>>$log_file
    func_stat_check $?

  func_app_prereq
  func_print_head "maven build"
  mvn clean package &>>$log_file
  func_stat_check $?
  mv target/${component}-1.0.jar ${component}.jar
  func_schema_setup
  func_systemd

}
func_payment()
{
func_print_head "Installing Python"
dnf install python36 gcc python3-devel -y &>>$log_file
func_stat_check $?
func_app_prereq
func_print_head "Installing Python dependencies"
pip3.6 install -r requirements.txt &>>$log_file
func_stat_check $?

func_print_head "Editing rabbitmq password in service file"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.service &>>$log_file
func_stat_check $?

func_systemd
}
func_stat_check()
{
  if [ $1 -eq 0 ]; then
        func_print_head "success"
        else
          func_print_head "Failure"
          echo "refer log /tmp/roboshop.log for more information"
          exit 1
      fi
}
func_app_prereq()
{
  func_print_head "Creating Application User"
  id ${app_user} &>>$log_file
  if [ $? -ne 0 ]; then
      useradd ${app_user} &>>$log_file
  fi
    func_stat_check $?
    func_print_head "Creating Application Folder"
    rm -rf /app
    mkdir /app
   func_stat_check $?
    func_print_head "Downloading app content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    func_stat_check $?
    cd /app
   func_print_head "Unzip app content"
    unzip /tmp/${component}.zip &>>$log_file
    func_stat_check $?

}

func_schema_setup()
{
  if [ "$schema_setup" == "mongo" ]
  then
  func_print_head "Copying Mongodb repo file"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
  func_stat_check $?
  func_print_head "Downloading Mongodb"
  dnf install mongodb-org-shell -y &>>$log_file
  func_stat_check $?
  func_print_head "Load Schema"
  mongo --host mongodb-dev.kruthikadevops.online </app/schema/${component}.js &>>$log_file
  func_stat_check $?
  fi
  if [ "$schema_setup" == "mysql" ]
  then
    func_print_head "Installing Mysql client"
      dnf install mysql -y &>>$log_file
      func_stat_check $?
      func_print_head "Loading schema"
      mysql -h mysql-dev.kruthikadevops.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
      func_stat_check $?
      func_systemd
    fi

}

func_systemd()
{
  func_print_head "copying service file to systemd"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_stat_check $?
    func_print_head "Staring ${component} service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component} &>>$log_file
    func_stat_check $?
}