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
     dnf moduel disable nodejs -y   &>>$LOG_FILE_NAME
     validate $? "Disable the nodejs"
     dnf module enable nodejs:20 -y   &>>$LOG_FILE_NAME
     validate $? "Enable the nodejs:20"
     dnf install nodejs -y      &>>$LOG_FILE_NAME
     validate $?  "Install nodejs"
     id expense
     if [ $? -ne 0 ]
     then 
       useradd expense
       validate $? "adding expense user"
     else
       echo -e "Expense user is already exist....$Y skipping$N"
     fi  
     mkdir -p /app
     validate $? "App Directory is created"
     curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOG_FILE_NAME
     validate $? "Downloading the backend code"
     cd /app
     rm -rf /app/*
     unzip /tmp/backend.zip   &>>$LOG_FILE_NAME
     validate $? "unzip backend application"
     npm install  &>>$LOG_FILE_NAME
     validate $? "Installing dependencies "
     cp /home/ec2-user/practice_devops/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE_NAME
     systemctl daemon-reload  &>>$LOG_FILE_NAME
     validate $? "Demon-reload"
     systemctl enable backend  &>>$LOG_FILE_NAME
     validate $? "enable backend"
     systemctl start backend  &>>$LOG_FILE_NAME
     validate $? "start backend"
     dnf install mysql -y  &>>$LOG_FILE_NAME
     validate $? "mysql installing"
     mysql -h mysql.daws82s.cloud -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE_NAME
     validate $? "setting up the transaction schema and table"
      systemctl restart backend  &>>$LOG_FILE_NAME
     validate $? "restart backend"