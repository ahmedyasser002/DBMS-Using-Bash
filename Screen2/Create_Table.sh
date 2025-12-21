#!/bin/bash

createTable(){
    # shopt -s extglob
    # Validate table name (not empty, no spaces)
    while true
    do
        read -p "Please Enter Table Name: " tableName
        if [ -z "$tableName" ]
        then
            echo "Table name cannot be empty."
        elif [[ "$tableName" =~ [[:space:]] ]]
        then
            echo "Table name cannot contain spaces."
        elif [ -f "$tableName" ] 
        then
            echo "Table already exists."
            return
        else
            break
        fi
    done

    # Validate number of columns (positive integer)
    while true
    do
        read -p "Please Enter Number of Columns: " colNums

            # Valid positive integer (no leading zero)
        # if ! [[ "$colNums" == +([1-9])*([0-9]) ]]
        # then
        #     echo "Please enter a valid positive integer."
        # else
        #     break
        # fi

        if ! [[ "$colNums" =~ ^[1-9][0-9]*$ ]]
        then
            echo "Please enter a valid positive integer."
        else
            break
        fi
    done

    metadata=""
    counter=1

    while [ "$counter" -le "$colNums" ]
    do
        # Validate column name (not empty, no spaces)
        while true; do
            read -p "Please Enter Column $counter : " colName
            if [ -z "$colName" ] 
            then
                echo "Column name cannot be empty."
            elif [[ "$colName" =~ [[:space:]] ]]
            then
                echo "Column name cannot contain spaces."
            else
                break
            fi
        done

        # Validate column type (not empty, no spaces)
        while true
        do
            read -p "Please Enter Column $counter Type : " colType
            if [ -z "$colType" ]
            then
                echo "Column type cannot be empty."
            elif [[ "$colType" =~ [[:space:]] ]]
            then
                echo "Column type cannot contain spaces."
            else
                break
            fi
        done

        if [ "$counter" -eq 1 ]
        then
            # Always set first column as PK
            echo "The first column will be set as Primary Key (PK) by default."
            metadata+="$colName:$colType:PK|"
        else
            metadata+="$colName:$colType|"
        fi

        ((counter++))
    done

    echo "${metadata%|}" > "$tableName"
    echo "Table $tableName created successfully"
}



# Possible imporvements:
# 1. Validate col types (e.g., only allow certain types)
# 2. May make pk the first column by default
# 3. Duplicate column names check
# 4. Check the way of pattern matching if i want to use the +([]) and *([]) patterns
# 5. Use functions for validation to avoid code repetition