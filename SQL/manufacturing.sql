-- 06-08-2026
-- ----------
-- Manufacturing Production
-- ------------------------
-- Analyze production, machine, inventory, quality, maintainance
 
--  1) create Database 
      
      CREATE DATABASE manufacturing_db;
      USE manufacturing_db;


-- 2) creating Tables

    --   products table
      ---------------      
      CREATE TABLE products(
      product_id INT PRIMARY KEY,
      product_name VARCHAR(75),
      category VARCHAR(50),
      product_cost DECIMAL(9,2)
      );

    --   machine table
    --   ---------------

      CREATE TABLE machine(
      machine_id INT PRIMARY KEY,
      machine_name VARCHAR(75),
      production_line VARCHAR(50),
      idle_time DECIMAL(5,2),
      machine_install_date DATE
      );

    --   production table
    --   ---------------

     CREATE TABLE production(
      production_id INT PRIMARY KEY,
      product_id INT,
      machine_id INT,
      produciton_date DATE,
      units_produced INT,
      units_defective INT,
      production_duration DECIMAL(5,2),
      CONSTRAINT FK_Product FOREIGN KEY (product_id) REFERENCES products(product_id),
      CONSTRAINT FK_Machine_Production FOREIGN KEY (machine_id) REFERENCES machine(machine_id)
      );

    --   maintainance table
    --   -----------------

      CREATE TABLE maintainance(
      maintainance_id INT PRIMARY KEY,
      machine_id INT,
      maintainance_date DATE,
      maintainance_desc VARCHAR(75),
      halt_time decimal(5,2),
      maintainance_cost decimal(9,2),
      CONSTRAINT FK_Machine_Maintainance FOREIGN KEY (machine_id) REFERENCES machine(machine_id)
      );

    --  bottel - > 1 hr -> 100
    --  daily - > 24 hr -> 2400
    --  monthly - > 24 hr -> 2150 
    
    --  bottel - > 1 hr -> 1000
    --  daily - > 24 hr -> 24000
    --  monthly - > 24 hr -> 22500
    
        -- 

    INSERT INTO products VALUES
    (1001,'Bottle','Container',10.5),
    (1002,'Cap','Container',1.5),
    (2001,'Rack','Holdings',125),
    (2002,'Rack_stand','Holdings',8.5);

    INSERT INTO machine VALUES
    (1001,'Rx001-Semiauto','Line-A',150,'2026-07-07'),
    (1002,'Rx002-menual','Line-B',90,'2026-07-07');

    INSERT INTO production VALUES
    (1101,1001,1001,'2026-07-07',2150,50,21.5),
    (1102,1002,1002,'2026-07-07',22500,2500,22.5);

      INSERT INTO maintainance VALUES
      (1,1001,'2026-07-07','none',0,0),
      (2,1002,'2026-07-07','none',0,0);

