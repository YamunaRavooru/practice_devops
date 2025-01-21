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
     dnf moduel disable nodejs -y  &>>$LOG_FILE_NAME
     validate $? "Disable the nodejs"
     dnf module enable nodejs:20 -y 
     validate $? "Enable the nodejs:20"
     dnf install nodejs -y
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
     curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
     validate $? "Downloading the backend code"
     cd /app
     unzip /tmp/backend.zip
     validate $? "unzip backend application"
     npm install
     validate $? "Installing dependencies "
     cp /home/ec2-user/practice_devops/backend.service /etc/systemd/system/backend.service
     systemctl daemon-reload
     validate $? "Demon-reload"
     systemctl enable backend
     validate $? "enable backend"
     systemctl start backend
     validate $? "start backend"
     dnf install mysql -y
     validate $? "mysql installing"
     mysql -h mysql.daws82s.cloud -uroot -pExpenseApp@1 < /app/schema/backend.sql
     validate $? "setting up the transaction schema and table"
      systemctl restart backend
     validate $? "restart backend"