script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> Installing Maven <<<<<<<<\e[0m"
dnf install maven -y
echo -e "\e[36m>>>>>>>>> Adding Application User <<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>> Creating Application Folder <<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>> Downloading app content <<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip app content <<<<<<<<\e[0m"
unzip /tmp/shipping.zip
echo -e "\e[36m>>>>>>>>> maven build <<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m>>>>>>>>> Installing Mysql<<<<<<<<\e[0m"
dnf install mysql -y
echo -e "\e[36m>>>>>>>>> Loading schema <<<<<<<<\e[0m"
mysql -h mysql-dev.kruthikadevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
echo -e "\e[36m>>>>>>>>> copying service file to systemd <<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>> Staring Shipping service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping