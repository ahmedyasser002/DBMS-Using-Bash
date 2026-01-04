# 🗄️ Bash DBMS Project (Zenity GUI)

A lightweight **Database Management System built entirely with Bash scripting**, enhanced with **Zenity GUI dialogs** for a fully graphical experience. This project simulates core DBMS features using the Linux file system and text processing tools (`awk`, `sed`, `grep`), replacing CLI menus with intuitive GUI dialogs.

---

## ✨ Features

### 📌 Database Level (Screen 1)

* Create Database (GUI input dialog)  
* List Databases (GUI list)  
* Drop Database (GUI confirmation)  
* Connect to Database (GUI selection)

### 📌 Table Level (Screen 2)

* Create Table (with metadata using GUI forms)  
* List Tables (GUI list)  
* Drop Table (with confirmation)  
* Insert into Table (GUI entry dialogs, PK & type enforced)  
* Select from Table (select columns, all, or conditional rows via GUI)  
* Update Table (Primary Key enforced, GUI prompts)  
* Delete From Table (by PK or any column, with alerts if record not found)  
* Delete **All Rows** (confirmation dialog, keeps table & metadata)

---

## 🧠 Concepts Implemented

* Metadata-driven schema  
* Primary Key validation & uniqueness  
* Data type validation (int / string)  
* Fully GUI-driven workflow (Zenity)  
* Safe file handling using temporary files  
* Confirmation dialogs for destructive actions

---

## 📂 Project Structure

```text
DBMS_Project/
│
├── dbms.sh                     # Main entry point (Zenity GUI)
├── databases/
│   └── <database_name>/
│       ├── table1
│       ├── table1_metadata
│       ├── table2
│       └── table2_metadata
│
├── Screen1/                     # Database-level scripts (GUI)
│   ├── create_database.sh
│   ├── list_databases.sh
│   ├── drop_database.sh
│   └── connect_database.sh
│
├── Screen2/                     # Table-level scripts (GUI)
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

> ⚠️ Make sure you're running on Linux / Unix environment and **Zenity** is installed and you are on Linux/Unix.

---


💡 **Install Zenity**

*Check your Linux distribution and install Zenity:*

**Ubuntu / Debian:**
```bash
sudo apt update
sudo apt install zenity
```

**CentOS / RHEL / Fedora:**
```bash
sudo yum install zenity
```
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
