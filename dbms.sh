#!/bin/bash

DB_ROOT="databases"

mkdir -p "$DB_ROOT"

# ================= CREATE DATABASE =================
create_database() {
    while true; do
        dbname=$(zenity --entry \
            --title="Create Database" \
            --text="Enter Database Name (Cancel to stop):")

        [ $? -ne 0 ] && return

        if [ -z "$dbname" ]; then
            zenity --error --text="Database name cannot be empty."
        elif [[ "$dbname" =~ [[:space:]] ]]; then
            zenity --error --text="Database name cannot contain spaces."
        elif ! [[ "$dbname" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
            zenity --error --text="Name must start with letter and contain only letters, numbers, _"
        elif [ -d "$DB_ROOT/$dbname" ]; then
            zenity --error --text="Database already exists."
        else
            mkdir "$DB_ROOT/$dbname"
            zenity --info --text="Database '$dbname' created successfully."
            return
        fi
    done
}

# ================= LIST DATABASES =================
list_databases() {
    if [ ! -d "$DB_ROOT" ] || [ -z "$(ls -A "$DB_ROOT")" ]; then
        zenity --info --text="No databases found."
        return
    fi

    dbs=$(ls "$DB_ROOT")
    zenity --info --title="Databases" --text="$(echo "$dbs")"
}

# ================= CONNECT DATABASE =================
connect_database() {
    dbname=$(zenity --entry \
        --title="Connect Database" \
        --text="Enter Database Name:")

    [ $? -ne 0 ] && return

    if [ -d "$DB_ROOT/$dbname" ]; then
        cd "$DB_ROOT/$dbname" || return
        zenity --info --text="Connected to database '$dbname'."
        source ../../Screen2/screen2_menu.sh
        screen2_menu
    else
        zenity --error --text="Database '$dbname' does not exist."
    fi
}

# ================= DROP DATABASE =================
drop_database() {
    if [ -z "$(ls -A "$DB_ROOT")" ]; then
        zenity --info --text="No databases to delete."
        return
    fi

    dbname=$(zenity --entry \
        --title="Drop Database" \
        --text="Enter Database Name to delete:")

    [ $? -ne 0 ] && return

    if [ -d "$DB_ROOT/$dbname" ]; then
        zenity --question --text="Are you sure you want to delete '$dbname'?"
        if [ $? -eq 0 ]; then
            rm -r "$DB_ROOT/$dbname"
            zenity --info --text="Database '$dbname' deleted."
        fi
    else
        zenity --error --text="Database not found."
    fi
}

# ================= MAIN MENU =================
while true; do
    choice=$(zenity --list \
        --title="DBMS - Main Menu" \
        --column="Option" \
        --column="Action" \
        1 "Create Database" \
        2 "List Databases" \
        3 "Drop Database" \
        4 "Connect To Database" \
        5 "Exit" \
        --height=500 \
        --width=700)

    [ $? -ne 0 ] && exit

    case $choice in
        1) create_database ;;
        2) list_databases ;;
        3) drop_database ;;
        4) connect_database ;;
        5)
            zenity --info --text="Goodbye 👋"
            exit
            ;;
        *) zenity --error --text="Invalid choice." ;;
    esac
done

