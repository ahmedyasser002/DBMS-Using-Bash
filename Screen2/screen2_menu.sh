#!/bin/bash

source ./Create_Table.sh
source ./List_Tables.sh
source ./Drop_Table.sh
source ./Insert_Table.sh

screen2_menu(){
    echo "----------------------------------"
    echo " Welcome to Screen 2 - Main Menu "
    echo "----------------------------------"
    while true
    do
    echo "1) Create Table"
    echo "2) List Tables"
    echo "3) Drop Table"
    echo "4) Insert into Table"
    echo "5) Select from Table"
    echo "6) Delete from Table"
    echo "7) Back to Main Menu"
    echo "----------------------------------"
    read -p "Please enter your choice [1-7]: " choice

    
    case $choice in
    1) 
        createTable
        ;;
    2) 
        listTables
        ;;
    3) 
        dropTable
        ;;
    4)
        insertIntoTable
        ;;
    5)
        echo "Select from Table..."
        ;;
    6)
        echo "Delete from Table..."
        ;;
    7)
        return
        ;;
    *) 
        echo $choice is not one of the choices, Try Again.
        ;;
    esac
    done
    
}

screen2_menu