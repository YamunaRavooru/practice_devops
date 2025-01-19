#!/bin/bash
mkdir -p  var/log/shell_logs
Source_dirc="/home/ec2-user/app-log"
Dest_dirc="/var/log/Shell_logs"
File_Name=$( $0 | cut -d '.' -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
Delete_files= "$Dest_dirc/$File_Name-$TIMESTAMP.log"

user=$(id -u)
if [ $user -ne 0 ]
then
  echo Root user only acess this script:  
  exit 1
fi

