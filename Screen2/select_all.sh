#!/bin/bash

selectAll(){
    table="$1"

    if [ ! -f "$table" ]; then
        echo "Table does not exist"
        return 1
    fi

     # ===== NEW SCREEN =====
    clear
    echo "=============================="
    echo "table '$table' Data"
    echo "=============================="


    echo "All data from table '$table':"
    cat "$table"

      echo "=============================="
    read -p "Press Enter to return to menu..." dummy
    clear
    
}
