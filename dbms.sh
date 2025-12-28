#!/bin/bash

create_database() {
    database="databases"

    mkdir -p "$database"

    while true; do
        read -p "Enter Database Name (or q to cancel): " dbname

        if [ "$dbname" = "q" ]; then
            echo "Operation canceled."
            return
        fi

        # Validation
        if [ -z "$dbname" ]; then
            echo "Database name cannot be empty."
        elif [[ "$dbname" =~ [[:space:]] ]]; then
            echo "Database name cannot contain spaces."
        elif ! [[ "$dbname" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
            echo "Database name must start with a letter and contain only letters, numbers, and _."
        elif [ -d "$database/$dbname" ]; then
            echo "Database '$dbname' already exists."
        else
            mkdir "$database/$dbname"
            echo "Database '$dbname' created successfully."
            break
        fi
    done
}
	

list_databases() {
    database="databases"

    if [ ! -d "$database" ]; then
        echo -e "\e[31mNo databases directory found.\e[0m"
        return
    fi

    dbs=$(ls -d "$database"/*/ 2>/dev/null)

    if [ -z "$dbs" ]; then
        echo -e "\e[31mNo databases found.\e[0m"
    else
        echo ================================
        echo "Available Databases"
        echo =================================
        for db in $dbs; do
            basename "$db"
        done
    fi
}


connect_database() {
    read -p "Enter Database Name to connect: " dbname

    if [ -d "databases/$dbname" ]; then
        cd "databases/$dbname" || return
        clear
	source ../../Screen2/screen2_menu.sh
	screen2_menu
    else
        echo -e "\e[31m Database '$dbname' does not exist.\e[0m"
    fi
}



drop_database() {
    DB_FOLDER="databases"
     if [ ! -d "$DB_FOLDER" ]; then
        echo "Databases folder does not exist."
        return
    fi


    read -p "Enter Database Name to Drop: " dbname
    dbPath="$DB_FOLDER/$dbname"


    if [ -d "$dbPath" ]; then
        read -p "Are you sure you want to delete '$dbname'? (y/n): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -r "$dbPath"
            echo "Database '$dbname' deleted."
        else
            echo "Operation cancelled."
        fi
    else
        echo "Database '$dbname' not found in '$DB_FOLDER'."
    fi
}

PS3="Choose an option: "

while true
do 
    clear
    echo "=================================="
    echo " Welcome to Screen 1 - Main Menu "
    echo "    Database Management System   "
    echo "=================================="
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Drop Database"
    echo "4) Connect To database"
    echo "5) Exit"
    read -p "Please enter your choice [1-5]: " choice


    case $choice in
        1) create_database ;;
        2) list_databases ;;
        3) drop_database ;;
	4) connect_database ;;
        5) echo "Bye!"
	   sleep 2
	   clear
	   echo -e "\e[0m" 
	   exit 
           ;;
        *) echo "Invalid choice, try again." ;;
    esac
    read -p "Press Enter to continue..."
    
   done


