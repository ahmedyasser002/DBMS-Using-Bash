#!/bin/bash

selectFromTable(){
     while true
    do
        read -p "Please Enter Table Name to Select From: " tableName
        if [ -z "$tableName" ]
        then
            echo "Table name cannot be empty."
        elif [[ "$tableName" =~ [[:space:]] ]]
        then
            echo "Table name cannot contain spaces."
        elif [[ "$tableName" == *metadata* ]]
        then
            echo "Cannot Select from a metadata file."
        elif [ ! -f "$tableName" ] 
        then
            echo "Table does not exist."
        else
            break
        fi
    done

    # Get column names from the first line of the table
    IFS='|' read -r -a colNames <<< "$(head -n 1 "$tableName")"

    # Ask user to input columns to select
    while true; do
        echo "Available columns: ${colNames[*]}"
        read -p "Enter columns to select (separated by spaces): " -a selectedCols
        valid=1
        for col in "${selectedCols[@]}"; do
            found=0
            for name in "${colNames[@]}"; do
                if [ "$col" = "$name" ]; then
                    found=1
                    break
                fi
            done
            if [ $found -eq 0 ]; then
                echo "Column '$col' does not exist. Please try again."
                valid=0
                break
            fi
        done
        if [ $valid -eq 1 ]; then
            break
        fi
    done

    # Ask user if they want to add a condition
    echo "Do you want to add a condition to your selection?"
    # Step 1: Ask for column to use in condition (from selected columns only)
    while true; do
        echo "Selected columns: ${selectedCols[*]}"
        read -p "Enter column name for condition (from selected): " condCol
        found=0
        for name in "${selectedCols[@]}"; do
            if [ "$condCol" = "$name" ]; then
                found=1
                break
            fi
        done
        if [ $found -eq 1 ]; then
            break
        else
            echo "Column '$condCol' is not in selected columns. Please try again."
        fi
    done
    # Step 2: Ask for operator
    select condChoice in ">" "<" "=" "!=" ">=" "<=" "No condition"; do
        case $condChoice in
            ">"|"<"|"="|"!="|">="|"<=")
                conditionOperator="$condChoice"
                # Step 3: Ask for value or another column
                while true; do
                    read -p "Compare $condCol $condChoice to (1) Value or (2) Another column? [1/2]: " cmpType
                    if [ "$cmpType" = "1" ]; then
                        read -p "Enter value to compare: " condVal
                        conditionCompareType="value"
                        break
                    elif [ "$cmpType" = "2" ]; then
                        # Ask for second column (from selected columns only, not the same as condCol)
                        while true; do
                            read -p "Enter second column name for comparison: " condCol2
                            found2=0
                            for name in "${selectedCols[@]}"; do
                                if [ "$condCol2" = "$name" ] && [ "$condCol2" != "$condCol" ]; then
                                    found2=1
                                    break
                                fi
                            done
                            if [ $found2 -eq 1 ]; then
                                break
                            else
                                echo "Column '$condCol2' is not valid (must be a different selected column). Please try again."
                            fi
                        done
                        conditionCompareType="column"
                        condVal="$condCol2"
                        break
                    else
                        echo "Please enter 1 for Value or 2 for Another column."
                    fi
                done
                # Save condition info for later use
                conditionColumn="$condCol"
                conditionValue="$condVal"
                conditionType="$conditionCompareType"
                break
                ;;
            "No condition")
                conditionOperator=""
                break
                ;;
            *)
                echo "Invalid choice. Please select a valid condition operator."
                ;;
        esac
    done
}