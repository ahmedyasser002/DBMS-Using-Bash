updateTable() {

    # ===== Get table name =====
    while true
    do
        read -p "Please Enter Table Name to Update: " tableName
        if [ -z "$tableName" ]; then
            echo "Table name cannot be empty."
        elif [[ "$tableName" =~ [[:space:]] ]]; then
            echo "Table name cannot contain spaces."
        elif [ ! -f "$tableName" ]; then
            echo "Table does not exist."
        else
            break
        fi
    done

    metaFile="${tableName}_metadata"
    if [ ! -f "$metaFile" ]; then
        echo "Metadata file does not exist."
        return
    fi

    # ===== Read metadata =====
    IFS='|' read -r -a columns <<< "$(cat "$metaFile")"
    numCols=${#columns[@]}

    # ===== Detect PK =====
    pkIndex=-1
    for (( i=0; i<numCols; i++ ))
    do
        if [[ "${columns[i]}" == *":PK" ]]; then
            pkIndex=$i
            pkName=$(echo "${columns[i]}" | cut -d: -f1)
            break
        fi
    done

    if [ $pkIndex -eq -1 ]; then
        echo "No Primary Key defined."
        return
    fi

    # ===== Ask for PK value =====
    read -p "Enter $pkName value to update: " pkValue

    # ===== Check PK exists =====
    if ! awk -F'|' -v val="$pkValue" -v col="$((pkIndex+1))" '$col==val{found=1}END{exit !found}' "$tableName"; then
        echo "Record with this PK does not exist."
        return
    fi

    # ===== Get new values =====
    declare -a newValues
    for (( i=0; i<numCols; i++ ))
    do
        colDef="${columns[i]}"
        colName=$(echo "$colDef" | cut -d: -f1)
        colType=$(echo "$colDef" | cut -d: -f2)

	while true; do
    read -p "Enter new value for $colName ($colType) or press Enter to keep old: " value

    # لو المستخدم ضغط Enter → خلي القيمة القديمة
    if [ -z "$value" ]; then
        newValues[i]="${oldValues[i]}"
        break
    fi

    # ================= Type Check =================
    if [ "$colType" = "int" ]; then
        if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
            echo "❌ Value must be an integer."
            continue
        fi
    fi

    # ================= PK Check =================
    if [ "$colConstraint" = "PK" ]; then
        # لو نفس القيمة القديمة → تمام
        if [ "$value" = "${oldValues[i]}" ]; then
            newValues[i]="$value"
            break
        fi

        # لو موجودة في صف تاني → خطأ
        if awk -F'|' -v val="$value" -v col="$((i+1))" \
           'NR>0 {if ($col==val) exit 1}' "$tableName"
        then
            : # unique
        else
            echo "❌ Primary key must be unique."
            continue
        fi
    fi

    newValues[i]="$value"
    break
done

    done

    # ===== Update row =====
    awk -F'|' -v OFS='|' \
        -v pkCol="$((pkIndex+1))" \
        -v pkVal="$pkValue" \
        -v newVals="$(IFS='|'; echo "${newValues[*]}")" '
    BEGIN{
        split(newVals, nv, "|")
    }
    {
        if ($pkCol == pkVal) {
            for (i=1; i<=length(nv); i++) {
                if (nv[i] != "")
                    $i = nv[i]
            }
        }
        print
    }' "$tableName" > ".tmp_$tableName"

    mv ".tmp_$tableName" "$tableName"
    echo "Record updated successfully in '$tableName'."
}

