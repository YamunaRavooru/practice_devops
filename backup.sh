#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
Source_dirc="/var/log/shell-log"
File_name=$(echo $0 |cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
Log_files="$Source_dirc/$File_name-$TIMESTAMP.log"
D_Dir=$2
S_Dir=$1
Days=${3:-14}
if [ $# -lt 2 ]
then
  echo -e " $R Usage: $N sh backup <S_Dir> <D_Dir> <days (optional)>" &>>Log_files
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
echo -e "script start executing at:$TIMESTAMP"   
Files=$(find $S_Dir -name "*.log" -mtime +$Days) 

if [ -n  "$Files" ]
then
     echo "Deleted files :$Files"
     Zip_file="$D_Dir/app-log-$TIMESTAMP.zip"  &>>Log_files
    find $S_Dir -name  "*.log" -mtime +$Days | zip -@  "$Zip_file" &>>Log_files
  if [ -f  "$Zip_file" ]
  then
      echo -e "Zip file is $Y sucessfully $N created older than $Days..."
      while read -r  $name
      do 
       echo -e " deleting files:$name" 
        rm -rf  $name
       echo "after removing files: $name"  
      done << $Files
  else
    echo -e "$R ERORR: $N Failed to create zip file"
 fi   
else 
  echo "No files are found to delete older than $Days"
fi    
