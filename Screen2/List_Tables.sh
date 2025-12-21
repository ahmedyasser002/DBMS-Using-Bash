#!/bin/bash

listTables(){
    echo "----------------------------------"
    echo "List of Tables:"
    echo "----------------------------------"
    # -A to remove the . and .. entries
    if [ "$(ls -A)" ]
    then
    # -p to append / for directories
        ls -p | grep -v / 
    else
        echo "No tables found."
    fi
    echo "----------------------------------"
}