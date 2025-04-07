echo -e "\e[36m>>>>>>>>> Configuring rabbitmq <<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
dnf install rabbitmq-server -y
echo -e "\e[36m>>>>>>>>> Adding rabbitmq user and permissions <<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
echo -e "\e[36m>>>>>>>>> Starting Rabbitmq <<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server