#!/bin/bash

dropTable() {
    while true; do
        # Get list of tables
        tables=()
        for file in *; do
            if [[ -f "$file" && "$file" != *metadata* ]]; then
                tables+=("$file")
            fi
        done

        if [ ${#tables[@]} -eq 0 ]; then
            zenity --info --title="Drop Table" --text="No tables found."
            return
        fi

        # Let user select a table using Zenity list
        tableName=$(zenity --list \
                    --title="Select Table to Drop" \
                    --column="Tables" \
                    "${tables[@]}" \
                    --height=300 \
                    --width=300)

        # If user cancels
        if [ -z "$tableName" ]; then
            zenity --info --title="Drop Table" --text="Operation canceled."
            return
        fi

        # Confirm deletion
        zenity --question \
               --title="Confirm Drop" \
               --text="Are you sure you want to drop '$tableName' and all its data?"

        if [ $? -eq 0 ]; then
            # User clicked Yes
            rm -f "$tableName"
            if [ -f "${tableName}_metadata" ]; then
                rm -f "${tableName}_metadata"
            fi
            zenity --info --title="Drop Table" --text="Table '$tableName' and its metadata dropped successfully."
            return
        else
            # User clicked No
            zenity --info --title="Drop Table" --text="Operation canceled."
            return
        fi
    done
}


