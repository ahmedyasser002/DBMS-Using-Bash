#!/bin/bash
source ../../Screen2/List_Tables.sh

insertIntoTable() {

    while true; do  # repeat insertion

        # ================= TABLE NAME =================
        while true; do
            # Get tables
            tables=()
            for file in *; do
                if [[ -f "$file" && "$file" != *metadata* ]]; then
                    tables+=("$file")
                fi
            done

            if [ ${#tables[@]} -eq 0 ]; then
                zenity --info --title="Insert Record" --text="No tables found."
                return
            fi

            # Zenity list to select table
            tableName=$(zenity --list \
                        --title="Select Table" \
                        --column="Tables" \
                        "${tables[@]}" \
                        --height=300 \
                        --width=300)

            # User cancelled
            if [ -z "$tableName" ]; then
                zenity --info --title="Insert Record" --text="Operation canceled."
                return
            fi

            # Validate table name
            metaFile="${tableName}_metadata"
            if [ ! -f "$metaFile" ]; then
                zenity --error --title="Error" --text="Metadata file for table does not exist."
                return
            fi

            break
        done

        # ================= METADATA =================
        IFS='|' read -r -a columns <<< "$(cat "$metaFile")"
        numCols=${#columns[@]}
        declare -a rowValues

        # ================= VALUES =================
        for (( i=0; i<numCols; i++ )); do
            colDef="${columns[i]}"
            colName=$(echo "$colDef" | cut -d: -f1)
            colType=$(echo "$colDef" | cut -d: -f2)
            colConstraint=$(echo "$colDef" | cut -d: -f3)

            while true; do
                # Prompt user for value using Zenity
                value=$(zenity --entry \
                        --title="Enter Value" \
                        --text="Enter value for $colName ($colType${colConstraint:+, $colConstraint}):")

                # Cancel
                if [ -z "$value" ]; then
                    zenity --error --title="Error" --text="Value cannot be empty."
                    continue
                fi

                # Type check
                if [ "$colType" = "int" ]; then
                    if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
                        zenity --error --title="Error" --text="Value must be an integer."
                        continue
                    fi
                fi

                # PK uniqueness check
                if [ "$colConstraint" = "PK" ]; then
                    if awk -F'|' -v val="$value" -v col="$((i+1))" 'NR>1 && $col==val { exit 1 }' "$tableName"; then
                        :
                    else
                        zenity --error --title="Error" --text="Value must be unique for primary key."
                        continue
                    fi
                fi

                rowValues[i]="$value"
                break
            done
        done

        # ================= INSERT =================
        IFS='|' eval 'echo "${rowValues[*]}"' >> "$tableName"
        zenity --info --title="Insert Record" --text="Record inserted successfully into '$tableName'."

        # ================= ASK AGAIN =================
        if ! zenity --question --title="Insert Again?" --text="Do you want to insert another record?"; then
            return
        fi
    done
}


