#!/bin/bash -e
cd

if [ -d .dotfiles ]
then
	find . -maxdepth 1 -type l | while read SRC
	do
    	DST="`echo "$SRC" | sed -e 's#.*/##'`"
		if [ -f ".dotfiles/$DST" ]
		then
			echo "Removing $DST"
			rm -rf $DST
		fi
	done
else
	echo "Nothing to uninstall!"
fi