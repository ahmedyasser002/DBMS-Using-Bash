#!/bin/bash
selectCols(){

    read -p "Please Enter columns you want separated by space" cols
    arr=($cols)


    # # Read metadata from the metadata file
    # metaFile="${tableName}_metadata"
    # if [ ! -f "$metaFile" ]; then
    #     echo "Metadata file for table does not exist."
    #     return
    # fi

    # for col in $cols
    # do

    #     # if [ -z $col ]
    #     # then
    #     #     echo "Cols cannot be empty"
    #     # fi

    #     # elif [[ "$col" =~ [[:space:]] ]] 
    #     # then
    #     #     echo "Col cannot contain spaces"
    #     # fi

    #     # head -1 "$1" | cut -d'|' -f"$col"
    #     if [ grep -q "$col"  ""$1" | head -1" ]
    #     then
    #         echo "Column $col selected."
    #     else
    #         echo "Column $col does not exist in the table."
    #         continue
    #     fi

    # done


    for col in "${arr[@]}"
    do
        if head -1 "$1" | grep -q "$col"
        then
            echo "Column $col selected."
            $awk –F| ‘{print $1}’ /etc/passwd
        else
            echo "Column $col does not exist in the table."
            continue
        fi
    done

}

# validate $1 as table name