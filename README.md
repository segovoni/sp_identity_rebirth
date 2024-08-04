# sp_identity_rebirth: Regenerate IDENTITY column values in SQL Server and Azure SQL!

## Overview

The `sp_identity_rebirth` stored procedure addresses the SQL Server and Azure SQL error 8115:

```sql
Arithmetic overflow error converting IDENTITY to data type int.
```

This error occurs when attempting to insert a value that exceeds the data type limit of an IDENTITY column. This procedure provides a multi-phase strategy to regenerate IDENTITY column values while maintaining referential integrity and minimizing data loss.

## Background

Managing IDENTITY columns in SQL Server and Azure SQL can present challenges, especially when dealing with large datasets and frequent data insertions and deletions. An overflow error can occur when attempting to insert a value that exceeds the data type limit of the IDENTITY column. This issue is particularly common in tables with integer IDENTITY columns, but it can also affect columns of other data types such as tinyint, smallint, and bigint.

When an overflow occurs, it may indicates that the current value of the IDENTITY column has exceeded its maximum allowable value. This can disrupt data insertion processes and impact the functionality of applications that rely on these columns for unique key generation.

To address this issue, it is necessary to either change the data type of the IDENTITY column or compact the existing values within the column. Changing the data type involves several considerations, such as updating related foreign keys and adjusting application logic, which can be complex and time-consuming.

To simplify the process and maintain referential integrity, the `sp_identity_rebirth` stored procedure was developed. This procedure provides a multi-phase approach to regenerate the values of an IDENTITY column, ensuring data integrity and minimizing the risk of data loss. It temporarily stores current IDENTITY values, regenerates new values, and updates related tables and foreign keys accordingly.

## Features

- **Referential integrity:** Manages foreign keys to ensure all references remain valid after IDENTITY regeneration.

- **Sequential order:** Uses a temporary table to ensure operations are performed in the correct order.

- **Transaction management:** Ensures all operations are atomic, reducing the risk of inconsistencies.

## Prerequisites

- SQL Server 2016 or later.
- Sufficient permissions to create and modify tables, and manage keys and constraints.

## How it works

The procedure includes the following steps:

### Input parameter validation:

- Verifies that the schema, table, and IDENTITY column names are not empty.
- Checks if the IDENTITY column exists in the specified table.

### Primary key verification:

- Determines if the IDENTITY column is the primary key. If not, the procedure stops.

### Preparation for IDENTITY regeneration:

- Collects necessary SQL commands in a temporary table (`@SQLCmd2IdentityRebirth`) for sequential execution.

### Foreign key management:

- Identifies and removes foreign keys referencing the primary key to avoid conflicts.

### Table backup and manipulation:

- Adds a temporary column to store current IDENTITY values.
- Creates a backup of the original table.
- Truncates the original table to reset IDENTITY values.

### Data re-insertion:

- Re-inserts data from the backup table to the original table, excluding the IDENTITY column.
- Updates foreign key references to reflect the new IDENTITY values.

### Cleanup:

- Removes the temporary column.
- Recreates previously removed foreign keys.

### Transaction and error handling:

- Starts an explicit transaction if none exists.
- Rolls back the transaction and raises an error in case of failure.
- Commits the transaction if all commands execute successfully.

## Installation

1. Download the `sp_identity_rebirth.sql` file from this repository.
2. Open the file in SQL Server Management Studio (SSMS) or Azure Data Studio
3. Execute the script in the context of your database.

## Usage

```sql
EXEC sp_identity_rebirth
  -- The schema name of the table
  @SchemaName = 'dbo'
  -- The name of the table containing the IDENTITY column
  ,@TableName = 'YourTable'
  -- The name of the IDENTITY column to regenerate
  ,@IdentityColumnName = 'YourIdentityColumn';
```

## Contributing

Contributions are welcome! To contribute, follow these steps:

1. Fork the repository.
2. Create a new branch:
    ```bash
    git checkout -b feature-branch
    ```
3. Make your changes.
4. Commit your changes:
    ```bash
    git commit -m 'Add some feature'
    ```
5. Push to the branch:
    ```bash
    git push origin feature-branch
    ```
6. Open a pull request.

