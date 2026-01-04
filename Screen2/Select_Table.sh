#!/bin/bash
source ../../Screen2/select_cols.sh
source ../../Screen2/select_all.sh
source ../../Screen2/select_row.sh
source ../../Screen2/List_Tables.sh

selectFromTable() {

    # ================= TABLE SELECTION =================
    while true; do
        # Get tables
        tables=()
        for file in *; do
            if [[ -f "$file" && "$file" != *metadata* ]]; then
                tables+=("$file")
            fi
        done

        if [ ${#tables[@]} -eq 0 ]; then
            zenity --info --title="Select Table" --text="No tables found."
            return
        fi

        # Zenity list for table selection
        tableName=$(zenity --list \
                    --title="Select Table" \
                    --column="Tables" \
                    "${tables[@]}" \
                    --height=300 \
                    --width=300)

        # User canceled
        if [ -z "$tableName" ]; then
            zenity --info --title="Select Table" --text="Operation canceled."
            return
        fi

        # Validate table
        if [[ "$tableName" == *metadata* || ! -f "$tableName" ]]; then
            zenity --error --title="Error" --text="Invalid table selected."
            continue
        fi

        break
    done

    # ================= MENU SELECTION =================
    while true; do
        choice=$(zenity --list \
                 --title="Select Operation" \
                 --column="Option" \
                 "Select Columns" \
                 "Select *" \
                 "Select Rows where condition" \
                 "Return to previous menu" \
                 --height=300 \
                 --width=350)

        if [ -z "$choice" ]; then
            zenity --info --title="Operation" --text="Operation canceled."
            return
        fi

        case "$choice" in
            "Select Columns")
                selectCols "$tableName"
                ;;
            "Select *")
                selectAll "$tableName"
                ;;
            "Select Rows where condition")
                selectRow "$tableName"
                ;;
            "Return to previous menu")
                return
                ;;
            *)
                zenity --error --title="Error" --text="Invalid choice. Please try again."
                ;;
        esac
    done
}


