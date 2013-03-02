#!/bin/bash
#############################
#
#   ! RARCURSIVE !
#
# Brought to you By:
#
#     MERRY-O Productions
#
# Licensed Under:
#
#     THE GPL
#############################
#This program will recursively unrar rar files to the directory in which they reside.
#Usage:  rarcursive [directory (required,to scan recursively)] [delete (optional)]
#############################

#This badrar needs to be set..dont ask.
badrar=0
if [ -z $1 ]; then
echo "WTF!!....I need arguments!@#%@#$^:::TRY:::# rarcursive.sh [directory] [delete]"
fi

find "$1" -type f -regex .*\.rar$ | while read rarloc
do

storeloc=$(find "$rarloc" -printf "%h")
#test to see if the rar is part of a series (part002,3,etc..)
test=$(echo "$rarloc" | egrep '.*part(00[2-9]|0[1-9][0-9]|[1-9][0-9][0-9])\.rar')

#Another test for a part02,3 etc.. type rared file
test2=$(echo "$rarloc" | egrep '.*part(0[2-9]|[1-9][0-9])\.rar')


#If it is not, lets perform our operations. If it is, disgard it and move on to next result.
if [ -z "$test" -a -z "$test2" ]; then

echo "A legit rar"
#Check the archive then decide.
unrar t "$rarloc"

	if [ "$?" == 0 ]; then
		#Everything went good.
		unrar x "$rarloc" "$storeloc"
		if [ "$?" == 0 ]; then
			#The Following delete statement would not actually work if there were more than one .rar archive in the same dir (multiple items) as it would delete all rars in the given dir. 
			#This should be moved out of this loop and at the end as long as every rar was extracted successfully then delete. Or this should do more checking for only the 
			#rars that were just extracted successfully (probably the better option)...Not usually a big deal but something to think about for later...
			if [ "$2" == "delete" ]; then
				find "$storeloc" -type f -regex .*\.r..$ -delete
			fi

		else
			badrar=12
		fi

	else
		echo "We have a problem with the rar's in $storeloc"
		badrar=12
	fi

else

echo "Just part of a series...skipping"

fi

done
exit $badrar
