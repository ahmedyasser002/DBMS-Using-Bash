source ../../Screen2/List_Tables.sh

updateTable() {
while true; do

    listTables
    foundTables=$(ls -p | grep -v / | grep -v metadata)
    [ -z "$foundTables" ] && return

    
    while true; do
        read -p "Enter table name to update: " tableName
        [ -f "$tableName" ] && break
        echo "Table does not exist."
    done

    metaFile="${tableName}_metadata"
    [ ! -f "$metaFile" ] && echo "Metadata not found." && return

    IFS='|' read -r -a columns <<< "$(cat "$metaFile")"
    numCols=${#columns[@]}

    
    pkIndex=-1
    for ((i=0; i<numCols; i++)); do
        [[ "${columns[i]}" == *":PK" ]] && pkIndex=$i && break
    done
    [ $pkIndex -eq -1 ] && echo "No PK defined." && return

    pkName=$(echo "${columns[pkIndex]}" | cut -d: -f1)

    # update method
    while true; do
        echo "Update using:"
        for ((i=0; i<numCols; i++)); do
            echo "$((i+1))) $(echo "${columns[i]}" | cut -d: -f1)"
        done
        read -p "Choice: " colChoice
        [[ "$colChoice" =~ ^[0-9]+$ ]] && ((colChoice>=1 && colChoice<=numCols)) && break
        echo "Invalid choice."
    done

    colIndex=$((colChoice-1))
    colName=$(echo "${columns[colIndex]}" | cut -d: -f1)

    #search value
    while true; do
        read -p "Enter value of $colName to update: " searchVal
        matchCount=$(awk -F'|' -v v="$searchVal" -v c="$((colIndex+1))" '$c==v{count++} END{print count+0}' "$tableName")
        [ "$matchCount" -gt 0 ] && break
        echo "Value not found."
    done

    #PK change allowed
    allowPKChange=true
    if [ "$colIndex" -ne "$pkIndex" ] && [ "$matchCount" -gt 1 ]; then
        allowPKChange=false
        echo "Multiple rows will be updated!"
        echo "Primary Key ($pkName) will NOT be changed!"
    fi

    declare -a newValues
    for ((i=0; i<numCols; i++)); do
        colNameCur=$(echo "${columns[i]}" | cut -d: -f1)
        colType=$(echo "${columns[i]}" | cut -d: -f2)

        #skip PK if not allowed
        if [ $i -eq $pkIndex ] && [ "$allowPKChange" = false ]; then
            newValues[i]="__KEEP__"
            continue
        fi

        while true; do
            read -p "New value for $colNameCur ($colType) [Enter to keep]: " val

            [ -z "$val" ] && newValues[i]="__KEEP__" && break

            [ "$colType" = "int" ] && ! [[ "$val" =~ ^-?[0-9]+$ ]] && echo "Must be integer." && continue

            # check uniqueness
            if [ $i -eq $pkIndex ]; then
                if awk -F'|' -v v="$val" -v c="$((i+1))" '$c==v{found++} END{exit found}' "$tableName"; then
                    newValues[i]="$val"
                    break
                else
                    echo "The PK value already exists."
                    continue
                fi
            fi

            newValues[i]="$val"
            break
        done
    done

    # update
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
    echo "Update completed."

    read -p "Update another record? (y/n): " ans
    [[ "$ans" =~ ^[Nn]$ ]] && return
done
}

