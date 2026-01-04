#!/bin/bash

deleteAllRows() {
    # Confirm deletion using Zenity
    if ! zenity --question --title="Delete All Rows" \
                --text="This will delete ALL rows in '$tableName' but keep the table and metadata.\nAre you sure?"; then
        zenity --info --title="Cancelled" --text="Operation cancelled."
        return
    fi

    # Keep only the header
    awk 'NR==1 {print}' "$tableName" > .tmp_table && mv .tmp_table "$tableName"

    zenity --info --title="Success" --text="All rows in table '$tableName' have been deleted."
}

