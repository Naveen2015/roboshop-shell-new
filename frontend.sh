script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Installing Nginx"
dnf install nginx -y &>>$log_file
func_stat_check $?
func_print_head "Copying nginx configuration"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?
func_print_head "Remove default content"
rm -rf /usr/share/nginx/html/*
func_print_head "Downloading and Unzip app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?
func_print_head "Starting Frontend Service" &>>$log_file
systemctl restart nginx
systemctl enable nginx
func_stat_check $?
