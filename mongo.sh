script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> Configuring Mongodb repo<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>> Installing Mongodb <<<<<<<<\e[0m"
dnf install mongodb-org -y
echo -e "\e[36m>>>>>>>>> Changing Mongodb configuration <<<<<<<<\e[0m"
sed -i -e "s|127.0.0.1|0.0.0.0|" /etc/mongod.conf
echo -e "\e[36m>>>>>>>>> Starting Mongodb <<<<<<<<\e[0m"
systemctl enable mongod
systemctl restart mongod
