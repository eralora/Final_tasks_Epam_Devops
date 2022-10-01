#!/bin/bash



#Get three columns from csv_file and send output to right side of pipe | get first letter of Name and merge with Surname + location_id + just ID, make it all lowercase. Put outputs to tmp1.txt

awk -F',' '{print $3,$2,$1}' ./"$1" | awk '{print tolower(substr($1,1,1) $2)","$3","$4}' > ./tmp.csv

#Checking if there any duplicated values in column if yes so add location_add + appropriate domain, else just add domain name. Also add  additional column ID. Put output to tmp2.csv file

awk -F, 'NR==FNR {

	A[$1,$4]++; next

}

{
	if (A[$1,$4]>1) 
		{
		       	print $1 $2 "@abc.com"","$3
		} 
	
	else 
		{
		
			print $1 "@abc.com"","$3
		
		}

}'  ./tmp.csv ./tmp.csv > ./tmp1.csv


#Add created email address from tmp.csv -> accounts.csv's 5th column via ID's.Use " -vFPAT='([^,]*)|("[^"]+")'" this to ignore comma's in quotes from 'title' column

awk -vFPAT='([^,]*)|("[^"]+")' 'FNR==NR{a[$2]=$1;next} $1 in a{$5=a[$1]} 1' OFS=, ./tmp1.csv ./"$1" > ./tmp2.csv

#Make Name and Surname's first letter uppercase

awk -F, -v OFS=, '
  NF >= 3 {
    n = patsplit($3, f, /[[:alnum:]]+/, s)
    $3 = s[0]
    for (i = 1; i <= n; i++)
      $3 = $3 toupper(substr(f[i], 1, 1)) \
              substr(f[i], 2) s[i]
  }
  1' ./tmp2.csv > tmp3.csv

#UPGRADE! Changing Name >>> name. In code above all column value's first letter became uppercase also title 'name'.
awk -F' ' '{gsub(/Name/, "name"); print}' ./tmp3.csv > ./accounts_new.csv 

#Delete all tmp* files
rm ./tmp.csv ./tmp1.csv ./tmp2.csv ./tmp3.csv


