source ../../Screen2/List_Tables.sh
source ../../Screen2/Delete_All.sh
deleteFromTable() {

    echo
    # ===== Get table name =====
    while true; do
 
    listTables
    foundTables=$(ls -p | grep -v / | grep -v metadata)
    if [ -z "$foundTables" ]; then

        return
    fi
    
        read -p "Enter table name to delete from: " tableName
        [ -f "$tableName" ] && break
        echo "Table does not exist."
    done

    metaFile="${tableName}_metadata"

    # read metadata
    IFS='|' read -r -a columns <<< "$(cat "$metaFile")"
    numCols=${#columns[@]}

    # search using pk
    pkIndex=-1
    for (( i=0; i<numCols; i++ )); do
        if [[ "${columns[i]}" == *":PK" ]]; then
            pkIndex=$i
            pkName=$(echo "${columns[i]}" | cut -d: -f1)
            break
        fi
    done

    # ===== Ask delete method =====
    
    echo "1) Delete ALL rows (keep table & metadata)"
    echo "2) Delete one row using Primary Key ($pkName)"
    echo "3) Delete using another column"
    echo "4) Cancel"
    read -p "Choice: " delChoice

    case $delChoice in
    
    1)
        deleteAllRows
        ;;

    2)
        read -p "Enter $pkName value: " value
        awk -F'|' -v OFS='|' -v col="$((pkIndex+1))" -v val="$value" '
            $col != val
        ' "$tableName" > .tmp && mv .tmp "$tableName"
        echo "Record deleted successfully."
        ;;

    3)
        echo "Choose column:"
        for (( i=0; i<numCols; i++ )); do
            colName=$(echo "${columns[i]}" | cut -d: -f1)
            echo "$((i+1))) $colName"
        done

        read -p "Column number: " colNum
        colIndex=$((colNum-1))
        colName=$(echo "${columns[colIndex]}" | cut -d: -f1)

        read -p "Enter value for $colName: " value

        awk -F'|' -v OFS='|' -v col="$((colIndex+1))" -v val="$value" '
            $col != val
        ' "$tableName" > .tmp && mv .tmp "$tableName"

        echo "Matching records deleted."
        ;;

    4)
        echo "Delete cancelled."
        return
        ;;

    *)
        echo "Invalid choice."
        ;;
    esac
}

