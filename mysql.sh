echo -e "\e[36m>>>>>>>>> Installing Mysql <<<<<<<<\e[0m"
dnf module disable mysql -y
cp mysql.repo /etc/yum.repos.d/mysql.repo
dnf install mysql-community-server -y
echo -e "\e[36m>>>>>>>>> Staring Mysql <<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass RoboShop@1
