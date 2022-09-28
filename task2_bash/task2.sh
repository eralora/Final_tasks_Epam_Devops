#!/bin/bash

#Using gsub() to add commas to make text file suitable to convert and make temproary

awk -F' ' '{gsub(/expecting/, ", expecting"); gsub(/ok/, "ok,"); gsub(/, /, ","); print}' ./$1  > ./tmp.txt 

#Make variable which store name of test. Name of test inside of the sqare brackets so I use -F'[][]'  

name=`awk -F'[][]' '{print $2}' ./tmp.txt`

#Print first curly brackets then print the name of the script inside of json file

echo { > ./output.json 
echo "  " "testName": "$name," >> ./output.json

#Now converting body of text and save it inside of .json file

awk -F',' 'BEGIN{print $name ; print  "\"tests\":" " " "[" ; }   

	{ if ($1 == "not ok")
		{
	         print  " {""\n"		                  \
                   "   \"Name\" : \"" $3 "\",\n"                  \
                   "   \"status\" : \""   "false"  "\",\n"        \
                   "   \"duration\" : \""  $NF  "\"\n"            \
                   " }"                                           \
                                                                
                }   			
	
	  else if ($1 == "ok")
		   
		{

                 print  " {""\n"                                  \
                  "   \"Name\" : \"" $3 "\",\n"                   \
                  "   \"status\" : \""   "true"  "\",\n"          \
                  "   \"duration\" : \""  $NF  "\"\n"             \
                  " }"                                            \
							     	
                }				              

}

END{print "],"}' ./tmp.txt >> ./output.json

#Converting end of file and store in .json file

awk -F"[ , ][ ,]*" 'END{print  "\"summary\"" ":" " {"	          \
           "  \"Success\" : \"" $1 "\",\n"                        \
           "   \"failed\" : \""  $6  "\",\n"                      \
           "   \"rating\" : \""  $11  "\",\n"                     \
	   "   \"duration\" : \""  $NF  "\"\n"                    \
	   " }"							  \
		
   }' ./tmp.txt  >> ./output.json

#Last curly brackets 

echo }  >> ./output.json

#Remove tmp file

rm ./tmp.txt


