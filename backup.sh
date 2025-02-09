#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Source_dirc="/var/log/shell_logs"
File_name=$(echo $0 | awk -F "/" '{print $NF}'|cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
Log_files="$Source_dirc/$File_name-$TIMESTAMP.log"
D_Dir=$2
S_Dir=$1
Days=${3:-14}
userid=$( id -u )
# check_root (){
#     if [ $userid -ne 0 ]
#     then 
#      echo -e "$R Erorr: please take root acess to run this script $N"
#      exit 1
#      fi
# }
# check_root 
mkdir -p /var/log/shell_logs
if [ $# -lt 2 ]
then
  echo -e " $R Usage:  sh backup <S_Dir> <D_Dir> <days (optional)>$N" 
  exit 1
fi  
if [ ! -d  "$S_Dir" ]
then
  echo "$S_Dir does not exist.... please check  "
  exit 1
fi  
if [ ! -d  "$D_Dir" ]
then
  echo "$D_Dir does not exist.... please check  "
  exit 1
fi  
echo -e "script start executing at:$TIMESTAMP"   &>>$Log_files
files=$(find $S_Dir -name "*.log" -mtime +$Days) 

if [ -n  "$files" ]
then
     echo "Deleted files :$files"
     Zip_file="$D_Dir/app_log-$TIMESTAMP.zip"  &>>$Log_files
    find $S_Dir -name  "*.log" -mtime +$Days | zip -@  "$Zip_file" &>>$Log_files
  if [ -f  "$Zip_file" ]
  then
      echo -e "Zip file is $Y sucessfully $N created older than $Days..."
     while read -r name
    do
     echo -e " deleting files:$files" &>>Log_files
     rm -rf $files 
     echo "deleted file:$files"

    done <<< $files
  else
    echo -e "$R ERORR: Failed to create zip file $N"
 fi   
else 
  echo -e  "$N No files are found to delete older than $Days"
fi    
