script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1
if [ -z "$rabbitmq_appuser_password" ]
then
echo "Rabbitmq password is missing"
exit
fi
component=payment
func_payment