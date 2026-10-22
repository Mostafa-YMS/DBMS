# Shell DBMS

A Bash-based, menu-driven database management prototype for Linux desktops. It uses **Zenity** dialogs for interaction and stores database/table data as files and directories rather than using a traditional database server.

> **Status:** Educational prototype. Do not use it for important or sensitive data. It is not a secure, production database engine.

## Features implemented

- Create, list, connect to, and drop databases.
- Create and drop tables.
- Define table attributes with a basic `string` or `number` type.
- Treat the first attribute as the primary key and check for duplicate values during insertion.
- Insert rows, display all rows or filter by an attribute, delete matching rows, and update values.
- Display selected table data in an HTML table through Zenity.

## Requirements

- Linux desktop session
- Bash
- Zenity

Install Zenity using your distribution's package manager if it is not already installed.

## Run

Clone or download the repository, open a terminal in the project directory, and run:

```bash
chmod +x dbms.sh
./dbms.sh
```

The application opens graphical dialogs. It creates a `.dbms` directory in the current working directory and stores database folders and table files there. Run it from a directory where you are comfortable creating and modifying these files.

## Data model

The prototype stores table configuration and row values in plain-text files. The first configured attribute is used as the primary key. Supported types are deliberately limited to `string` and `number`; this is not a full SQL implementation.

## Limitations and safety

This project is intended to demonstrate shell scripting, file operations, validation, and menu-driven workflows—not to provide database-grade reliability.

- Data is stored in plain text, without transactions, concurrency control, or recovery guarantees.
- Input handling and shell command construction need hardening. Treat the current implementation as unsafe for untrusted input.
- Filtering and updates use basic text-processing commands, so matching behavior is limited and may not correspond to SQL semantics.
- The prototype has no authentication, authorization, encryption, or robust backup mechanism.
- The implementation depends on a graphical Linux environment with Zenity.

## Potential improvements

- Quote and validate all user-controlled paths and values; avoid evaluating untrusted input in shell commands.
- Replace fragile text parsing with a well-defined storage format.
- Add tests for schema validation, primary-key uniqueness, filtering, deletion, and updates.
- Add explicit confirmation for destructive operations and safe error handling.
- Document examples and add sample data.
