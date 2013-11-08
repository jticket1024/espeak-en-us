#!/bin/bash

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
if [[ $(whoami) != "root" ]] ; then
#copy files to espeak directory
sudo cp ./en_* /usr/share/espeak-data/
#change to espeak directory and compile data
cd /usr/share/espeak-data/
sudo espeak --compile=en-us
echo "files updated."
read -n 1 -p "Restart espeakup using systemctl? " restart
if [ "${restart^}" == "Y" ] ; then
serviceName="$(systemctl --no-pager | grep espeakup | head -n 1 | cut -d " " -f1)"
sudo systemctl restart $serviceName
fi
else
#copy files to espeak directory
cp ./en_* /usr/share/espeak-data/
#change to espeak directory and compile data
cd /usr/share/espeak-data/
espeak --compile=en-us
echo "files updated."
read -n 1 -p "Restart espeakup using systemctl? " restart
if [ "${restart^}" == "Y" ] ; then
serviceName="$(systemctl --no-pager | grep espeakup | head -n 1 | cut -d " " -f1)"
systemctl restart $serviceName
fi
fi
echo
exit 0
