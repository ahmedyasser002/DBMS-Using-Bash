source ../../Screen2/List_Tables.sh
updateTable() {
while true; do

    listTables
    foundTables=$(ls -p | grep -v / | grep -v metadata)
    if [ -z "$foundTables" ]; then

        return
    fi
    # table name
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

    #  read metadata 
    IFS='|' read -r -a columns <<< "$(cat "$metaFile")"
    numCols=${#columns[@]}

    # find pk
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

    # ask for pk value
	while true; do
	    read -p "Enter $pkName value to update: " pkValue

	    if awk -F'|' -v val="$pkValue" -v col="$((pkIndex+1))" \
	       '$col==val{found=1} END{exit !found}' "$tableName"
	    then
		break  
	    else
		echo "Invalid $pkName. Please enter a valid one."
	    fi
	done
    # rerieve old row
    IFS='|' read -r -a oldValues <<< \
        "$(awk -F'|' -v val="$pkValue" -v col="$((pkIndex+1))" \
        '$col==val{print}' "$tableName")" 
        
    declare -a newValues	
    
    # assign new value
    
    for (( i=0; i<numCols; i++ ))
    do
        colDef="${columns[i]}"
        colName=$(echo "$colDef" | cut -d: -f1)
        colType=$(echo "$colDef" | cut -d: -f2)
        colConstraint=$(echo "$colDef" | cut -d: -f3)

	while true; do
	    read -p "Enter new value for $colName ($colType) or press Enter to keep old: " value


	    if [ -z "$value" ]; then
		newValues[i]="${oldValues[i]}"
		break
	    fi

	    # check datatype
	    if [ "$colType" = "int" ]; then
		if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
		    echo "Value must be an integer."
		    continue
		fi
	    fi

	    # check pk 
         if [ $i -eq $pkIndex ]; then

                # same old PK → allowed
                if [ "$value" = "${oldValues[i]}" ]; then
                    newValues[i]="$value"
                    break
                fi

                # check uniqueness
                if awk -F'|' -v val="$value" -v col="$((i+1))" -v old="$pkValue" \
                   '$col==val && val!=old {found=1} END{exit found}' "$tableName"
                then
                    newValues[i]="$value"
                    break
                else
                    echo "This ID already exists. Choose another ID."
                    continue
                fi
            fi

            newValues[i]="$value"
            break
        done
    done

    # updating data
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
    while true; do
    echo =================================================
        read -p "Do you want to update another row? (y/n): " ans
        case $ans in
            y|Y) break ;;
            n|N) return ;;
            *) echo "Please enter y or n." ;;
        esac
    done

done
}

