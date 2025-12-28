dropTable(){
    while true
    do
        listTables
        foundTables=$(ls -p | grep -v / | grep -v metadata)
        if [ -z "$foundTables" ]; then
 
           return
        fi

        read -p "Please Enter Table Name to Drop: " tableName
        if [ -z "$tableName" ]; then
            echo "Table name cannot be empty."
        elif [ ! -f "$tableName" ]; then
            echo "Table does not exist."
        else
            #confirm to delete
            while true; do
                read -p "Are you sure you want to drop '$tableName' with all its data? (y/n): " confirm
                case $confirm in
                    y|Y)
                        rm "$tableName"
                        if [ -f "${tableName}_metadata" ]; then
                            rm "${tableName}_metadata"
                        fi
                        echo "Table '$tableName' and its metadata dropped successfully."
                        break 2  # exit both loops
                        ;;
                    n|N)
                        echo "Operation canceled."
                        break 2
                        ;;
                    *)
                        echo "Please enter y or n."
                        ;;
                esac
            done
        fi
    done
}

