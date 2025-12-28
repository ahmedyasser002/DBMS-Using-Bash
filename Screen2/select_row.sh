#!/bin/bash

selectRow() {
    table="$1"

    if [ ! -f "$table" ]; then
        echo "Table does not exist"
        read -p "Press Enter to return..." dummy
        return 1
    fi

    header=$(head -1 "$table")

    while true
    do
        read -p "Enter column name: " col

        colIndex=$(echo "$header" | awk -F'|' -v c="$col" '
            {
                for (i = 1; i <= NF; i++) {
                    if ($i == c) {
                        print i
                        exit
                    }
                }
            }
        ')

        if [ -n "$colIndex" ]; then
            break
        else
            echo "Invalid column name!"
            echo "Available columns: $header"
        fi
    done

    read -p "Enter value to match: " val

    # ===== NEW SCREEN =====
    clear
    echo "=============================="
    echo "Rows where $col = $val"
    echo "=============================="

    awk -F'|' -v idx="$colIndex" -v val="$val" '
        NR > 1 && $idx == val { print }
    ' "$table"

    echo "=============================="
    read -p "Press Enter to return to menu..." dummy
    clear
}
