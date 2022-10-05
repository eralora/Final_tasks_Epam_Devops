#!/bin/bash

#Using gsub() to add commas to make text file suitable to convert and make temproary

awk -F' ' '{gsub(/expecting/, ",\"expecting"); gsub(/ok/, "ok,"); gsub(/, /, ","); gsub("\\)", ")\""); gsub(/,bats/, ", bats"); gsub("\\[ ", "["); gsub(" \\]", "]"); print}' ./$1  > ./tmp.txt 

#Make variable which store name of test. Name of test inside of the sqare brackets so I use -F'[][]'  

name=`awk -F'[][]' '{print $2}' ./tmp.txt`

#Print first curly brackets then print the name of the script inside of json file
#UPDATE! Name was without double quotes then I add "\" ... \" and it solve that issue 
echo { > ./output.json 

awk -v n="$name" BEGIN'{print "\"testName\":\"" n "\"," }' ./tmp.txt  >> ./output.json

#UPDATE! Summ of tests 
num_of_tests=`awk -F"[ , ][ ,]*" 'END{print $1 + $6}' ./tmp.txt`

#Now converting body of text and save it inside of .json file
#UPDATE! Add additional "if-else" statement to find last test using id($2) then remove comma after curly bracket "}"
awk -v x="$num_of_tests" -vFPAT='([^,]*)|("[^"]+")'  'BEGIN{print  "\"tests\":""""[" ; }   

	{ if ($1 == "not ok")
		{	
		 if ($2 == x)
			{
				print  " {""\n"                                  \
                   		"   \"name\":"$3",\n"                            \
                   		"   \"status\":false,\n"            \
                   		"   \"duration\":\""  $NF  "\"\n"                \
                   		" }"                                             \

			}

		   else {
	        		print  " {""\n"		                         \
                   		"   \"name\":"$3",\n"                            \
                   		"   \"status\":false,\n"            \
                   		"   \"duration\":\""  $NF  "\"\n"                \
                   		" },"                                            \
			}                                          
                }   			
	
	  else if ($1 == "ok")
		{
			
		   if ($2 == x)
                         {
                                print  " {""\n"                                  \
                  		"   \"name\":"$3",\n"                            \
                  		"   \"status\":true,\n"             \
                  		"   \"duration\":\""  $NF  "\"\n"                \
                  		" }"                                             \

                         }
		    else {

				print  " {""\n"                                  \
                  		"   \"name\":"$3",\n"                            \
                  		"   \"status\":true,\n"             \
                  		"   \"duration\":\""  $NF  "\"\n"                \
                  		" },"				         	 \

		         }
							     	
                }				              

}

END{print "],"}' OFS=,  ./tmp.txt >> ./output.json

#Converting end of file and store in .json file
#UPDATE! Add "CONVFMT="%.2f"" to round up 2 decimal point
awk  -F"[ , ][ ,]*" -v CONVFMT="%.2f" 'END{printf  "\"summary\"" ":""{""\n"	                         \
           "   \"success\":"$1",\n"                                        \
           "   \"failed\":"$6",\n"                                       \
	   "   \"rating\":"$1 / ($1 + $6) * 100",\n"                                      \
	   "   \"duration\":\""  $NF  "\"\n"                                     \
	   " }"							                 \
		
   }' ./tmp.txt  >> ./output.json

#Last curly brackets 

echo }  >> ./output.json


#Remove tmp file

rm ./tmp.txt


