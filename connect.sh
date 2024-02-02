#!/bin/bash

echo "DataBase Connected $1" 

select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table"
do
    case $REPLY in
        1)
            	read -p "Enter table name: " table_name
            	if [ -e "$1/$table_name" ]; then
    			echo "Sorry there is table have same name"
		else
    			touch $1/$table_name
    			
    			read -p "What is the number of columns in the table : " columns_count
			while (( $columns_count <= 0 ))
			do
				read -p "What is the number of columns in the table : " columns_count
			done
    			declare -a types
			j=1
			while [ $columns_count -gt 0 ];
    			do
    				#echo "$columns_count"
				read -p "column name $j: " column_name
    				read -p "column type $j: " column_type

    				types[$columns_count]=$column_type
    				if [ $columns_count -eq 1 ]; then
    					echo -n "$column_name" >> $1/$table_name
    				else
    					echo -n "$column_name:" >> $1/$table_name
    				fi

				((j++))
    				((columns_count--))

    			done
    			echo >> $1/$table_name
    			let i=${#types[@]}
    			echo $i
    			while [ $i -gt 0 ];
    			do
    				if [ $i -eq 1 ]; then
    					echo -n "${types[$i]}" >> $1/$table_name
    				else
    					echo -n "${types[$i]}:" >> $1/$table_name
    				fi

    				((i--))
			done

    			
    			
    			
    			echo "Table '$table_name' created."
		fi
            	
            	;;
        2)
            	echo "tables in database are: "
            	ls  $1
            	;;
        3)
		read -p "Enter a table name : " name
            	cd $1
		if [ -e $name ]; then
		       rm $name
		else
			echo "table doesn't exist"
		fi
            	;;
        4)

            	
            	read -p "insert into table name: " table_name
            	if [ -e "$1/$table_name" ]; then
    			read -p "insert data : " data
    			
    			let erro=0
    			let n=1
    			let nf=$(head -n 2 $1/$table_name | tail -n 1 | awk -F: '{print NF}')
    			((nf++))
			while [ $nf -gt $n ];
    			do
    			right=$(head -n 2 $1/$table_name | tail -n 1 | awk -F: '{print $'"$n"'}')
    			left=$(echo $data | awk -F: '{print $'"$n"'}')
			if [[ ! $left =~ $right ]]; then
	                	((erro++))
			fi
			((n++))
			done
			
    			if [[ $erro -eq 0 ]]; then
	                	echo $data >> $1/$table_name
	                	echo "Insert Done"
			else
				echo "Error in Type of row"
			fi
    			
    		
		else
    			echo "Sorry table not found"
            	fi
            	
           	;;
        5)
            	echo "Exiting the software."
            	exit 0
            	;;
        6)
            	echo "Exiting the software."
            	exit 0
            	;;
        7)
            	echo "Exiting the software."
            	exit 0
            	;;
        *)
            	echo "Invalid option. Please try tgain."
    esac
done

