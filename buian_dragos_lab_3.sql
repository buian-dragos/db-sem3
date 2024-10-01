
-- a
-- change type of sale_percent
CREATE OR ALTER PROCEDURE updateInt
AS
	ALTER TABLE Reviews 
		ALTER COLUMN score INT
GO

-- reverse
CREATE OR ALTER PROCEDURE updateFloat
AS
	ALTER TABLE Reviews 
		ALTER COLUMN score FLOAT
GO

-- b
-- add email to Customer table
CREATE OR ALTER PROCEDURE addEmailColumn 
AS
	ALTER TABLE Customer 
		ADD email VARCHAR(50)
GO

-- reverse
CREATE OR ALTER PROCEDURE removeEmailColumn 
AS
	ALTER TABLE Customer
		DROP COLUMN email
GO

-- c
-- add default price 50

CREATE OR ALTER PROCEDURE addDefaultPrice
AS
	ALTER TABLE Products
		ADD CONSTRAINT default_price
			DEFAULT 50 FOR price
GO

-- reverse
CREATE OR ALTER PROCEDURE removeDefaultPrice
AS
	ALTER TABLE Products
		DROP CONSTRAINT default_price
GO

-- d
-- set sale_id to primary key
CREATE OR ALTER PROCEDURE addPrimaryKey
AS
	ALTER TABLE Sales
	ADD CONSTRAINT pk_id PRIMARY KEY(sale_id)
GO

-- reverse
CREATE OR ALTER PROCEDURE removePrimaryKey
AS
	ALTER TABLE Sales
	DROP CONSTRAINT IF EXISTS pk_id
GO

-- e
-- add candidate key to Customer CNP
CREATE OR ALTER PROCEDURE addCandidateKey
AS
	ALTER TABLE Customer
		ADD CONSTRAINT cust_ck UNIQUE (CNP, customer_id)
GO

-- reverse
CREATE OR ALTER PROCEDURE removeCandidateKey
AS
	ALTER TABLE Customer
		DROP CONSTRAINT IF EXISTS cust_ck
GO

-- f
-- add foreign key FK_order_id -> order_id
CREATE OR ALTER PROCEDURE addForeignKey
AS
	ALTER TABLE OrdersProductsAux
		ADD CONSTRAINT fk_opa_order_id
			FOREIGN KEY(FK_order_id) REFERENCES Orders(order_id)
GO
-- reverse
CREATE OR ALTER PROCEDURE removeForeignKey
AS
	ALTER TABLE OrdersProductsAux
		DROP CONSTRAINT IF EXISTS fk_opa_order_id
GO

-- g
-- create table Shop_Managers
CREATE OR ALTER PROCEDURE addTable
AS
	CREATE TABLE Shop_Managers (
		sm_id INT,
		sm_name VARCHAR(50),
		salary INT,
		 FK_departament_id INT,
		FOREIGN KEY (FK_departament_id) REFERENCES Room_Departments(departament_id)
	)
GO

-- reverse
CREATE OR ALTER PROCEDURE dropTable
AS
	DROP TABLE IF EXISTS Shop_Managers
GO

/*
CREATE TABLE Procedures_Table(
	ver INT PRIMARY KEY,
	upgradeFrom VARCHAR(50),
	downgradeTo VARCHAR(50)
);


INSERT INTO Procedures_Table (ver,upgradeFrom, downgradeTo)
VALUES
	(1,'updateInt','updateFloat'),
	(2,'addEmailColumn','removeEmailColumn'),
	(3,'addDefaultPrice','removeDefaultPrice'),
	(4,'addPrimaryKey','removePrimaryKey'),
	(5,'addCandidateKey','removeCandidateKey'),
	(6,'addForeignKey','removeForeignKey'),
	(7,'addTable','dropTable');


SELECT * FROM Procedures_Table

CREATE TABLE Version_Table(
	ver INT UNIQUE
);
*/

GO

CREATE OR ALTER PROCEDURE goToVersion(@newVersion INT) 
AS
	DECLARE @crt INT
	DECLARE @procedureName VARCHAR(100)
	SELECT @crt = ver FROM Version_Table
	DECLARE @max_ver  INT
	SELECT @max_ver = COUNT(*) FROM Procedures_Table
	BEGIN
		IF @newVersion = @crt
			PRINT('Already on this version!');
		ELSE
		IF @newVersion > @max_ver + 1
			PRINT('Version not avalible!');
		ELSE
		BEGIN
			IF @crt > @newVersion
			BEGIN
				WHILE @crt > @newVersion
				BEGIN
					SELECT @procedureName = downgradeTo FROM Procedures_Table 
					WHERE ver = @crt - 1
					PRINT('executing: ' + @procedureName);
					EXEC(@procedureName)
					SET @crt = @crt - 1
				END
			END

			IF @crt < @newVersion
			BEGIN
				WHILE @crt < @newVersion
					BEGIN
						SELECT @procedureName = upgradeFrom FROM Procedures_Table
						WHERE ver = @crt 
						PRINT('executing: ' + @procedureName);
						EXEC (@procedureName)
						SET @crt = @crt + 1
					END
			END

			UPDATE Version_Table SET ver = @newVersion
		END
	END
GO



EXEC goToVersion 2


SELECT ver FROM Version_Table