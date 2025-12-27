#!/bin/bash

selectAll(){
    table="$1"

    if [ ! -f "$table" ]; then
        echo "Table does not exist"
        return 1
    fi

    echo "All data from table '$table':"
    cat "$table"
}