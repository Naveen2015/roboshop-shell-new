script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Configuring Mongodb repo"
cp mongo.repo /etc/yum.repos.d/mongo.repo
func_print_head "Installing Mongodb"
dnf install mongodb-org -y &>>$log_file
func_print_head "Changing Mongodb configuration"
sed -i -e "s|127.0.0.1|0.0.0.0|" /etc/mongod.conf
func_print_head "Starting Mongodb"
systemctl enable mongod
systemctl restart mongod
