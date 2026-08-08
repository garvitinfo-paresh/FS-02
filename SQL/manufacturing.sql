-- 06-08-2026
-- ----------
-- Manufacturing Production
-- ------------------------
-- Analyze production, machine, inventory, quality, maintainance
 
--  1) create Database 
      
--       CREATE DATABASE manufacturing_db;

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
      )

    --   production table
    --   ---------------

     CREATE TABLE production(
      production_id INT PRIMARY KEY,
      product_id INT,
      machine_id INT,
      produciton_date DATE,
      units_produced INT,
      units_defective INT,
      production_duration DECIMAL(5,2)
      CONSTRAINT FK_Product FOREIGN KEY (product_id) REFERENCES products(product_id),
      CONSTRAINT FK_Machine_production FOREIGN KEY (machine_id) REFERENCES machine(machine_id),
      );

    --   maintainance table
    --   -----------------

      CREATE TABLE maintainance(
      maintainance_id INT PRIMARY KEY,
      machine_id INT,
      maintainance_date DATE,
      maintainance_desc VARCHAR(75),
      halt_time decimal(5,2);
      maintainance_cost decimal(9,2),
      CONSTRAINT FK_Machine_Maintainance FOREIGN KEY (machine_id) REFERENCES machine(machine_id),
      )

    --  bottel - > 1 hr -> 180
    --  daily - > 24 hr -> 4320
    --  monthly - > 24 hr -> 129600  
                         --  125000  -> 8 moth
    -- 