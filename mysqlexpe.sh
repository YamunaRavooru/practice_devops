#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
userid=$(id -u)
LOG_FOLDER="/var/log/expense_shelllog"
LOG_FILE=$(echo $0 |cut -d "." -f1)
TIMESTAMP=$(date -%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOG_FOLDER/$LOG_FILE-$TIMESTAMP.log"
validate () {
    if [ $1 -ne 0 ]
     then
       echo -e "$2....is $R failure$N"
      else
        echo -e  "$2......is $G Success"
    fi    
     }
     check_root() {
        if [ $userid -ne 0 ]
        then 
        echo -e "$R Erorr: Please take root acess to execute this script$N"
        exit 1
     }
     echo -e "script start executing at :$TIMESTAMP "  &>>$LOG_FILE_NAME
     check_root
     dnf install mysql-server -y  &>>$LOG_FILE_NAME
     validate $? "installing mysql-server"
     systemctl enable mysqld 
     validate $? "enable mysql"
     systemctl start mysqld
     validate $? "start mysql"
