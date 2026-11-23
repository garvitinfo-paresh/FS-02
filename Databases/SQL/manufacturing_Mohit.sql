manufacturing production
-------------------------

  --analyze production machine,enventry,quality,maintainance


-- 1 data base

     CREATE DATABASE manufacturing_db;

-- 2 create table 

--    PRODUCT TABLE
      --------------

      CREATE TABLE products(
      product_id int PRIMARY KEY,
      product_name VARCHAR(75),
      category VARCHAR(50),
      product_cost DECIMAL(9,2)
      );

--   machine table
    ---------------

      CREATE TABLE machine(
      machine_id int PRIMARY KEY,
      machine_name VARCHAR(75),
      production_line VARCHAR(50),
      idal_time DECIMAL(5,2),
      machine_install_date DATE
      );

--  production table
    -----------------

      CREATE TABLE production(
      production_id int PRIMARY KEY,
      product_id int,
      machine_id int,
      production_date DATE,
      units_produced int,
      units_defective int,
      production_duration DECIMAL(5,2),
      CONSTRAINT FK_PRODUCT FOREIGN KEY(product_id) REFERENCES products(product_id),
      CONSTRAINT FK_MACHINE_PRODUCTION FOREIGN KEY(machine_id) REFERENCES machine(machine_id)
      );

--  maintainance table
    --------------------

      CREATE TABLE maintainance(
      maintainance_id int PRIMARY KEY,
      machine_id int,
      maintainance_date DATE,
      maintainance_desc VARCHAR(75),
      holt_time DECIMAL(5,2),
      maintainance_cost DECIMAL(9,2),
      CONSTRAINT FK_MACHINE_MAINTAINANCE FOREIGN KEY(machine_id) REFERENCES machine(machine_id)
      );

-- 3 INSERT VALUES IN TABLE 
      truncate table  maintainance;
      truncate table  production ;
      truncate table  machine ;
      truncate table  products ;

      select * from  maintainance;
      select * from  production ;
      select * from  machine ;
      select * from  products ;


--    PRODUCT TABLE
      --------------

      INSERT INTO products VALUES -- 15 recors must
      (1001,'bottle','container',10.5),
      (1002,'cap','container',1.5),
      (2001,'rock','holdings',125),
      (2002,'rock_stend','holdings',8.5),
      (3001,'bottle_lebal','packaging',0.5),
      (1003, 'glass_bottle_500ml','container',25.00),
      (1004,'plastic_jug_1L','container',15.00),
      (1005,'sports_cap','container',3.00),
      (1006,'metal_cap','container',1.20),
      (2003,'wooden_pallet','holdings',450.00),
      (2004,'plastic_pallet','holdings',600.00),
      (3002,'box_barcode_label','packaging',0.25),
      (4001,'cardboard_box_small','packaging',2.50),
      (4002,'cardboard_box_large','packaging',4.00),
      (5001,'shrink_wrap_roll','packaging',15.00);

--   machine table
    ---------------

      INSERT INTO machine VALUES -- 10 record must
      (1001,'RX001-semiauto','line-A',150,'2026-07-07'),
      (1002,'RX001-manual','line-B',90,'2026-07-07'),
      (1003,'Ro001-automatic','line-A',120,'2026-07-07'),
      (1004,'FillMaster-2000', 'line-A',45.00,'2023-01-15'),
      (1005,'CapTight-Auto','line-A', 30.00,'2023-02-20'),
      (1006,'LabelPrint-Pro','line-B', 15.00,'2024-05-10'),
      (1007,'BoxFolder-X1','line-C', 60.00,'2022-11-05'),
      (1008,'ShrinkWrap-Heat','line-C', 25.00,'2025-01-12'),
      (1009,'Palletizer-Robot','line-End', 120.00,'2025-06-30'),
      (1010,'GlassMolder-V2','line-D', 200.00,'2021-08-15');

--  production table
    -----------------

      INSERT INTO production VALUES -- 10 record must
      (1101,1001,1001,'2026-07-07',2150,50,21.5),
      (1102,1002,1002,'2026-07-07',22500,2500,22.5),
      (1103,3001,1003,'2026-07-07',33000,3500,22),
      (1104,1003,1010,'2026-07-08',5000,120,24.0),
      (1105,1004,1004,'2026-07-08',3500,45,12.5),
      (1106,1005,1005,'2026-07-09',15000,300,18.0),
      (1107,3002,1006,'2026-07-09',50000,150,10.0),
      (1108,4001,1007,'2026-07-10',8000,50,14.5),
      (1109,5001,1008,'2026-07-10',1500,15,8.0),
      (1110,2003,1009,'2026-07-11',200,2,16.0);
      
--  maintainance table
    --------------------

      INSERT INTO maintainance VALUES -- 5 record must
      (1,1001,'2026-07-07','none',0,0),
      (2,1002,'2026-07-07','none',0,0),
      (3,1001,'2026-07-15','Routine oil and filter change',2.50,150.00),
      (4,1002,'2026-07-18','Replaced worn conveyor belt',4.00,450.50),
      (5,1005,'2026-07-20','Sensor calibration and alignment',1.00,75.00),
      (6,1007,'2026-07-22','Motor overheating repair',6.50,1200.00),
      (7,1010,'2026-08-01','Annual deep cleaning',12.00,800.00);

