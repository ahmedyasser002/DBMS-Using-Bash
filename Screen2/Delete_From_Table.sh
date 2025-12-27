deleteFromTable() {

    # 1️⃣ Table name
    while true; do
        read -p "Enter table name to delete from: " tableName
        if [ -f "$tableName" ]; then
            break
        else
            echo "❌ Table does not exist."
        fi
    done

    metaFile="${tableName}_metadata"

    if [ ! -f "$metaFile" ]; then
        echo "❌ Metadata file not found."
        return
    fi

    # 2️⃣ Read metadata
    IFS='|' read -r -a columns <<< "$(cat "$metaFile")"

    pkIndex=-1
    pkType=""
    pkName=""

    for i in "${!columns[@]}"; do
        IFS=':' read -r name type constraint <<< "${columns[i]}"
        if [ "$constraint" = "PK" ]; then
            pkIndex=$((i+1))
            pkType="$type"
            pkName="$name"
            break
        fi
    done

    if [ "$pkIndex" -eq -1 ]; then
        echo "❌ No Primary Key defined."
        return
    fi

    # 3️⃣ Ask for PK value
    while true; do
        read -p "Enter $pkName value to delete: " pkValue

        if [ -z "$pkValue" ]; then
            echo "❌ Value cannot be empty."
            continue
        fi

        # Datatype validation
        if [ "$pkType" = "int" ] && ! [[ "$pkValue" =~ ^-?[0-9]+$ ]]; then
            echo "❌ $pkName must be an integer."
            continue
        fi

        # Check if value exists
        if awk -F'|' -v val="$pkValue" -v col="$pkIndex" '$col==val {found=1} END{exit !found}' "$tableName"; then
            break
        else
            echo "❌ Record not found."
        fi
    done

    # 4️⃣ Delete row
    awk -F'|' -v val="$pkValue" -v col="$pkIndex" '
        $col != val
    ' "$tableName" > .tmp_table && mv .tmp_table "$tableName"

    echo "🗑️ Record deleted successfully."
}

