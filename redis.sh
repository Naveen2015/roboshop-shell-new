script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "configuring and downloading redis"
dnf module disable redis -y &>>$log_file
dnf module enable redis:6 -y &>>$log_file
dnf install redis -y &>>$log_file
func_stat_check $?
func_print_head "changing the configuration"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
func_stat_check $?
func_print_head "Enabling redis"
systemctl enable redis
systemctl restart redis