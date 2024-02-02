#!/bin/bash

select choice in "Create Database" "List Databases" "connect to Database" "Drop Database" "Exit"
do
    case $REPLY in
        1)
            	read -p "Enter database name: " dir_name
		if [[ -e $dir_name ]]; then
			echo " this name is used "
		else
			if [[ $dir_name = [a-z]* || $dir_name = [A-Z]* || $dir_name = _* ]]; then
				mkdir "$dir_name"
	                	echo "Database '$dir_name' created."
			else
				echo "invalid name, the name sould start with { _ or character }"
			fi
		fi
            	;;
        2)
            	echo "Listing All databases:"
            	ls -d */
            	;;
        3)
		read -p "Enter Database to connect: " dir_name
            	#cd "$dir_name" || echo "Directory not found."

		if [ -d "$dir_name" ]; then
    			./connect.sh $dir_name
		else
    			echo "Database Not Found"
		fi
	       	
            	;;
        4)
		read -p "Enter database name: " dir_name
            	rm -r "$dir_name"
            	echo "Database '$dir_name' deleted."
           	;;
        5)
            	echo "Exiting the software."
            	exit 0
            	;;
        *)
            	echo "Invalid option. Please try tgain."
    esac
done

