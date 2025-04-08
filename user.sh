source common.sh
echo -e "\e[36m>>>>>>>>> configuring and downloading nodejs <<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>> Creating Application User <<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>> Creating Application Directory <<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>> Downloading the app content <<<<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip app content <<<<<<<<\e[0m"
unzip /tmp/user.zip
echo -e "\e[36m>>>>>>>>> Downloading Nodejs dependencies <<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>> copying service file to systemd <<<<<<<<\e[0m"
cp /home/centos/roboshop-shell-new/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>> Staring user service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user