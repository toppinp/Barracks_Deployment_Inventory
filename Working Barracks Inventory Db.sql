-- Military Pre-Deployment Barracks Inventory Database

DROP DATABASE IF EXISTS BarracksInventory;

CREATE DATABASE BarracksInventory;

USE BarracksInventory;

DROP TABLE	IF EXISTS dbo.Unit;

-- Unit Table

CREATE TABLE Unit 
(
	unitId		INT				NOT NULL PRIMARY KEY IDENTITY (1, 1),
	unitName	NVARCHAR (40)	NOT NULL, --Need to restrict input!!!
	unitAddress	NVARCHAR (40)	NOT NULL,
	unitRep		NVARCHAR (40)	NOT NULL,
	repPhone	NVARCHAR (40)	NOT NULL,	
);

INSERT INTO dbo.Unit (	unitName,		unitAddress,								unitRep,			repPhone)
	VALUES  (			'64TH MP CO',	'BLDG 10005, OLD IRONSIDES RD, FORT HOOD',	'SFC JOHN HOYNE',	'(123) 456-7890');

SELECT *
	FROM dbo.Unit;


DROP TABLE	IF EXISTS dbo.Account;

-- Account Table

CREATE TABLE Account
(
	userId		INT				NOT NULL PRIMARY KEY IDENTITY (1, 1),
	unitId		INT				NOT NULL,
		CONSTRAINT FK_Account_Unit
			FOREIGN KEY (unitId)
			REFERENCES Unit(unitId),

	name		NVARCHAR (40)	NOT NULL,
	ssn			NVARCHAR (15)	NULL,
	phone		NVARCHAR (15)	NOT NULL,
	address		NVARCHAR (50)	NOT NULL
);

INSERT INTO dbo.Account (	unitId,	name,				ssn,			phone,				address)
	VALUES  (				0001,	'Patrick Toppin',	'132-45-9876',	'(915) 801-6325',	'BLDG 10005, RM 105, OLD IRONSIDES RD, FORT HOOD'),
			(				0001,	'Nicholas Wiley',	'001-23-4567',	'(123) 654-9870',	'BLDG 10005, RM 110, OLD IRONSIDES RD, FORT HOOD'),
			(				0001,	'Mallory Johnson',	'987-65-4321',	'(987) 123-4567',	'BLDG 10005, RM 201, OLD IRONSIDES RD, FORT HOOD');

SELECT U.unitId, U.unitName, A.userId, A.name, A.address
	FROM dbo.Unit AS U
		INNER JOIN dbo.Account AS A
			ON U.unitId = A.unitId;


DROP TABLE IF EXISTS InventoryItem 

-- Inventory Item Table

CREATE TABLE dbo.InventoryItem
(
	itemId		INT				NOT NULL PRIMARY KEY IDENTITY (1, 1),
	userId		INT				NOT NULL,
		CONSTRAINT FK_InventoryItem_Account
			FOREIGN KEY (userId)
			REFERENCES Account(userId),
	
	itemName	NVARCHAR (40)	NOT NULL,
	qty			INT				NOT NULL,
	itemPrice	MONEY			NOT NULL
);

INSERT INTO dbo.InventoryItem	(userId,	itemName,				qty,	itemPrice)
	VALUES  (					0001,		'Sony Playstation 4',	1,		250.00),
			(					0001,		'HP 17" Laptop',		1,		400.00),
			(					0001,		'Bose 15" Speakers',	4,		250.00);

SELECT A.userId, A.name, II.itemName, II.qty, II.itemPrice
	FROM dbo.Account AS A
		INNER JOIN dbo.InventoryItem AS II
			ON A.userId = II.userId;


DROP TABLE IF EXISTS dbo.Inspection;

-- Inspection Table

CREATE TABLE dbo.Inspection 
(
	inspectId	INT				NOT NULL PRIMARY KEY IDENTITY,
	unitId		INT				NOT NULL,
		CONSTRAINT FK_Inspection_Unit
			FOREIGN KEY (unitId)
			REFERENCES Unit(unitId),
	userId		INT				NOT NULL,
		CONSTRAINT FK_Inspection_Account
			FOREIGN KEY (userId)
			REFERENCES Account(userId),

	inspectDate	DATE			NOT NULL,
	address		NVARCHAR (50)	NOT NULL,
	status		NVARCHAR (80)	NOT NULL,
);

INSERT INTO dbo.Inspection (unitId, userId, inspectDate,	address,											status)
	VALUES	(				0001,	0001,	'2020 JUN 01',	'BLDG 10005, RM 105, OLD IRONSIDES RD, FORT HOOD',	'NO ISSUES'),
			(				0001,	0002,	'2020 JUN 01',	'BLDG 10005, RM 110, OLD IRONSIDES RD, FORT HOOD',	'NO ISSUES'),
			(				0001,	0003,	'2020 JUN 01',	'BLDG 10005, RM 201, OLD IRONSIDES RD, FORT HOOD',	'FOUND UNSECURE');

SELECT *
	FROM dbo.Account AS A
		INNER JOIN dbo.Inspection aS I
			ON A.userId = I.userId
	WHERE I.inspectDate = '2020 JUN 01';
