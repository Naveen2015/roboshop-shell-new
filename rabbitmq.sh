script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

echo -e "\e[36m>>>>>>>>> Configuring rabbitmq <<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
dnf install rabbitmq-server -y
echo -e "\e[36m>>>>>>>>> Adding rabbitmq user and permissions <<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
echo -e "\e[36m>>>>>>>>> Starting Rabbitmq <<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server