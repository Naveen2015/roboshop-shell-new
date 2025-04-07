echo -e "\e[36m>>>>>>>>> configuring and downloading nodejs <<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>> Creating Application User <<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>> Creating Application Directory <<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>> Downloading the app content <<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip app content <<<<<<<<\e[0m"
unzip /tmp/cart.zip
echo -e "\e[36m>>>>>>>>> Downloading Nodejs dependencies <<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>> Staring cart service <<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable cart
systemctl start cart