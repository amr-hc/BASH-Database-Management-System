#!/bin/bash
echo "------------------------------- WELCOME TO  DBMS -------------------------------"
echo " => PLZ write your sql code: "
echo "--------------------------------------------------------------------------------"
while true; do
	read -p "mysql->" REPLY
    case $REPLY in
        [cC][rR][eE][aA][tT][eE]\ [dD][aA][tT][aA][bB][aA][sS][eE]\ *)
        	nf=$(echo $REPLY | awk -F" " '{print NF}')
        	if [[ $nf -eq 3 ]]; then
        		
        		dir_name=$(echo $REPLY | awk -F" " '{print $3}')
			if [[ -e $dir_name ]]; then
				echo " this name is used "
			else
		
				if [[ ! "$dir_name" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]+$ ]]; then
					echo "the name must consist of { _ or character or number } but can't start with number or have a space in it"
				else
				
					mkdir "$dir_name"
	                		echo "Database '$dir_name' created."
				fi
			fi
        		
        	else
        		echo "Syntax Error."
        	fi
        	
            	;;
        [sS][hH][oO][wW]\ [dD][aA][tT][aA][bB][aA][sS][eE][sS])
            	echo "Listing All databases:"
            	echo "---------"
            	ls -d */ | sed 's:/$::'
		echo "---------"
            	;;
        [uU][sS][eE]\ *)
        	nf=$(echo $REPLY | awk -F" " '{print NF}')
        	if [[ $nf -eq 2 ]]; then
			dir_name=$(echo $REPLY | awk -F" " '{print $2}')
			if [ -d "$dir_name" ]; then
				clear
	    			./connect.sh $dir_name
			else
	    			echo "Database  "$dir_name" Not Found"
			fi
		else
        		echo "Syntax Error."
        	fi
	       	
            	;;
        [dD][rR][oO][pP]\ [dD][aA][tT][aA][bB][aA][sS][eE]\ *)
        	nf=$(echo $REPLY | awk -F" " '{print NF}')
        	if [[ $nf -eq 3 ]]; then
			dir_name=$(echo $REPLY | awk -F" " '{print $3}')
		    	rm -r "$dir_name"
		    	echo "Database '$dir_name' deleted."
            	else
        		echo "Syntax Error."
        	fi
           	;;
        [eE][xX][iI][tT])
            	echo "Exiting the DBMS."
            	exit 
            	;;
        *)
            	echo "Syntax Error."
    esac
    
done

