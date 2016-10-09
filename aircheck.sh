#!/bin/bash

#bbqcheck.sh

##### Wget from newwest bbq event listings on KCBS website
#creates file separated by pipe delimeter
#data format is as follows
#first date of event(event may be multiple day event)|Event Name|Location of event(general format is city, 2 letter state code)
#no guarentee on accuracy of international events


wget http://www.kcbs.us/events/new
#Wget to pull from new list of events at KCBQ

grep -e event new > trim1.txt
grep '<tr>' trim1.txt > cleanenough.txt
#grep with key words to clean up html a bit

cut -d '>' -f 7,15,17 cleanenough.txt > DraftFinal.txt
#cuts argument 7,15,17 parsed out by delimter '>'
#generally more data sanitization

sed 's/\<br \/\>/|/g' DraftFinal.txt > comma1.txt
#find and replaces additional html text from data, swaps out for delimeter '|'

sed 's/\<\/a\>/|/g' comma1.txt > comma2.txt
#find and replaces additional html text from data, swaps out for delimeter '|'

sed 's/\<\/td//g' comma2.txt > comma3.txt
sed 's/\<br \///g' comma3.txt > FinalCSV.txt
#Final cleanup and push to final csv file

#-----------------------------------------------------------

#Parse out states and check for desirable state events

while read input; 			#reads in FinalCSV.txt file for parsing
do	
	location=$(echo $input | tail -c 3)		#extracts the last 3 characters being state code and blank space

	case $location in		#casenotation to check for desirable states
		"md" | "MD" | "mD" | "Md")
		clear
			if ! grep -e "$input" exclude.txt; then
    			echo -e "New Event listed in Maryland! \n \n $input \n \n Search for it here: http://www.kcbs.us/events/new" | mail -s "BBQ Judging Event Notification" randallvstevens@gmail.com && echo $input >> exclude.txt
			fi
		;; #Maryland (md or MD) in location variable with email notification



		"ca" | "CA" | "cA" | "Ca")
		clear
			if ! grep -e "$input" exclude.txt; then
    			echo -e "New Event listed in California! \n \n $input \n \n Search for it here: http://www.kcbs.us/events/new" | mail -s "BBQ Judging Event Notification" randallvstevens@gmail.com && echo $input >> exclude.txt
			fi
		;; #California (ca or CA) in location variable with email notification
	esac	#End case 
done <FinalCSV.txt



#-----------------------------------------------------------
#clean up txt files below

rm -rf trim1.txt
rm -rf cleanenough.txt

rm -rf DraftFinal.txt
rm -rf FinalCSV.txt

rm -rf comma1.txt
rm -rf comma2.txt
rm -rf comma3.txt

rm -rf new*
