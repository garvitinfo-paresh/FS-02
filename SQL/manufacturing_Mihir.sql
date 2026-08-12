manufacturing production
--------------------------
analyze production, machine, inventrory , quality, maintainacnce

1)create database use database

    CREATE DATABASE manufacturing_db;
    USE manufacturing_db;

2)creating tables

    -- product table
    ----------------------
    CREATE TABLE products(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(75),
    category VARCHAR(50),
    product_cost DECIMAL(9,2)
    );

    -- machine table
    -----------------------
    CREATE TABLE machine(
    machine_id INT PRIMARY KEY,
    machine_name VARCHAR(75),
    production_line VARCHAR(50),
    idle_time DECIMAL(9,2),
    machine_install_date DATE
    );

    -- production table
    -------------------------
    CREATE TABLE production(
    production_id INT PRIMARY KEY,
    product_id INT ,
    machine_id INT,
    production_date DATE,
    units_producd INT,
    units_defective INT,
    producion_duration DECIMAL(5,2),
    CONSTRAINT  FK_Product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT  FK_Machine_Production FOREIGN KEY (machine_id) REFERENCES machine(machine_id)
    );

    -- maintainance table
    -------------------------
    CREATE TABLE maintainance(
    maintainance_id INT PRIMARY KEY,
    machine_id INT,
    maintainance_date DATE,
    maintainance_desc VARCHAR(75),
    halt_time DECIMAL(5,2),
    maintainance_cost DECIMAL(9,2),
    CONSTRAINT FK_Machine_Maintainance FOREIGN KEY(machine_id) REFERENCES machine(machine_id)
    );

    INSERT INTO products VALUES('1001','Bottle','Container',10.5);
    INSERT INTO products VALUES('1002','Cap','Container',1.5);
    INSERT INTO products VALUES('1003','Bottle_Label','Container',2.0);
    INSERT INTO products VALUES('1004','Bottle_Box','Packaging',5.5);
    INSERT INTO products VALUES('1005','Plastic_Jar','Container',15.0);
    INSERT INTO products VALUES('2001','Rack','Holding',125);
    INSERT INTO products VALUES('2002','Rack_stand','Holding',8.5);
    INSERT INTO products VALUES('2003','Storage_Bin','Holding',45);
    INSERT INTO products VALUES('2004','Pallet','Holding',75);
    INSERT INTO products VALUES('2005','Metal_Shelf','Holding',350);
    INSERT INTO products VALUES('3001','Carton_Box','Packaging',25);
    INSERT INTO products VALUES('3002','Packing_Tape','Packaging',12);
    INSERT INTO products VALUES('3003','Bubble_Wrap','Packaging',30);
    INSERT INTO products VALUES('3004','Plastic_Bag','Packaging',4.5);
    INSERT INTO products VALUES('3005','Stretch_Film','Packaging',55);
    INSERT INTO products VALUES('4001','Motor','Machine_Part',2500);
    INSERT INTO products VALUES('4002','Bearing','Machine_Part',350);
    INSERT INTO products VALUES('4003','Gear','Machine_Part',450);
    INSERT INTO products VALUES('4004','Conveyor_Belt','Machine_Part',1200);
    INSERT INTO products VALUES('4005','Steel_Rod','Raw_Material',180);    
    
    INSERT INTO machine VALUES(1001,'RX001-semiauto','Line-A',150,'2026-07-07');
    INSERT INTO machine VALUES(1002,'RX002-manual','Line-B',90,'2026-05-12');
    INSERT INTO machine VALUES(1003,'RX003-auto','Line-A',120,'2026-04-18');
    INSERT INTO machine VALUES(1004,'RX004-semiauto','Line-C',180,'2026-03-25');
    INSERT INTO machine VALUES(1005,'RX005-auto','Line-B',100,'2026-02-10');
    INSERT INTO machine VALUES(1006,'RX006-manual','Line-C',210,'2026-01-22');
    INSERT INTO machine VALUES(1007,'RX007-auto','Line-D',130,'2026-06-05');
    INSERT INTO machine VALUES(1008,'RX008-semiauto','Line-D',160,'2026-06-20');
    INSERT INTO machine VALUES(1009,'RX009-auto','Line-E',110,'2026-07-01');
    INSERT INTO machine VALUES(1010,'RX010-manual','Line-E',200,'2026-07-15');

    INSERT INTO production VALUES(1101,1001,1001,'2026-07-07',2150,50,21.5);
    INSERT INTO production VALUES(1102,1002,1002,'2026-07-07',22500,2500,22.5);
    INSERT INTO production VALUES(1103,2001,1003,'2026-07-08',850,17,17.0);
    INSERT INTO production VALUES(1104,2002,1004,'2026-07-08',4200,84,21.0);
    INSERT INTO production VALUES(1105,2003,1005,'2026-07-09',3600,72,18.0);
    INSERT INTO production VALUES(1106,2004,1006,'2026-07-09',1800,54,18.0);
    INSERT INTO production VALUES(1107,2005,1007,'2026-07-10',6000,120,20.0);
    INSERT INTO production VALUES(1108,1001,1008,'2026-07-10',7200,144,20.0);
    INSERT INTO production VALUES(1109,1002,1009,'2026-07-11',18000,360,20.0);
    INSERT INTO production VALUES(1110,2001,1010,'2026-07-11',2400,48,20.0);

    INSERT INTO maintainance VALUES(1,1001,'2026-07-07','none',0,0);
    INSERT INTO maintainance VALUES(2,1002,'2026-07-07','none',0,0);
    INSERT INTO maintainance VALUES(3,1003,'2026-07-08','Motor inspection',2.0,450.0);
    INSERT INTO maintainance VALUES(4,1005,'2026-07-09','Belt replacement',3.0,650.0);
    INSERT INTO maintainance VALUES(5,1007,'2026-07-10','Cooling system service',2.5,550.0);
    INSERT INTO maintainance VALUES(6,1008,'2026-07-12','Hydraulic system inspection',2.5,600.00);
    INSERT INTO maintainance VALUES(7,1010,'2026-07-13','Motor and gear maintenance',3.0,850.00);