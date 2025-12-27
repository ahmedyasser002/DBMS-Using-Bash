#!/bin/bash

dropTable(){
    while true
    do
        read -p "Please Enter Table Name to Drop: " tableName
        if [ -z "$tableName" ]
        then
            echo "Table name cannot be empty."
        # elif [[ "$tableName" =~ [[:space:]] ]]
        # then
        #     echo "Table name cannot contain spaces."
        elif [ ! -f "$tableName" ] 
        then
            echo "Table does not exist."
        else
            rm "$tableName"
            # Also remove metadata file if exists
            if [ -f "${tableName}_metadata" ]
            then
                rm "${tableName}_metadata"
            fi
            echo "Table '$tableName' and its metadata dropped successfully."
            break
        fi
    done
}