#!/bin/bash

dropTable(){
    while true
    do
        read -p "Please Enter Table Name to Drop: " tableName
        if [ -z "$tableName" ]
        then
            echo "Table name cannot be empty."
        elif [[ "$tableName" =~ [[:space:]] ]]
        then
            echo "Table name cannot contain spaces."
        elif [ ! -f "$tableName" ] 
        then
            echo "Table does not exist."
        else
            rm "$tableName"
            echo "Table '$tableName' dropped successfully."
            break
        fi
    done
}