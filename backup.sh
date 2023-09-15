#!/usr/bin/env bash

#remote-backup
#v1.0.0
#by mattrattus
#https://mattrattus.github.io

#####################
### Configuration ###
#####################

#1
folders=(
    "${HOME}/folder_1" \
    "${HOME}/folder_2" \
    "${HOME}/folder_3") #<== setup

#2
port=22 #<== setup
#3
remote_server=login@ip-address #<== setup
#4
key=${HOME}/.ssh/default #<== setup
#5
remote_folder=/home/user/backup #<== setup

#####################

#Defaults
backup_folder=${HOME}/backup_remote
init_backup=${HOME}/backup_remote/init_backup.tar
default_backup=${HOME}/backup_remote/default_backup.tar

#Check if the defaults are in their places
[ -d $backup_folder ] || mkdir -p "$backup_folder"

[ -f $init_backup ] || tar cfP ${HOME}/backup_remote/init_backup.tar ${folders[*]} && gzip ${HOME}/backup_remote/init_backup.tar && rsync -aXA -e "ssh -p '$port' -i '$key'" ${HOME}/backup_remote/init_backup.tar.gz "$remote_server":"$remote_folder" && gunzip ${HOME}/backup_remote/init_backup.tar.gz

[ -f $default_backup ] || tar cfP ${HOME}/backup_remote/default_backup.tar ${folders[*]}

#Backup
tar cfP ${HOME}/backup_remote/current_backup.tar ${folders[*]}

diff -q ${HOME}/backup_remote/default_backup.tar ${HOME}/backup_remote/current_backup.tar

if [ $? -eq 0 ]; then
    rm ${HOME}/backup_remote/current_backup.tar

elif [ $? -eq 1 ]; then
    rm ${HOME}/backup_remote/default_backup.tar && cp ${HOME}/backup_remote/current_backup.tar ${HOME}/backup_remote/default_backup.tar && mv ${HOME}/backup_remote/current_backup.tar ${HOME}/backup_remote/backup_`date +%Y%m%d`.tar

#Compression
gzip ${HOME}/backup_remote/backup_`date +%Y%m%d`.tar

#rsync
rsync -aXA -e "ssh -p '$port' -i '$key'" ${HOME}/backup_remote/backup_`date +%Y%m%d`.tar.gz "$remote_server":"$remote_folder"

#Cleanup
rm ${HOME}/backup_remote/backup_`date +%Y%m%d`.tar.gz

fi

echo "Congratulations, the remote copy has been successfully made."