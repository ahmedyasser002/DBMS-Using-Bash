#!/bin/bash

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
        source ./Create_Table.sh
        createTable
        ;;
    2) 
        echo Listing Tables...
        ;;
    3) 
        echo Dropping Table...
        ;;
    4)
        echo "Insert into Table..."
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