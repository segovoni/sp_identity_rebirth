------------------------------------------------------------------------
-- Project:      dbo.sp_identity_rebirth                              --
--                                                                    --
--               Regenerate IDENTITY column values in SQL Server and  --
--               Azure SQL tables, ensuring referential integrity and --
--               preserving related objects like constraints,         --
--               indexes, and triggers.                               --
--                                                                    --
--               This process prevents data overflow errors and       --
--               maintains data consistency without renaming or       --
--               losing linked objects.                               --
--                                                                    --
-- File:         Test                                                 --
-- Author:       Sergio Govoni https://www.linkedin.com/in/sgovoni/   --
-- Notes:        --                                                   --
------------------------------------------------------------------------

USE [tempdb];
GO

DROP TABLE IF EXISTS dbo.TableDetails;
DROP TABLE IF EXISTS dbo.TableDetails1;
DROP TABLE IF EXISTS dbo.TableMaster;
GO

CREATE TABLE dbo.TableMaster
(
  ID INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY
  ,ObjectName SYSNAME
);

CREATE TABLE dbo.TableDetails
(
  ID INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY
  ,ObjectType CHAR(1)
  ,IDTableMaster INTEGER NOT NULL
);
ALTER TABLE dbo.TableDetails ADD CONSTRAINT FK_1 FOREIGN KEY (IDTableMaster) REFERENCES dbo.TableMaster(ID);

CREATE TABLE dbo.TableDetails1
(
  ID INTEGER IDENTITY(1, 1) NOT NULL PRIMARY KEY
  ,ObjectType CHAR(1)
  ,IDTableMaster INTEGER NOT NULL
);
ALTER TABLE dbo.TableDetails1 ADD CONSTRAINT FK_11 FOREIGN KEY (IDTableMaster) REFERENCES dbo.TableMaster(ID);
GO

INSERT INTO dbo.TableMaster
(ObjectName) VALUES ('Uno'), ('Due'), ('Tre'), ('Quattro');
INSERT INTO dbo.TableDetails
(ObjectType, IDTableMaster) VALUES ('A', 1), ('B', 2), ('C', 3), ('D', 4);
INSERT INTO dbo.TableDetails1
(ObjectType, IDTableMaster) VALUES ('A', 1), ('B', 2), ('C', 3), ('D', 4);
GO

ALTER TABLE dbo.TableDetails DROP CONSTRAINT FK_1
ALTER TABLE dbo.TableDetails1 DROP CONSTRAINT FK_11
GO

DELETE FROM dbo.TableDetails;
DELETE FROM dbo.TableDetails1;
DELETE FROM dbo.TableMaster;
GO

ALTER TABLE dbo.TableDetails ADD CONSTRAINT FK_1 FOREIGN KEY (IDTableMaster) REFERENCES dbo.TableMaster(ID);
ALTER TABLE dbo.TableDetails1 ADD CONSTRAINT FK_11 FOREIGN KEY (IDTableMaster) REFERENCES dbo.TableMaster(ID);
GO

INSERT INTO dbo.TableMaster
(ObjectName) VALUES ('Cinque'), ('Sei'), ('Sette'), ('Otto');
INSERT INTO dbo.TableDetails
(ObjectType, IDTableMaster) VALUES ('E', 5), ('F', 6), ('G', 7), ('H', 8);
INSERT INTO dbo.TableDetails1
(ObjectType, IDTableMaster) VALUES ('E', 5), ('F', 6), ('G', 7), ('H', 8);
GO

SELECT * FROM dbo.TableMaster;
SELECT * FROM dbo.TableDetails;
SELECT * FROM dbo.TableDetails1;
GO

EXEC dbo.sp_identity_rebirth @SchemaName = 'dbo', @TableName = 'TableMaster', @IdentityColumn = 'ID';
GO

SELECT * FROM dbo.TableMaster;
SELECT * FROM dbo.TableDetails;
SELECT * FROM dbo.TableDetails1;
GO