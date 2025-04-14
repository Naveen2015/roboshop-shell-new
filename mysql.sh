script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
echo "Mysql password is missing"
exit 1
fi

func_print_head "Installing Mysql"
dnf module disable mysql -y &>>$log_file
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
dnf install mysql-community-server -y &>>$log_file
func_print_head "Staring Mysql"
systemctl enable mysqld
systemctl restart mysqld &>>$log_file
func_stat_check $?
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_stat_check $?
