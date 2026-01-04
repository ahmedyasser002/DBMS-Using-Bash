#!/bin/bash
source ../../Screen2/List_Tables.sh
source ../../Screen2/Delete_All.sh

deleteFromTable() {

    # ================= TABLE SELECTION =================
    while true; do
        tables=()
        for file in *; do
            [[ -f "$file" && "$file" != *metadata* ]] && tables+=("$file")
        done

        if [ ${#tables[@]} -eq 0 ]; then
            zenity --info --title="Delete From Table" --text="No tables found."
            return
        fi

        tableName=$(zenity --list \
                    --title="Select Table" \
                    --text="Choose a table to delete from:" \
                    --column="Tables" \
                    "${tables[@]}" \
                    --height=300 --width=400)

        [ -z "$tableName" ] && return
        [ -f "$tableName" ] && break

        zenity --error --title="Error" --text="Table does not exist."
    done

    metaFile="${tableName}_metadata"
    IFS='|' read -r -a columns <<< "$(cat "$metaFile")"
    numCols=${#columns[@]}

    # ================= FIND PRIMARY KEY =================
    pkIndex=-1
    pkName=""
    for ((i=0; i<numCols; i++)); do
        if [[ "${columns[i]}" == *":PK" ]]; then
            pkIndex=$i
            pkName=$(echo "${columns[i]}" | cut -d: -f1)
            break
        fi
    done

    # ================= DELETE METHOD =================
    delChoice=$(zenity --list \
                --title="Delete Method" \
                --column="Option" \
                "Delete ALL rows (keep table & metadata)" \
                "Delete using another column" \
                "Cancel" \
                --height=300 --width=400)

    [ -z "$delChoice" ] && return

    case "$delChoice" in
        "Delete ALL rows (keep table & metadata)")
            deleteAllRows "$tableName"
            zenity --info --title="Success" --text="All rows deleted successfully."
            ;;

        "Delete using another column")
            # Let user select column
            checklist=()
            for col in "${columns[@]}"; do
                colName=$(echo "$col" | cut -d: -f1)
                checklist+=("$colName")
            done

            colName=$(zenity --list --title="Select Column" --column="Column" "${checklist[@]}" --height=300 --width=400)
            [ -z "$colName" ] && return

            # Find column index
            colIndex=-1
            for ((i=0;i<numCols;i++)); do
                [[ "$(echo "${columns[i]}" | cut -d: -f1)" == "$colName" ]] && colIndex=$i && break
            done

            value=$(zenity --entry --title="Enter Value" --text="Enter value for $colName:")
            [ -z "$value" ] && return

            matchCount=$(awk -F'|' -v val="$value" -v col="$((colIndex+1))" '$col==val{count++} END{print count+0}' "$tableName")
            if [ "$matchCount" -eq 0 ]; then
                zenity --error --title="Error" --text="Record not found in table. Please enter a valid value."
                return
            fi

            awk -F'|' -v OFS='|' -v col="$((colIndex+1))" -v val="$value" '$col != val' "$tableName" > .tmp && mv .tmp "$tableName"
            zenity --info --title="Success" --text="Matching records deleted."
            ;;

        "Cancel")
            zenity --info --title="Cancelled" --text="Delete operation cancelled."
            return
            ;;

        *)
            zenity --error --title="Error" --text="Invalid choice."
            ;;
    esac
}

