#!/usr/bin/bash

select choice in "Create Database" "List Database" "connect to Database" "Drop Database" "Exit"
do
	case $REPLY in
		1)
			echo "create"
			;;
		2)
			ls
			;;
		3)
			echo "connect"
			;;
		4)
			echo "Drop"
			;;
		5)
			exit 0
			;;
		*)
			echo "invalid oprion"
	esac
done
