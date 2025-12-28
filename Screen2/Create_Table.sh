#!/bin/bash

createTable(){

    MAX_COLS=10
    colNames=()

    # Table Name

    while true
    do
        read -p "Please Enter Table Name (or q to cancel): " tableName

        if [ "$tableName" = "q" ]
        then
            echo "Operation canceled."
            return
        elif [ -z "$tableName" ]
        then
            echo "Table name cannot be empty."
        elif [[ "$tableName" =~ [[:space:]] ]]
        then
            echo "Table name cannot contain spaces."

        elif ! [[ "$tableName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]
        then
            echo "Table name must start with a letter and contain only letters, numbers, and _."
    
        elif [ -f "$tableName" ]
        then
            echo "Table already exists."
            return
        else
            break
        fi
    done

    # Col Nums

    while true
    do
        read -p "Please Enter Number of Columns (1-$MAX_COLS or q): " colNums

        if [ "$colNums" = "q" ]
        then
            echo "Operation canceled."
            return
        elif ! [[ "$colNums" =~ ^[1-9][0-9]*$ ]]
        then
            echo "Please enter a valid positive integer."
        elif [ "$colNums" -gt "$MAX_COLS" ]
        then
            echo "Maximum number of columns is $MAX_COLS."
        else
            break
        fi
    done

    metadata=""
    counter=1

    while [ "$counter" -le "$colNums" ]
    do
        if [ "$counter" -eq 1 ]
        then
            echo "The first column will be set as Primary Key (PK) by default."
        fi

        # Col Name

        while true
        do
            read -p "Please Enter Column $counter Name (or q): " colName

            if [ "$colName" = "q" ]
            then
                echo "Operation canceled."
                return
            elif [ -z "$colName" ]
            then
                echo "Column name cannot be empty."
            elif [[ "$colName" =~ [[:space:]] ]]
            then
                echo "Column name cannot contain spaces."
            elif ! [[ "$colName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]
            then
                echo "Column name must start with a letter and contain only letters, numbers, and _."
            elif [[ " ${colNames[@]} " =~ " $colName " ]]
            then
                echo "Column name already exists."
            else
                colNames+=("$colName")
                break
            fi
        done

        # Col Type

        while true
        do
            read -p "Please Enter Column $counter Type (int/string or q): " colType

            if [ "$colType" = "q" ]
            then
                echo "Operation canceled."
                return
            elif [ -z "$colType" ]
            then
                echo "Column type cannot be empty."
            elif [[ "$colType" =~ [[:space:]] ]]
            then
                echo "Column type cannot contain spaces."
            elif [ "$colType" != "int" ] && [ "$colType" != "string" ]
            then
                echo "Please Enter Valid Column Type (string/int)."
            else
                break
            fi
        done

        if [ "$counter" -eq 1 ]
        then
            metadata+="$colName:$colType:PK|"
        else
            metadata+="$colName:$colType|"
        fi

        counter=$((counter + 1))
    done

    echo "${metadata%|}" > "${tableName}_metadata"

    header=""
    for col in "${colNames[@]}"
    do
        header+="$col|"
    done
    echo "${header%|}" > "$tableName"

    echo "Table $tableName created successfully."
}


# Possible imporvements:
# 1. Validate col types (e.g., only allow certain types)
# 2. May make pk the first column by default
# 3. Duplicate column names check
# 4. Check the way of pattern matching if i want to use the +([]) and *([]) patterns
# 5. Use functions for validation to avoid code repetition
# 6. Add more constraints (e.g., NOT NULL, UNIQUE)
# 7. Column name pattern validation (e.g., start with letter, only alphanumeric and _)
# 8. Limit maximum number of columns
# 9. Column name can not be repeated
# 10. Add option to cancel table creation at any point
# 11. Col type should be int or string only
