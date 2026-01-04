#!/bin/bash

source ../../Screen2/Create_Table.sh
source ../../Screen2/List_Tables.sh
source ../../Screen2/Drop_Table.sh
source ../../Screen2/Insert_Table.sh
source ../../Screen2/Select_Table.sh
source ../../Screen2/Update_Table.sh
source ../../Screen2/Delete_From_Table.sh

screen2_menu() {

    while true; do

        choice=$(zenity --list \
            --title="DBMS - Database Menu ($dbname)" \
            --column="Option" \
            --column="Action" \
            1 "Create Table" \
            2 "List Tables" \
            3 "Drop Table" \
            4 "Insert Into Table" \
            5 "Select From Table" \
            6 "Update Table" \
            7 "Delete From Table" \
            8 "Back to Main Menu" \
            --width=500 \
            --height=450)


        [ $? -ne 0 ] && break

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
                zenity --error --text="Invalid choice!"
                ;;
        esac

    done
}



