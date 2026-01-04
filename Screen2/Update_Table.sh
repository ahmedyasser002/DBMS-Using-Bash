#!/bin/bash
source ../../Screen2/List_Tables.sh

updateTable() {
    while true; do
        # ================= TABLE SELECTION =================
        tables=()
        for file in *; do
            [[ -f "$file" && "$file" != *metadata* ]] && tables+=("$file")
        done

        if [ ${#tables[@]} -eq 0 ]; then
            zenity --info --title="Update Table" --text="No tables found."
            return
        fi

        tableName=$(zenity --list \
                    --title="Select Table" \
                    --text="Choose a table to update:" \
                    --column="Tables" \
                    "${tables[@]}" \
                    --height=300 --width=400)

        [ -z "$tableName" ] && return

        metaFile="${tableName}_metadata"
        [ ! -f "$metaFile" ] && { zenity --error --title="Error" --text="Metadata not found."; return; }

        IFS='|' read -r -a columns <<< "$(cat "$metaFile")"
        numCols=${#columns[@]}

        # ================= FIND PRIMARY KEY =================
        pkIndex=-1
        for ((i=0;i<numCols;i++)); do
            [[ "${columns[i]}" == *":PK" ]] && pkIndex=$i && break
        done
        [ $pkIndex -eq -1 ] && { zenity --error --title="Error" --text="No primary key defined."; return; }

        pkName=$(echo "${columns[pkIndex]}" | cut -d: -f1)

        # ================= SELECT COLUMN TO UPDATE =================
        colChoice=$(zenity --list \
                    --title="Select Column to Update" \
                    --column="Columns" \
                    $(for ((i=0;i<numCols;i++)); do echo "$(echo "${columns[i]}" | cut -d: -f1)"; done) \
                    --height=300 --width=400)

        [ -z "$colChoice" ] && return

        colIndex=-1
        for ((i=0;i<numCols;i++)); do
            [[ "$(echo "${columns[i]}" | cut -d: -f1)" == "$colChoice" ]] && colIndex=$i && break
        done

        colName=$(echo "${columns[colIndex]}" | cut -d: -f1)

        # ================= SEARCH VALUE =================
        while true; do
            searchVal=$(zenity --entry \
                        --title="Search Record" \
                        --text="Enter value of $colName to update:")

            [ -z "$searchVal" ] && zenity --info --title="Info" --text="Operation canceled." && return

            matchCount=$(awk -F'|' -v v="$searchVal" -v c="$((colIndex+1))" '$c==v{count++} END{print count+0}' "$tableName")
            [ "$matchCount" -gt 0 ] && break

            zenity --error --title="Error" --text="Value not found."
        done

        # ================= UPDATE NEW VALUES =================
        allowPKChange=true
        if [ "$colIndex" -ne "$pkIndex" ] && [ "$matchCount" -gt 1 ]; then
            allowPKChange=false
            zenity --info --title="Notice" --text="Multiple rows will be updated!\nPrimary Key ($pkName) will NOT be changed!"
        fi

        declare -a newValues
        for ((i=0;i<numCols;i++)); do
            colNameCur=$(echo "${columns[i]}" | cut -d: -f1)
            colType=$(echo "${columns[i]}" | cut -d: -f2)

            [ $i -eq $pkIndex ] && [ "$allowPKChange" = false ] && newValues[i]="__KEEP__" && continue

            while true; do
                val=$(zenity --entry \
                        --title="New Value" \
                        --text="New value for $colNameCur ($colType)\nLeave empty to keep current:")

                [ -z "$val" ] && newValues[i]="__KEEP__" && break

                [ "$colType" = "int" ] && ! [[ "$val" =~ ^-?[0-9]+$ ]] && zenity --error --title="Error" --text="Must be integer." && continue

                if [ $i -eq $pkIndex ]; then
                    if awk -F'|' -v v="$val" -v c="$((i+1))" '$c==v{found++} END{exit found}' "$tableName"; then
                        newValues[i]="$val"
                        break
                    else
                        zenity --error --title="Error" --text="ID already exists."
                        continue
                    fi
                fi

                newValues[i]="$val"
                break
            done
        done

        # ================= APPLY UPDATE =================
        awk -F'|' -v OFS='|' \
            -v c="$((colIndex+1))" -v v="$searchVal" \
            -v pk="$((pkIndex+1))" \
            -v vals="$(IFS='|'; echo "${newValues[*]}")" '
        BEGIN{ split(vals, nv, "|") }
        {
            if ($c==v) {
                for (i=1; i<=length(nv); i++) {
                    if (nv[i] != "__KEEP__")
                        $i = nv[i]
                }
            }
            print
        }' "$tableName" > ".tmp_$tableName"

        mv ".tmp_$tableName" "$tableName"

        zenity --info --title="Success" --text="Update completed."

        if ! zenity --question --title="Continue?" --text="Update another record?"; then
            return
        fi
    done
}


