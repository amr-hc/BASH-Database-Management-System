#!/bin/bash

catch_duplicate() {
	for column in "${columns[@]}"; do
		if [[ "$column" == "$column_name" ]]; then
			find_column_name=1
			break
		else
			find_column_name=0
		fi
	done
}
