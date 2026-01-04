#!/bin/bash

createTable() {

    MAX_COLS=10
    colNames=()

    # ===== Table Name =====
    while true; do
        tableName=$(zenity --entry \
            --title="Create Table" \
            --text="Enter Table Name:")

        [ $? -ne 0 ] && return   # Cancel pressed

        if [ -z "$tableName" ]; then
            zenity --error --text="Table name cannot be empty."
        elif [[ "$tableName" =~ [[:space:]] ]]; then
            zenity --error --text="Table name cannot contain spaces."
        elif ! [[ "$tableName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
            zenity --error --text="Table name must start with a letter and contain only letters, numbers, and _."
        elif [ -f "$tableName" ]; then
            zenity --error --text="Table already exists."
            return
        else
            break
        fi
    done

    # ===== Number of Columns =====
    while true; do
        colNums=$(zenity --entry \
            --title="Create Table" \
            --text="Enter Number of Columns (1-$MAX_COLS):")

        [ $? -ne 0 ] && return

        if ! [[ "$colNums" =~ ^[1-9][0-9]*$ ]]; then
            zenity --error --text="Please enter a valid positive integer."
        elif [ "$colNums" -gt "$MAX_COLS" ]; then
            zenity --error --text="Maximum number of columns is $MAX_COLS."
        else
            break
        fi
    done

    metadata=""
    counter=1

    while [ "$counter" -le "$colNums" ]; do

        if [ "$counter" -eq 1 ]; then
            zenity --info --text="Column 1 will be the Primary Key (PK)."
        fi

        # ===== Column Name =====
        while true; do
            colName=$(zenity --entry \
                --title="Create Table" \
                --text="Enter Column $counter Name:")

            [ $? -ne 0 ] && return

            if [ -z "$colName" ]; then
                zenity --error --text="Column name cannot be empty."
            elif [[ "$colName" =~ [[:space:]] ]]; then
                zenity --error --text="Column name cannot contain spaces."
            elif ! [[ "$colName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
                zenity --error --text="Column name must start with a letter and contain only letters, numbers, and _."
            elif [[ " ${colNames[@]} " =~ " $colName " ]]; then
                zenity --error --text="Column name already exists."
            else
                colNames+=("$colName")
                break
            fi
        done

        # ===== Column Type =====
        while true; do
            colType=$(zenity --list \
                --title="Create Table" \
                --text="Select type for column '$colName'" \
                --column="Type" \
                int string)

            [ $? -ne 0 ] && return

            if [ -z "$colType" ]; then
                zenity --error --text="You must select a column type."
            else
                break
            fi
        done

        if [ "$counter" -eq 1 ]; then
            metadata+="$colName:$colType:PK|"
        else
            metadata+="$colName:$colType|"
        fi

        counter=$((counter + 1))
    done

    # ===== Write Metadata =====
    echo "${metadata%|}" > "${tableName}_metadata"

    # ===== Write Header =====
    header=""
    for col in "${colNames[@]}"; do
        header+="$col|"
    done
    echo "${header%|}" > "$tableName"

    zenity --info --title="Success" --text="Table '$tableName' created successfully 🎉"
}

