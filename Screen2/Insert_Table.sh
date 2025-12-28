#!/bin/bash
source ../../Screen2/List_Tables.sh
insertIntoTable(){

while true   # repeat insertion
do
    # ================= TABLE NAME =================
    while true
    do
    listTables
    foundTables=$(ls -p | grep -v / | grep -v metadata)
    if [ -z "$foundTables" ]; then

        return
    fi
        echo ----------------------------------
        read -p "Please Enter Table Name to Insert Into: " tableName
        if [ -z "$tableName" ]; then
            echo "Table name cannot be empty."
        elif [[ "$tableName" =~ [[:space:]] ]]; then
            echo "Table name cannot contain spaces."
        elif [[ "$tableName" == *metadata* ]]; then
            echo "Cannot insert into a metadata file."
        elif [ ! -f "$tableName" ]; then
            echo "Table does not exist."
        else
            break
        fi
    done

    # ================= METADATA =================
    metaFile="${tableName}_metadata"
    if [ ! -f "$metaFile" ]; then
        echo "Metadata file for table does not exist."
        return
    fi

    IFS='|' read -r -a columns <<< "$(cat "$metaFile")"
    numCols=${#columns[@]}
    declare -a rowValues

    # ================= VALUES =================
    for (( i=0; i<numCols; i++ ))
    do
        colDef="${columns[i]}"
        colName=$(echo "$colDef" | cut -d: -f1)
        colType=$(echo "$colDef" | cut -d: -f2)
        colConstraint=$(echo "$colDef" | cut -d: -f3)

        while true
        do

            read -p "Please Enter Value for $colName ($colType${colConstraint:+, $colConstraint}): " value

            if [ -z "$value" ]; then
                echo "Value cannot be empty."
                continue
            fi

            # Type check
            if [ "$colType" = "int" ]; then
                if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
                    echo "Value must be an integer."
                    continue
                fi
            fi

            # PK uniqueness check
            if [ "$colConstraint" = "PK" ]; then
                if awk -F'|' -v val="$value" -v col="$((i+1))" '
                    NR>1 && $col==val { found=1 }
                    END { exit found }
                ' "$tableName"
                then
                    : # unique
                else
                    echo "Value must be unique for primary key."
                    continue
                fi
            fi

            rowValues[i]="$value"
            break
        done
    done

    # ================= INSERT =================
    IFS='|' eval 'echo "${rowValues[*]}"' >> "$tableName"
    echo "Record inserted successfully into '$tableName'."

    # ================= ASK AGAIN =================
    while true
    do
        read -p "Do you want to insert another record? (y/n): " answer
        case "$answer" in
            y|Y) break ;;
            n|N) return ;;
            *) echo "Please enter y or n." ;;
        esac
    done

done
}
