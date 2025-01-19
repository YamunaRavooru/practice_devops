#!/bin/bash
Source_dirc="/var/log/shell-log"
File_name=$(echo $0 |cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
Log_files="$Source_dirc/$File_name-$TIMESTAMP.log"
D_Dir=$1
S_Dir=$2
Days=${$3:-14}
if [ $# -lt 2 ]
then
  echo "Usage: sh backup <S_Dir> <D_Dir> days <optional>"
  exit 1
fi  