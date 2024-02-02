#!/bin/bash

echo "DataBase Connected $1" 
source funcations.sh

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
			declare -a columns
    			declare -a types
			j=1
			while [ $columns_count -gt 0 ];
    			do
    				#echo "$columns_count"
				read -p "column name $j: " column_name
				catch_duplicate
				
				while [[ ! $column_name =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ || $find_column_name -eq 1 ]];
				do
					echo "Not Valid"
					read -p "column name $j: " column_name
					
					catch_duplicate
					
				done
				
				
    				echo -n "column type $j: "
    				echo
    				select choice in "alphate" "intger" "string"
				do
    					case $REPLY in
    					        1)
            						column_type=[a-z]
            						break
            						;;
            					2)
            						column_type=[0-9]
            						break
            						;;
            					3)
            						column_type=[a-zA-Z0-9]
            						break
            						;;
            					*)	echo "Not Valid"
    				    	esac
				done

    				types[$columns_count]=$column_type
    				if [ $columns_count -eq 1 ]; then
    					echo -n "$column_name" >> $1/$table_name
    					columns[$j]=$column_name
    				else
    					echo -n "$column_name:" >> $1/$table_name
    					columns[$j]=$column_name
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
			echo "which Column will be primary key? if you dont want primary key write 0"
    			select choice in "${columns[@]}"
    			do
    				case $REPLY in
        			[0-9]*)
        			if [ "${#columns[@]}" -ge "$REPLY" ]; then
        				echo >> $1/$table_name
		       			echo $REPLY >> $1/$table_name
		       			break
				else
					echo "Sorry Invalid option"
				fi
        			;;
        			*) echo "Sorry Invalid option";;
    				
    				
    				esac
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
    				let s=$(head -n 3 $1/$table_name | tail -n 1)
				value=$(echo $data | awk -F: '{print $'"$s"'}')
				let check=$(awk -F: 'BEGIN{found=0} {if(NR>3) if ($'"$s"' == "'$value'") found=1} END{print found}' $1/$table_name)
	                	if [[ $check -eq 0 ]]; then
					echo $data >> $1/$table_name
					echo "Insert Done"
				else
					echo "sorry Dublicate primary key"
				fi
			else
				echo "Error in Type of row"
			fi
			
    			
    		
		else
    			echo "Sorry table not found"
            	fi
            	
           	;;
        5)
        
            	
            	
            	read -p "enter table to select from: " table
            	select choice in "select all" "select by certien value"
            	do
            		case $REPLY in
            		1)
            			sed '2,3d' $1/$table
            			;;
            		2)
			    	if ! [ -e "$1/$table" ]; then
			    		echo " table doesn't exist"
			    	else
				    	read -p "enter value to select by it: " value

				    	result=$( sed '1,3d' $1/$table | awk -v value="$value" -F: '
				    	{
				    	        i=1;
				    	        line="";
				    		while(i<=NF){
				    			
				    			if($i==value){
				    				line=$0;
				    			}
				    			i++;
				    		}
				    		if(line != ""){
				    			print line;
				    		}
				    	}
				    	
				    	' )
				    	if [[ -z $result ]]; then
				    		echo " value ( $value ) doesn't exist in the table"
				    	else
				    		echo "$result"
				    	fi 
				  fi
				  ;;
			*)
				echo "invalid input"
			esac
			 
            	done
            	;;
        6)
            	echo "Exiting the software."
            	pwd
            	;;
        7)
            	echo "Exiting the software."
            	exit 0
            	;;
        *)
            	echo "Invalid option. Please try tgain."
    esac
done
