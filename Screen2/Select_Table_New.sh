#!/bin/bash
source ../Screen2/select_cols.sh
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


    echo "----------------------------------"
    echo " Select from Table - Main Menu "
    echo "----------------------------------"
    while true
    do
    echo "1) Select Columns"
    echo "2) Select *"
    echo "3) Select Rows where condition"

    echo "----------------------------------"
    read -p "Please enter your choice [1-3]: " choice

    
    case $choice in
    1) 
        selectCols "$tableName"
        ;;
    2) 
        listTables
        ;;
    3) 
        dropTable
        ;;
   
    *) 
        echo $choice is not one of the choices, Try Again.
        ;;
    esac
    done



}