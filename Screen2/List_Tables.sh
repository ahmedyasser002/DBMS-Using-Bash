#!/bin/bash

listTables(){
    echo "----------------------------------"
    echo "List of Tables:"
    echo "----------------------------------"
    # List files that do not contain 'metadata' in their name
    found=0
    for file in *
    do
        if [[ -f "$file" && "$file" != *metadata* ]]
        then
            echo "$file"
            found=1
        fi
    done
    if [ $found -eq 0 ]
    then
        echo "No tables found."
    fi
    echo "----------------------------------"
}