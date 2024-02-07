#!/bin/bash
echo "------------------------------- WELCOME TO  DBMS -------------------------------"
echo " => PLZ write your sql code: "
echo "--------------------------------------------------------------------------------"
while true; do
	read -p "mysql->" REPLY
    case $REPLY in
        create\ database\ *)
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
            	;;
        show\ databases)
            	echo "Listing All databases:"
            	echo "---------"
            	ls -d */ | sed 's:/$::'
		echo "---------"
            	;;
        use\ *)
		dir_name=$(echo $REPLY | awk -F" " '{print $2}')
		if [ -d "$dir_name" ]; then
			clear
    			./connect.sh $dir_name
		else
    			echo "Database  "$dir_name" Not Found"
		fi
	       	
            	;;
        drop\ database\ *)
        	dir_name=$(echo $REPLY | awk -F" " '{print $3}')
            	rm -r "$dir_name"
            	echo "Database '$dir_name' deleted."
           	;;
        exit)
            	echo "Exiting the DBMS."
            	exit 
            	;;
        *)
            	echo "Syntax Error."
    esac
    
done

