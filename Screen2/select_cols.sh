#!/bin/bash

selectCols() {
    table="$1"

    if [ ! -f "$table" ]; then
        zenity --error --title="Error" --text="Table does not exist."
        return 1
    fi

    # Get column names from header
    IFS='|' read -r -a headers <<< "$(head -1 "$table")"

    # Build checklist items properly
    checklist=()
    for col in "${headers[@]}"; do
        checklist+=("FALSE" "$col")
    done

    # Zenity checklist
    cols=$(zenity --list \
           --title="Select Columns" \
           --text="Select columns to display:" \
           --checklist \
           --column="Select" --column="Column Name" \
           "${checklist[@]}" \
           --separator="|" \
           --height=300 --width=400)

    if [ -z "$cols" ]; then
        zenity --info --title="Select Columns" --text="No columns selected."
        return
    fi

    # Split selected columns into array
    IFS='|' read -r -a selectedCols <<< "$cols"

    output=""
    for col in "${selectedCols[@]}"; do
        # Find column index
        colIndex=$(awk -F'|' -v c="$col" 'NR==1 {for(i=1;i<=NF;i++) if($i==c){print i; exit}}' "$table")
        [ -z "$colIndex" ] && continue

        # Append column data to output
        columnData=$(awk -F'|' -v idx="$colIndex" 'NR>1 {print $idx}' "$table")
        output+=$(printf "===== %s =====\n%s\n\n" "$col" "$columnData")
    done

    # Show the selected columns in a Zenity text info dialog
    zenity --text-info --title="Selected Columns" --width=500 --height=400 --filename=<(echo "$output")
}



