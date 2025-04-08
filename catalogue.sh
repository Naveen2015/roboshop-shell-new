script_path= $(dirname $0)
echo ${script_path}
exit
source common.sh
echo -e "\e[36m>>>>>>>>> configuring and downloading nodejs <<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>> Adding a Application User <<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>> Creating a Application Directory<<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>> Downloading Application Code<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip Application Code<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip
echo -e "\e[36m>>>>>>>>> Downloading nodejs dependencies <<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>> copying service file to systemd <<<<<<<<\e[0m"
cp /home/centos/roboshop-shell-new/catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[36m>>>>>>>>> Starting Catalogue service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
echo -e "\e[36m>>>>>>>>> Copying Mongodb repo file <<<<<<<<\e[0m"
cp /home/centos/roboshop-shell-new/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>> Downloading Mongodb <<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<\e[0m"
mongo --host mongodb-dev.kruthikadevops.online </app/schema/catalogue.js