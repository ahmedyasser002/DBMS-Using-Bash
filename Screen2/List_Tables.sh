#!/bin/bash

listTables() {
    # Find all files that do not contain 'metadata' in their name
    tables=()
    for file in *; do
        if [[ -f "$file" && "$file" != *metadata* ]]; then
            tables+=("$file")
        fi
    done

    if [ ${#tables[@]} -eq 0 ]; then
        zenity --info --title="Tables" --text="No tables found."
    else
        # Join array into newline-separated string for Zenity
        table_list=$(printf "%s\n" "${tables[@]}")
        zenity --list \
               --title="List of Tables" \
               --column="Tables" \
               $table_list
    fi
}


