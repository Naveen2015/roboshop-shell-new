echo -e "\e[36m>>>>>>>>> Installing Python <<<<<<<<\e[0m"
dnf install python36 gcc python3-devel -y
echo -e "\e[36m>>>>>>>>> Adding Application User <<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>> Creating Application Folder <<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>> Downloading app content <<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip app content <<<<<<<<\e[0m"
unzip /tmp/payment.zip
echo -e "\e[36m>>>>>>>>> Installing Python dependencies <<<<<<<<\e[0m"
pip3.6 install -r requirements.txt
echo -e "\e[36m>>>>>>>>> Staring Payment Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment