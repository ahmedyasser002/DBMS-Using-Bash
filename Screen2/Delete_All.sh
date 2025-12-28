deleteAllRows() {
    echo
    echo " This will delete ALL rows in '$tableName' but keep the table and metadata."
    read -p "Are you sure? (y/n): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        return
    fi


    awk 'NR==1 {print}' "$tableName" > .tmp_table && mv .tmp_table "$tableName"
    echo "All rows in table $tableName have been deleted."
}

