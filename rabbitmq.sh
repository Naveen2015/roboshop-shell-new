script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1
if [ -z "$rabbitmq_appuser_password" ]
then
echo "Rabbitmq password is missing"
exit 1
fi

func_print_head  "Configuring rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
dnf install rabbitmq-server -y
func_print_head  "Adding rabbitmq user and permissions"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
func_print_head  "Starting Rabbitmq" &>>$log_file
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
func_stat_check $?