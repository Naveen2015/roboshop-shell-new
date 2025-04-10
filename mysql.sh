script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
echo "Mysql password is missing"
fi

echo -e "\e[36m>>>>>>>>> Installing Mysql <<<<<<<<\e[0m"
dnf module disable mysql -y
cp mysql.repo /etc/yum.repos.d/mysql.repo
dnf install mysql-community-server -y
echo -e "\e[36m>>>>>>>>> Staring Mysql <<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld
mysql_secure_installation --set-root-pass RoboShop@1
