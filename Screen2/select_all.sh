#!/bin/bash

selectAll() {
    table="$1"

    if [ ! -f "$table" ]; then
        zenity --error --title="Error" --text="Table does not exist."
        return 1
    fi

    # Read entire table
    tableData=$(cat "$table")

    # Display table data in Zenity text-info dialog
    zenity --text-info \
           --title="All Data from Table '$table'" \
           --width=600 --height=400 \
           --filename=<(echo "$tableData")
}


