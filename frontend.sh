echo -e "\e[36m>>>>>>>>> Installing Nginx <<<<<<<<\e[0m"
dnf install nginx -y
echo -e "\e[36m>>>>>>>>> Copying nginx configuration <<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[36m>>>>>>>>> Remove default content <<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[36m>>>>>>>>> Downloading and Unzip app content <<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[36m>>>>>>>>> Starting Frontend Service <<<<<<<<\e[0m"
systemctl restart nginx
systemctl enable nginx
