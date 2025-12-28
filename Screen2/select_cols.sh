#!/bin/bash

selectCols() {

    table="$1"

    if [ ! -f "$table" ]; then
        echo "Table does not exist"
        return 1
    fi

    read -p "Please enter column names separated by space: " cols
    arr=($cols)

    # read header
    header=$(head -1 "$table")

    for col in "${arr[@]}"
    do
        # find column index
        colIndex=$(echo "$header" | awk -F'|' -v c="$col" '{
            for (i=1; i<=NF; i++)
                if ($i == c) {
                    print i
                    exit
                }
        }')

        if [ -z "$colIndex" ]; then
            echo "Column '$col' does not exist"
            continue
        fi

    echo "=============================="
        echo "Column '$col' selected:"
    echo "=============================="

        awk -F'|' -v idx="$colIndex" 'NR>1 { print $idx }' "$table"
        echo "---------------------"
    done
      echo "=============================="
    read -p "Press Enter to return to menu..." dummy
    clear
}


