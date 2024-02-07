#!/bin/bash

echo "DataBase $1" 
source funcations.sh
echo "--------------------------------------------------------------------------------"
select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "return to select database" "Exit"
do
    case $REPLY in
        1)
            	read -p "Enter table name: " table_name
            	if [[ ! "$table_name" =~ ^[a-zA-Z]+[a-zA-Z0-9_]*$ ]]; then
				echo "Table names must start with a letter and can contain letters, numbers, or underscores"
            	elif [[ -e "$1/$table_name"  ]]; then
    			echo "Sorry there is table have same name"
		else
    			
    			read -p "What is the number of columns in the table : " columns_count
			if [[ $columns_count =~ [0-9]+ ]]; then
				touch $1/$table_name
				while (( $columns_count <= 0 )) 
				do
					echo "coulmns number must be positive"
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
					
					while [[ ! $column_name =~ ^[a-zA-Z]+[a-zA-Z0-9_]*$ || $find_column_name -eq 1 ]];
					do
						if [[ $find_column_name -eq 1 ]]; then
							echo "This column name already Exist"
						else
							echo "Column names must start with a letter and can contain letters, numbers, or underscores"
						fi
						read -p "column name $j: " column_name
						
						catch_duplicate
						
					done
					
					
	    				echo -n "column type $j: "
	    				echo
	    				select choice in "alphate" "intger" "string"
					do
	    					case $REPLY in
	    					        1)
		    						column_type=[a-zA-Z]
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
		    					*)	echo "Not Valid Must choice from 3 types"
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

				echo "which Column will be primary key? "
	    			select choice in "${columns[@]}"
	    			do
	    				case $REPLY in
					[1-9]*)
					if [ "${#columns[@]}" -ge "$REPLY" ]; then
						echo >> $1/$table_name
			       			echo $REPLY >> $1/$table_name
			       			break
					else
						echo "you should choose from the provided columns"
					fi
					;;
					*) echo "Invalid option, you must select from columns in the table";;
	    				
	    				
	    				esac
	    			done
	    			
	    			unset types
    				unset columns
	    			echo "Table '$table_name' created."
	    			sleep 2
	    			clear
	    			./connect.sh $1
	    		else
	    			echo "columns count must be a number"
	    			
	    		fi

		fi
            	
            	;;
        2)
            	echo "tables in database are: "
            	echo "---------"
            	ls  $1 | sed ''
            	echo "---------"
            	read -p "press a key to continue. " input
            	clear
            	./connect.sh $1
            	;;
        3)
		read -p "Enter a table name : " name

		if [ -e "$1/$name" ]; then
		       rm "$1/$name"
		       echo "table $name deleted"
		       sleep 2
		       clear
		       ./connect.sh $1
		else
			echo "table doesn't exist"
			sleep 4
		       	clear
			./connect.sh $1
		fi
            	;;
        4)

            	
            	read -p "insert into table name: " table_name
            	if [ -e "$1/$table_name" ]; then
            		echo -e "columns of this table are: \n" 
            		echo -e " 			$( sed -n '1p' "$1/$table_name" )\n"
    			read -p "insert data as that formate: " data
    			
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
    				let primaryKey=$(head -n 3 $1/$table_name | tail -n 1)
				value=$(echo $data | awk -F: '{print $'"$primaryKey"'}')
				let check=$(awk -F: 'BEGIN{found=0} {if(NR>3) if ($'"$primaryKey"' == "'$value'") found=1} END{print found}' $1/$table_name)
	                	if [[ $check -eq 0 ]]; then
					echo $data >> $1/$table_name
					echo "Insert Done"
					sleep 3
					clear
					./connect.sh $1
				else
					echo "sorry Dublicate primary key"
				fi
			else
				echo "values entered don't match datatype of columns"
			fi
			
    			
    		
		else
    			echo "Sorry table not found"
            	fi
            	
           	;;
        5)

            	read -p "enter table to select from: " table
            	if ! [ -e "$1/$table" ]; then
            		echo " table doesn't exist"
            	else
		    	select choice in "select all" "select by certien value" "back to table menu"
		    	do
		    		case $REPLY in
		    		1)		
		    				rowCount=$( wc -l < "$1/$table" )
		    				if (( rowCount <= 3 )); then 
		    					echo "table is empty"
		    				else
			    				sed '2,3d' $1/$table
			    			fi
			    			;;
		    		2)

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
					    		echo " the value ( $value ) doesn't exist in the table"
					    	else
					    		echo "$result"
					    	fi 
					  
					  	;;
				3)		
						clear
						./connect.sh $1
						;;
				*)
						echo "invalid option"
						;;
				esac
				 
		    	done
		    fi
            	;;
        6)
        	read -p "enter table to delete from: " table
            	if ! [ -e "$1/$table" ]; then
            		echo " table doesn't exist"
            	else
            		declare -a columns_names=$(awk -F: '
            		{
            			j=1;
            			if(NR == 1)
            			{
		    			while(j<=NF)
		    			{
			    		columns_names[j]=$j;
			    		print columns_names[j];
			    		++j;
		    		
		    			}
            			}
            			}
            		' $1/$table)
            		
			nf=$(awk -F: '
			{
				j=1;
				if(NR == 1)
				{print NF}
			}
			' $1/$table)
            		select choice in ${columns_names[@]}
            		do
    				case $REPLY in
    				0)
    					echo "you must select from provided option"
    					
    					;;
        			[0-9]*)
        			if [ $nf -ge "$REPLY" ]; then
        				
		       			read -p "enter a value to delete : " value
		       			
		       			declare matched_Rows=$(awk -F: '
		       			{
		       				j="'$REPLY'";
		       			{
		       				if($j == "'$value'" && NR > 3)
		       			 	print NR
		       			}
		       			}
		       			' $1/$table)

					
					if [ -n "$matched_Rows" ]; then
						IFS=' ' 
						declare -a row_numbers=($matched_Rows)
    						sed -i "$(printf '%sd;' "${row_numbers[@]}")" "$1/$table"
    						echo "Deleted Done."
    						sleep 3
    						clear
    						./connect.sh $1
					else
    						echo "Not found any matched"
					fi
					
					unset matched_Rows
    					unset row_numbers

		       			break
				else
					echo "you must select from provided option"
				fi
        				;;
        			*) echo "you must select from provided option"
        				;;
    				
    				
    				esac
            		done

            	fi
            	
            	;;
        7)
        	read -p "enter table to update from: " table
            	if ! [ -e "$1/$table" ]; then
            		echo " table doesn't exist"
            	else
            		declare -a columns_names=$(awk -F: '{j=1;if(NR == 1){while(j<=NF){columns_names[j]=$j;print columns_names[j];++j}}}' $1/$table)
			nf=$(awk -F: '{j=1;if(NR == 1){print NF}}' $1/$table)
			echo "which column you will search in ?"
            		select choice in ${columns_names[@]}
            		do
    				case $REPLY in
    				0)
    					echo "Sorry Invalid option"
    					
    					;;
        			[0-9]*)
        			if [ $nf -ge "$REPLY" ]; then
        				
		       			read -p "enter a value to search $choice = " value
		       			
		       			declare matched_Rows=$(awk -F: '{j="'$REPLY'";{if($j == "'$value'" && NR > 3) print NR}}' $1/$table)

					
					if [ -n "$matched_Rows" ]; then
						IFS=' ' declare -a row_numbers=($matched_Rows)
						
    						
    						
    						echo "which column will change value?"
    						select choice in ${columns_names[@]}
					    		do
				    				case $REPLY in
				    				0)
				    					echo "Sorry Invalid option"
				    					
				    					;;
								[0-9]*)
									if [ $nf -ge "$REPLY" ]; then
									
										target_column=$REPLY
										
										primary_column=$(head -n 3 $1/$table | tail -n 1)
										
										while [ "$primary_column" -eq "$target_column" ] && [ "${#row_numbers[*]}" -gt 1 ] || [ "$target_column" -gt "$nf" ] || [ "$target_column" -eq 0 ]; 
										do
										    echo -e "Sorry, can't change in this column because \nit is a primary key and matched with 2 or more rows."
										    read -p "Please enter another column number: " target_column
										    
										    while ! [[ "$target_column" =~ ^[0-9]+$ ]]; do

										    	read -p "must write number : " target_column
										    done
										    
										    
										done

						    					
										
										
										read -p "new value : " value_change
										
										
										typec=$(head -n 2 $1/$table | tail -n 1 | awk -F: '{print $'"$target_column"'}')
										
										while [[ ! $value_change =~ $typec ]]; do
											echo "Sorry type of value not allow"
											read -p "new value : " value_change
										done
										
										
										
										break
									else
										echo "Not Valid"
									fi

									;;
								*)	echo "Sorry Invalid option";;
								
								esac
							done
    						
    						
    						
    						
    						awk -F: -v numbers="${row_numbers[*]}" 'BEGIN {split(numbers, arr, " "); for (i in arr) target_rows[arr[i]] = 1} NR in target_rows {OFS=":";$"'$target_column'"="'$value_change'"} {print $0}' "$1/$table" > temp_file && mv temp_file "$1/$table"

    						echo "Update Done"
    						sleep 3 
    						clear
    						./connect.sh $1
					else
    						echo "Not found any matched"
					fi
					
					unset matched_Rows
    					unset row_numbers

		       			break
				else
					echo "Sorry Invalid option"
				fi
        			;;
        			*) echo "Sorry Invalid option";;
    				
    				
    				esac
            		done

            	fi
            	
            	;;
        8)
        	./DBMS.sh
        	;;
        9)	
        	exit 
        	;;
        *)
            	echo "Invalid option. Please try tgain."
    esac
done
