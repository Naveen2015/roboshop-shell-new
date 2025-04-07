echo -e "\e[36m>>>>>>>>> configuring and downloading rabbitmq <<<<<<<<\e[0m"
dnf module disable redis -y
dnf module enable redis:6 -y
dnf install redis -y
echo -e "\e[36m>>>>>>>>> changing the configuration <<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf
echo -e "\e[36m>>>>>>>>> Enabling redis <<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis