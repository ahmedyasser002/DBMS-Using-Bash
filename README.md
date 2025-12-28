# 🗄️ Bash DBMS Project

A lightweight **Database Management System built entirely with Bash scripting**. This project simulates core DBMS features using the Linux file system and text processing tools (awk, sed, grep).

---

## ✨ Features

### 📌 Database Level (Screen 1)

* Create Database
* List Databases
* Drop Database (with confirmation)
* Connect to Database

### 📌 Table Level (Screen 2)

* Create Table (with metadata)
* List Tables
* Drop Table (confirmation included)
* Insert into Table
* Select from Table
* Update Table (Primary Key enforced)
* Delete From Table (by PK or any column)
* Delete **All Rows** (keeps table & metadata)

---

## 🧠 Concepts Implemented

* Metadata-driven schema
* Primary Key validation & uniqueness
* Data type validation (int / string)
* Menu-driven CLI
* Safe file handling using temp files
* Confirmation prompts for destructive actions

---

## 📂 Project Structure

```text
DBMS_Project/
│
├── dbms.sh                     # Main entry point (Screen 1)
├── databases/
│   └── <database_name>/
│       ├── table1
│       ├── table1_metadata
│       ├── table2
│       └── table2_metadata
│
├── Screen1/
│   ├── create_database.sh
│   ├── list_databases.sh
│   ├── drop_database.sh
│   └── connect_database.sh
│
├── Screen2/
│   ├── Create_Table.sh
│   ├── List_Tables.sh
│   ├── Drop_Table.sh
│   ├── Insert_Table.sh
│   ├── Select_Table.sh
│   ├── Update_Table.sh
│   └── Delete_From_Table.sh
│
└── README.md
```

---

## ▶️ How to Run

```bash
chmod +x dbms.sh
./dbms.sh
```

> ⚠️ Make sure you're running on Linux / Unix environment.

---

## 🧪 Sample Flow

1. Run `./dbms.sh`
2. Create a database
3. Connect to the database
4. Create tables with schema
5. Insert / Select / Update / Delete records

---

## 🛡️ Safety Features

* Confirmation before deleting databases or tables
* Unique PK checks during insert & update
* Prevents invalid data types

---


## 👩‍💻 Author

**Ahmed Yasser** and
**Shahd Ramadan** 

ITI – Bash DBMS Project

> Built with passion, coffee ☕, and lots of debugging 😄

---

## ⭐ If you like this project

Give the repo a ⭐ and feel free to fork & enhance it!
