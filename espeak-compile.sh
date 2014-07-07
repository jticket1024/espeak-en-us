#!/bin/bash

#make sure this script is not started as root cause it can mess up read/write perms on the directory
if [[ $(whoami) == "root" ]] ; then
    echo "this script should not be initiated as root. It will copy files using sudo."
exit 0
fi

#check for updates.
git pull

#make sure all required files are present
if [ ! -f "en_extra" -o ! -f "en_list" -o ! -f "en_rules" ] ; then
echo "Missing files, exiting."
exit 1
fi

if [ ! -d "/usr/share/espeak-data/" ] ; then
echo "Destination directory missing, exiting."
exit 1
fi

#need root permission to proceed
echo "Copying files:"
#copy files to espeak directory
sudo cp ./en_* /usr/share/espeak-data/
#change to espeak directory and compile data
cd /usr/share/espeak-data/
sudo espeak --compile=en-us
echo "files updated."
serviceName="$(systemctl --no-pager --all | grep -E espeakup.*service | cut -d " " -f3)"
if [ -n "$serviceName" ] ; then
    read -n 1 -p "Restart $serviceName? " restart
    if [ "${restart^}" == "Y" ] ; then
        sudo systemctl restart $serviceName
    fi
fi
echo
exit 0
