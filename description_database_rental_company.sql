--database creation named rental_company 
CREATE DATABASE rental_company

--table creation named CALLS with PRIMARY KEY - id and FOREIGN KEY - ref_customer to parent table CUSTOMERS
CREATE TABLE CALLS( 
	id INTEGER NOT NULL, 
	car_brand TEXT Not Null, 
	ref_customer INTEGER Not Null,
	date_call DATE Not Null, 
	PRIMARY KEY(id), 
	FOREIGN KEY (ref_customer) REFERENCES CUSTOMERS(id) 
	);

--table creation named CARS with PRIMARY KEY - car_number
CREATE TABLE CARS( 
	car_number INTEGER NOT NULL,
	cost NUMERIC NOT NULL, 
	manufacture_year INTEGER NOT NULL,
	type TEXT, 
	brand TEXT, 
	PRIMARY KEY(car_number) 
	);

--table creation named CONTRACTS with PRIMARY KEY - contract_number and FOREIGN KEY - ref_car to parent table CARS
--and FOREIGN KEY - ref_custmer to parent table CUSTOMERS.
CREATE TABLE CONTRACTS(
	contract_number INTEGER NOT NULL,
 	issue_date DATE Not Null, 
 	return_date DATE Not Null, 
	price INTEGER Not Null,
	is_car_damaged BOOLEAN Not Null, 
	fixed_fine INTEGER Not Null, 
	car_repair_cost INTEGER Not Null, 
	ref_car INTEGER Not Null, 
	ref_customer INTEGER Not Null,
	PRIMARY KEY(contract_number), 
	FOREIGN KEY (ref_car) REFERENCES CARS(car_number), 
	FOREIGN KEY (ref_customer) REFERENCES CUSTOMERS(id) 
	);

--table creation named CUSTOMERS with PRIMARY KEY - id
CREATE TABLE CUSTOMERS( 
	id INTEGER NOT NULL, 
	last_name TEXT Not Null, 
	first_name TEXT Not Null, 
	address TEXT Not Null, 
	PRIMARY KEY(id) 
	);

--insert data into tables

--adding data to a table-CALLS
INSERT INTO CALLS
(id, 
car_brand, 
ref_customer,
date_call)
VALUES (1, jaguar, 1, 1999);


--adding data to a table-CARS
INSERT INTO CARS
(car_number,
cost, 
manufacture_year,
type, 
brand)
VALUES (1, 11000, 1999, micro, citroen);
-- ...


--adding data to a table-CONTRACTS
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
VALUES (1, 2007-06-07, 2007-06-18, 30, FALSE, 10, 0,1, 2);
-- ...

--adding data to a table-CUSTOMERS
INSERT INTO CUSTOMERS( 
id, 
last_name, 
first_name, 
address)
VALUES(1, Radchenko, Vlada, Kharkov);


--Adding SQLite primary key example

/*Unlike other database systems e.g., MySQL, PostgreSQL, etc., you cannot use the ALTER TABLE statement to add a primary key to an existing table.

To work around this, you need to:

First, set the foreign key check off.
Next, rename the table to another table name (old_table)
Then, create a new table (table) with the exact structure of the table you have been renamed.
After that, copy data from the old_table to the table.
Finally, turn on the foreign key check on
See the following statements:*/
PRAGMA foreign_keys=off;
 
BEGIN TRANSACTION;
 
ALTER TABLE table RENAME TO old_table;
 
CREATE TABLE table ( ... );
 
INSERT INTO table SELECT * FROM old_table;
 
COMMIT;
 
PRAGMA foreign_keys=on;










