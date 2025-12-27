#!/bin/bash

create_database(){
	read -p "Enter Database Name: " dbname

	if [ -d "$dbname" ]; then 
		echo "❌ Database already exist!"
	else
		mkdir "$dbname"
		echo "✅ Database '$dbname' created successfully."
	fi
}	

list_databases(){
    dbs=$(ls -d */ 2>/dev/null)

    if [ -z "$dbs" ]; then    
	echo -e "\e[31mNo directories found.\e[0m"
    else
	echo "📂 Available Databases:"
        echo "$dbs"
    fi

}

connect_database() {
    read -p "Enter Database Name to connect: " dbname

    if [ -d "$dbname" ]; then
        cd "$dbname" || return
        echo -e "\e[32m✅ Connected to database '$dbname'\e[0m"
	pwd
	source ../Screen2/screen2_menu.sh
	screen2_menu
	
    else
        echo -e "\e[31m❌ Database '$dbname' does not exist.\e[0m"
    fi
}



drop_database() {
    read -p "Enter Database Name to Drop: " dbname
    if [ -d "$dbname" ]; then
        read -p "Are you sure you want to delete '$dbname'? (y/n): " confirm
	if [ "$confirm" = "y" ]; then
            rm -r "$dbname"
            echo "🗑️ Database '$dbname' deleted."
	else
            echo "❎ Operation cancelled."
        fi
     else
        echo "❌ Database not found."
    fi
}

PS3="Choose an option: "

draw_main_menu() {
    clear
    echo -e "\e[36m=============================="
    echo "   Bash DBMS - Main Menu"
    echo "=============================="
}
while true
do draw_main_menu

select choice in "Create Database" "List Databases" "Drop Database" "Connect To database" "Exit"
do
    case $REPLY in
        1) create_database ;;
        2) list_databases ;;
        3) drop_database ;;
	4) connect_database ;;
        5) echo "👋 Bye!"
	   sleep 2
	   clear
	   echo -e "\e[0m" 
	   exit 
           ;;
        *) echo "❌ Invalid choice, try again." ;;
    esac
    read -p "Press Enter to continue..."
    break
   done
done

