#!/bin/bash

#bbqcheck.sh

##### Wget from newest flight deals in US from secretflying.com
#creates file separated by pipe delimeter
#data format is as follows
####first date of event(event may be multiple day event)|Event Name|Location of event(general format is city, 2 letter state code)

wget http://www.secretflying.com/usa-deals
#Wget to pull webpage of newest items 

grep -e '_blank' usa-deals > trim1.txt						#greps keyword for initial data isolation
grep -e 'spacial-icons-container' trim1.txt > trim2.txt		#greps for special CSS comtained to better isolate data
cut -d '"' -f 2,4 trim2.txt > trim3.txt						#Using """ as the delimeter, parse out the 2nd and 4th in the list
sed 's/\"/|/g' trim3.txt > trim4.txt 						#replace """ with "|" to better parse 
sed 's/&amp;/\&/g' trim4.txt > Final.txt 					#sed command to replace "&amp;" html with acual ampersand symbol "&"


#-----------------------------------------------------------

#Parse out states and check for desirable flights

while read input; 			#reads in Final.txt file for parsing
do	
	
	title=$(echo $input|cut -d '|' -f2)		#extracts the second/last element in the short list which is the title
	#htmllink=$(echo $input|cut -d '|' -f1)	#extracts the second/last element in the short list which is the link
	
	if [[ $title == *"CHICAGO"* ]]
		then
  		echo "Fights relate to CHICAGO";
	fi

	if [[ $title == *"WASHINGTON DC"* ]]
		then
  		echo "Fights relate to WASHINNGTON DC";
	fi

	if [[ $title == *"LOS ANGELES"* ]]
		then
  		echo "Fights relate to LOS ANGELES";
	fi

	if [[ $title == *"BALTIMORE"* ]]
		then
  		echo "Fights relate to BALTIMORE";
	fi

	
done <FinalTest.txt




#------------Clean Up Files---------------

rm -rf usa-deals*
rm -rf trim*