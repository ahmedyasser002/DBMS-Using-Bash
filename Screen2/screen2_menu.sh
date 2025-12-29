#!/bin/bash

source ../../Screen2/Create_Table.sh
source ../../Screen2/List_Tables.sh
source ../../Screen2/Drop_Table.sh
source ../../Screen2/Insert_Table.sh
source ../../Screen2/Select_Table.sh
source ../../Screen2/Update_Table.sh
source ../../Screen2/Delete_From_Table.sh


screen2_menu(){

 
    while true
    do
    echo -e "\e[32m ******** Connected to $dbname database ******** \e[0m"
    echo "=================================="
    echo " Welcome to Screen 2 - Main Menu "
    echo "=================================="
    echo "1) Create Table"
    echo "2) List Tables"
    echo "3) Drop Table"
    echo "4) Insert into Table"
    echo "5) Select from Table"
    echo "6) Update Table"
    echo "7) Delete From Table"
    echo "8) Back to Main Menu"
    echo "----------------------------------"
    read -p "Please enter your choice [1-8]: " choice

    
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
        selectFromTable
        ;;
    6)
        updateTable
        ;;
    7)
        deleteFromTable
        ;;
    8)
    	cd ../..        
	./dbms.sh       
	exit            
	;;
    *) 
        echo $choice is not one of the choices, Try Again.
        ;;
    esac
    if [ "$choice" != "8" ]; then
            read -p "Press Enter to continue..."
            clear;
        fi
    
    done
    
}


