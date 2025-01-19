#!/bin/bash
Source_dirc="/var/log/shell-log"
File_name=$(echo $0 |cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
Log_files="$Source_dirc/$File_name-$TIMESTAMP.log"
D_Dir=$2
S_Dir=$1
Days=${3:-14}
if [ $# -lt 2 ]
then
  echo "Usage: sh backup <S_Dir> <D_Dir> days <optional>"
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