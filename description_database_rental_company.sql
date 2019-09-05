CREATE DATABASE rental_company;

CREATE TABLE CUSTOMERS( 
	id INTEGER NOT NULL, 
	last_name TEXT NOT NULL, 
	first_name TEXT NOT NULL, 
	address TEXT NOT NULL, 
	PRIMARY KEY(id) 
	);

CREATE TABLE CALLS( 
	id INTEGER NOT NULL, 
	car_brand TEXT NOT NULL, 
	ref_customer INTEGER NOT NULL,
	date_call DATE NOT NULL, 
	PRIMARY KEY(id), 
	FOREIGN KEY (ref_customer) REFERENCES CUSTOMERS(id) 
	);

CREATE TABLE CARS( 
	car_number INTEGER NOT NULL,
	cost NUMERIC NOT NULL, 
	manufacture_year INTEGER NOT NULL,
	type TEXT, 
	brand TEXT, 
	PRIMARY KEY(car_number) 
	);

CREATE TABLE CONTRACTS(
	contract_number INTEGER NOT NULL,
 	issue_date DATE NOT NULL, 
 	return_date DATE NOT NULL, 
	price INTEGER NOT NULL,
	is_car_damaged BOOLEAN, 
	fixed_fine INTEGER NOT NULL, 
	car_repair_cost INTEGER, 
	ref_car INTEGER NOT NULL, 
	ref_customer INTEGER NOT NULL,
	PRIMARY KEY(contract_number), 
	FOREIGN KEY (ref_car) REFERENCES CARS(car_number), 
	FOREIGN KEY (ref_customer) REFERENCES CUSTOMERS(id) 
	);

--insert data into tables

INSERT INTO CALLS
(id, 
car_brand, 
ref_customer,
date_call)
VALUES (1, "jaguar", 1, 1999);
-- ...


INSERT INTO CARS
(car_number,
cost, 
manufacture_year,
type, 
brand)
VALUES (1, 11000, 1999, "micro", "citroen");
-- ...


INSERT INTO CONTRACTS
(contract_number,
issue_date, 
return_date, 
price ,
is_car_damaged, 
fixed_fine, 
car_repair_cost , 
ref_car,
ref_customer)
VALUES (1, "2007-06-07", "2007-06-18", 30, FALSE, 10, 0,1, 2);
-- ...

INSERT INTO CUSTOMERS( 
id, 
last_name, 
first_name, 
address)
VALUES(1, "Radchenko", "Vlada", "Kharkov");

/*
Adding CHECK constraints to an existing table
As of version 3.25.2, SQLite does not support adding a CHECK constraint to an existing table.

However, I followed these steps:
*/

PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;
-- create a new table 
COMMIT;
CREATE TABLE CARS_(
    car_number INTEGER NOT NULL,
	cost NUMERIC NOT NULL, 
	manufacture_year INTEGER NOT NULL,
	type TEXT NOT NULL, 
	brand TEXT NOT NULL, 
	PRIMARY KEY(car_number) ,
    CHECK (cost BETWEEN 7000 AND 100000)
           
);
-- copy data from old table to the new one
INSERT INTO CARS_ SELECT * FROM CARS;
 
-- drop the old table

DROP TABLE CARS_;
-- rename new table to the old one
ALTER TABLE CARS_ RENAME TO CARS;
 
-- commit changes
COMMIT;
PRAGMA foreign_keys = ON;







--ONE-TABLE AND MULTI-TABLE REQUESTS TO DB

--List all clients of rental company

SELECT id, last_name, first_name, address
FROM CUSTOMERS;

--List calls sorted alphabetically without duplicate rows in the result set

SELECT DISTINCT date_call
FROM CALLS
ORDER BY date_call ASC;

--List the car's brand where manufacture year between 2000 and 2005 by sorting the lines
-- according to cost from less to more

SELECT brand
FROM CARS
WHERE manufacture_year BETWEEN 1995 AND 2005
ORDER BY cost ASC;

--List the names of all users starting with the letter - "I"

SELECT last_name, first_name
FROM CUSTOMERS
WHERE last_name LIKE "I%";

--List last name of customers, the date when they rented a car and car's brand, 
--price of car must be from 7000 up to 50000

SELECT DISTINCT CUSTOMERS.last_name, CONTRACTS.issue_date, CARS.brand
FROM CUSTOMERS, CONTRACTS, CARS
WHERE CARS.cost BETWEEN 7000 AND 50000;

--request that would give out the most 3 popular car's brand, judging by the calls

SELECT DISTINCT count(CALLS.car_brand), CALLS.car_brand 
FROM CALLS, CARS
WHERE CARS.brand = CALLS.car_brand
ORDER BY COUNT(CALLS.car_brand) DESC LIMIT 3;

--Print the average duration of the rental car when the car was harmful

SELECT CAST ((julianday(CONTRACTS.return_date) - julianday(CONTRACTS.issue_date)) AS REAL) AS HoursRented
FROM CONTRACTS
WHERE CONTRACTS.is_car_damaged = TRUE;


