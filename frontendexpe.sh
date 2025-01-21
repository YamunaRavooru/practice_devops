#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
userid=$(id -u)
LOG_FOLDER="/var/log/expense_shelllog"
LOG_FILE=$(echo $0 |cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOG_FOLDER/$LOG_FILE-$TIMESTAMP.log"
validate () {
    if [ $1 -ne 0 ]
     then
       echo -e "$2....is $R failure$N"
      else
        echo -e  "$2......is $G Success$N"
    fi    
     }
     check_root ()  {
        if [ $userid -ne 0 ]
        then 
        echo -e "$R Erorr: Please take root acess to execute this script$N"
        exit 1
       fi 
    }
    mkdir -p /var/log/expense_shelllog
     echo -e "script start executing at :$TIMESTAMP "  &>>$LOG_FILE_NAME
     check_root
     dnf install nginx -y &>>$LOG_FILE_NAME
     validate $? "Installing nginx"
     systemctl start nginx &>>$LOG_FILE_NAME
     validate $? "start nginx"
     systemctl enable nginx &>>$LOG_FILE_NAME
     validate $? "enable nginx"
     rm -rf /usr/share/nginx/html/*  &>>$LOG_FILE_NAME
     validate $? "removing the existing version of the code"
     curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOG_FILE_NAME
     validate $? "Download the new code"
     cd /usr/share/nginx/html  &>>$LOG_FILE_NAME
     validate $? "moving to the html directory"
     unzip /tmp/frontend.zip  &>>$LOG_FILE_NAME
     validate $? "unzip the application"
     cp /home/ec2-user/practice_devops/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE_NAME
      validate $? "copy the expense.conf"
    systemctl restart nginx  &>>$LOG_FILE_NAME
    validate $? "restart the nginx"