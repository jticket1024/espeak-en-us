#!/bin/bash

#need root permission to proceed
if [[ $(whoami) != "root" ]] ; then
echo "This script needs root permissions."
exit 1
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

#copy files to espeak directory
echo "Copying files:"
cp ./en_* /usr/share/espeak-data/

#change to espeak directory and compile data
cd /usr/share/espeak-data/
espeak --compile=en-us
echo "files updated. Exiting."
exit 0

