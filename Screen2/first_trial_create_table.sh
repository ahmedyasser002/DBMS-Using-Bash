#!/bin/bash


createTable(){
    read -p "Please Enter Table Name: " tableName
    if [ -f "$tableName" ]
    then
        echo "Table already exists";
        return
    fi

    read -p "Please Enter Number of Columns: " colNums
    
    metadata=""
    counter=1

    while [ "$counter" -le "$colNums" ]
    do
        read -p "Please Enter Column "$counter" : " colName
        read -p "Please Enter Column "$counter" Type : " colType
        if [ "$counter" -eq 1 ]
        then
            read -p "Is this column Primary Key? (y/n): " isPK
            if [ "$isPK" = "y" ]
            then
                metadata+="$colName:$colType:PK|"
            else
                metadata+="$colName:$colType|"
            fi
        else
            metadata+="$colName:$colType|"
        fi

        ((counter++))

    done

    # We can replace this with if condition to remove the last pipe symbol
    echo "${metadata%|}" > "$tableName"
    echo "Table $tableName created successfully"


}
