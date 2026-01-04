#!/bin/bash

selectRow() {
    table="$1"

    if [ ! -f "$table" ]; then
        zenity --error --title="Error" --text="Table does not exist."
        return 1
    fi

    # Get header columns
    IFS='|' read -r -a headers <<< "$(head -1 "$table")"

    # Let user select a column using Zenity list
    col=$(zenity --list \
          --title="Select Column" \
          --text="Select the column to filter by:" \
          --column="Column Name" \
          "${headers[@]}" \
          --height=300 --width=400)

    if [ -z "$col" ]; then
        zenity --info --title="Select Row" --text="Operation canceled."
        return
    fi

    # Find column index
    colIndex=$(awk -F'|' -v c="$col" 'NR==1 {for(i=1;i<=NF;i++) if($i==c){print i; exit}}' "$table")

    # Ask for value to match
    val=$(zenity --entry \
          --title="Enter Value" \
          --text="Enter value to match in column '$col':")

    if [ -z "$val" ]; then
        zenity --info --title="Select Row" --text="No value entered. Operation canceled."
        return
    fi

    # Get matching rows
    matchingRows=$(awk -F'|' -v idx="$colIndex" -v val="$val" 'NR>1 && $idx==val {print}' "$table")

    if [ -z "$matchingRows" ]; then
        zenity --info --title="Result" --text="No matching rows found for $col = $val."
        return
    fi

    # Display matching rows
    zenity --text-info \
           --title="Rows where $col = $val" \
           --width=500 --height=400 \
           --filename=<(echo "$matchingRows")
}



