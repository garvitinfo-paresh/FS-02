/*
29-07-2026
----------
    sdfdsf

-- Mysql SQL

MySQL - server (software ) database 
oracle

SQL - Structured Query Language
      programing lang. 
      relation database 

---------------------
Classification of SQL 
----------------------

DDL - Data Defination Language
      - create,alter,drop, 

DML - Data Manupulation Language
      - insert,update,delete  

TCL - Transaction Control Language
      - Begin /start END

System datdata

mysql> show databases; 
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.488 sec)



create database myschool;
use myschool;

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| myschool           |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.014 sec)

create database <db-name>;

create table <tbl-name> 
(
col-1 data-type(size),
col-1 data-type(size),
col-1 data-type(size),
col-1 data-type(size),
.
.
.

);

mysql -u root -proot myschool

create table student (name varchar(10),email varchar(15),contact varchar(15));

// 30-07-2026

mysql> show tables;
+--------------------+
| Tables_in_myschool |
+--------------------+
| student            |
+--------------------+
1 row in set (0.291 sec)


display all records/data/
mysql> select * from student;
Empty set (0.158 sec)

mysql> desc student;
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| name    | varchar(10) | YES  |     | NULL    |       |
| email   | varchar(15) | YES  |     | NULL    |       |
| contact | varchar(15) | YES  |     | NULL    |       |
+---------+-------------+------+-----+---------+-------+
3 rows in set (0.521 sec)

mysql> insert into student values("Raj","raj@gmail.com","9898989898");
Query OK, 1 row affected (0.199 sec)

insert into student values("Advik","advik@gmail.com","6565656555");
insert into student values("Manik","manik@gmail.com","9878845878");
insert into student values("Kejal","kejal@gmail.com","5454546569");
insert into student values("sitara","sitar@gmail.com","8787877989");

mysql> select * from student;
+--------+-----------------+------------+
| name   | email           | contact    |
+--------+-----------------+------------+
| Raj    | raj@gmail.com   | 9898989898 |
| Advik  | advik@gmail.com | 6565656555 |
| Manik  | manik@gmail.com | 9878845878 |
| Kejal  | kejal@gmail.com | 5454546569 |
| sitara | sitar@gmail.com | 8787877989 |
+--------+-----------------+------------+
5 rows in set (0.004 sec)

* -> Entire Table 

what if i want only name;


/// Column level filter
select name from student;
mysql> select name from student;
+--------+
| name   |
+--------+
| Raj    |
| Advik  |
| Manik  |
| Kejal  |
| sitara |
+--------+
5 rows in set (0.004 sec)


mysql> select *,name,contact from student;
+--------+-----------------+------------+--------+------------+
| name   | email           | contact    | name   | contact    |
+--------+-----------------+------------+--------+------------+
| Raj    | raj@gmail.com   | 9898989898 | Raj    | 9898989898 |
| Advik  | advik@gmail.com | 6565656555 | Advik  | 6565656555 |
| Manik  | manik@gmail.com | 9878845878 | Manik  | 9878845878 |
| Kejal  | kejal@gmail.com | 5454546569 | Kejal  | 5454546569 |
| sitara | sitar@gmail.com | 8787877989 | sitara | 8787877989 |
+--------+-----------------+------------+--------+------------+
5 rows in set (0.017 sec)


mysql> select name,contact,* from student;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '* from student' at line 1
mysql> select name,*,contact from student;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '*,contact from student' at line 1
mysql>


////row level 

Where Clause

select * from <table -name>
where <Expression>;
mysql> select * from student where name='Raj';

mysql> select name,contact from student where name='Raj';

mysql> select * from student order by name;

mysql> select * from student order by name desc;

DATATYPE
---------------

Size  - 1 Bytes = 8 bit  = 2^8

DT                SIZE                    RANGE
-------------------------------------------------------
BIT                                         1 to 64 
TINYINT          1 Bytes                   -128 to +127      
SMALLINT         2 Bytes                   -32768 to +32767      
MEDIUMINT        3 Bytes                          
INT/INTEGER      4 Bytes                  -+ 2.15 *10^9        
BIGINT           8 Bytes                   large         

NUMERIC                                    

VARCHAR                                     65535  cha                          
CHAR                                        255 char
TEXT             65535 bytes
ENUM             
BLOB


DATE            YYYY-MM-DD  
TIME            HH:MM:SS        
YEAR            YYYY  
DATETIME        YYYY-MM-DD HH:MM:SS 
TIMESTAMP       YYYY-MM-DD HH:MM:SS UTC

JSON


04-08-2026
----------
create table student (name varchar(10),email varchar(15),contact varchar(15),city varchar(15));

insert into student values("Raj","raj@gmail.com","9898989898","Vapi");
insert into student values("Advik","advik@gmail.com","6565656555","Baroda");
insert into student values("Manik","manik@gmail.com","9878845878","Surat");
insert into student values("Kejal","kejal@gmail.com","5454546569","Vapi");
insert into student values("sitara","sitar@gmail.com","8787877989","Surat");
insert into student values("Arjav","arjav@gmail.com","","");
insert into student values("Keshav","kesh@gmail.com",null,null);

delete
--------
delete from <tabele-name>;
delete from student;


mysql> delete from student;
Query OK, 5 rows affected (0.193 sec)

delete from student where name = 'Advik';

Truncate
-----
truncate table <table-name>;


drop 
----
mysql> drop table student;
Query OK, 0 rows affected (0.424 sec)

mysql> show tables;
Empty set (0.016 sec)

Update
------ 

update <tb-name> set <col-name> = <value>;
update student set city = 'Surat';

mysql> update student set city = 'Surat';
Query OK, 5 rows affected (0.132 sec)
Rows matched: 5  Changed: 5  Warnings: 0


update student set city = 'Vapi' where contact=null;

mysql> select * from student where contact="NULL";
Empty set (0.005 sec)

mysql> select * from student where contact is NULL;
+--------+----------------+---------+-------+
| name   | email          | contact | city  |
+--------+----------------+---------+-------+
| Keshav | kesh@gmail.com | NULL    | Surat |
+--------+----------------+---------+-------+
1 row in set (0.109 sec)

mysql> update student set city = 'Baroda' where contact is NULL;
Query OK, 1 row affected (0.125 sec)
Rows matched: 1  Changed: 1  Warnings: 0


Alter 
------ 
ALTER TABLE <tb-name>
ADD COLUMN <col-name> data-type(size);   

ALTER TABLE student
ADD COLUMN state varchar(20);   

mysql> ALTER TABLE student
    -> ADD COLUMN state varchar(20);
Query OK, 0 rows affected (0.184 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc student;
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| name    | varchar(10) | YES  |     | NULL    |       |
| email   | varchar(15) | YES  |     | NULL    |       |
| contact | varchar(15) | YES  |     | NULL    |       |
| city    | varchar(15) | YES  |     | NULL    |       |
| state   | varchar(20) | YES  |     | NULL    |       |
+---------+-------------+------+-----+---------+-------+
5 rows in set (0.168 sec)

ALTER TABLE student
MODIFY COLUMN contact varchar(25);   


ALTER TABLE student
DROP COLUMN State;   

ALTER TABLE student
RENAME COLUMN contact TO mobileno;   


ALTER TABLE bagproject
ADD CONTRAINT PK_BAGPROJECT PRIMARY KEY (color,size,capacity);   




05-08-2026
----------

Contraint
---------

-- create table student (grno int primary key name varchar(10),email varchar(15),contact varchar(15),city varchar(15));

insert into student1 values(1011,"Raj","raj@gmail.com","9898989898","Vapi");
insert into student1 values(1012,"Advik","advik@gmail.com","6565656555","Baroda");
insert into student1 values(1013,"Manik","manik@gmail.com","9878845878","Surat");
insert into student1 values(1014,"Kejal","kejal@gmail.com","5454546569","Vapi");
insert into student1 values(1015,"sitara","sitar@gmail.com","8787877989","Surat");
insert into student1 values(1016,"Arjav","arjav@gmail.com","","");
insert into student1 values(1017,"Keshav","kesh@gmail.com",null,null);

create table student1 (grno int primary key, name varchar(10),email varchar(15),contact varchar(15),city varchar(15));


-- Uniqly indetify 
-- not allow duplicate 
-- not allow NULL
-- not compolsary but recommended   
-- to relation another table column 
-- only one primary key allowd per table
-- one table can be combine up to 32 column 

06-08-2026
----------

            R-G-B       S-M-L       20-30-40
bag-        color       Size         Capaciy      price    
-----------------------------------------------------------                  
      insert into bagproject1 values ( "R","S","20",800 );
      insert into bagproject1 values ( "R","M","20",800 );   
      insert into bagproject1 values ( "R","L","20",800 );  

      insert into bagproject1 values ( "R","S","30",1200 );   
      insert into bagproject1 values ( "R","M","30",1200 );   
      insert into bagproject1 values ( "R","L","30",1200 );

      insert into bagproject1 values ( "R","S","40",1500 );
      insert into bagproject1 values ( "R","M","40",1500 );
      insert into bagproject1 values ( "R","L","40",1500 );  


      insert into bagproject values ( "G","S","20",800 );   
      insert into bagproject values ( "G","M","20",800 );   
      insert into bagproject values ( "G","L","20",800 );   
      insert into bagproject values ( "G","S","30",1200 );   
      insert into bagproject values ( "G","M","30",1200 );   
      insert into bagproject values ( "G","L","30",1200 );   
      insert into bagproject values ( "G","S","40",1500 );   
      insert into bagproject values ( "G","M","40",1500 );   
      insert into bagproject values ( "G","L","40",1500 );   
      insert into bagproject values ( "B","S","20",800 );   
      insert into bagproject values ( "B","M","20",800 );   
      insert into bagproject values ( "B","L","20",800 );   
      insert into bagproject values ( "B","S","30",1200 );   
      insert into bagproject values ( "B","M","30",1200 );   
      insert into bagproject values ( "B","L","30",1200 );   
      insert into bagproject values ( "B","S","40",1500 );   
      insert into bagproject values ( "B","M","40",1500 );   
      insert into bagproject values ( "B","L","40",1500 );   

Composite primary key              

create table bagproject(
color varchar(5),
size varchar(5),
capacity varchar(5),
price decimal(6,2),
CONSTRAINT PK_BAGPROJECT PRIMARY KEY (color,size,capacity)
);

select concat(color,'-',size,'-',capacity) as "Product_Code" from bagproject;

create table bagproject1(
color varchar(5) not null,
size varchar(5) unique,
capacity varchar(5) unique,
price decimal(6,2)
);

customer
      Adhar unique
      pan   unique

06-08-2026
----------
FOREIGN KEY Syntax

CREATE TABLE <table-name> (
    col-1 int NOT NULL PRIMARY KEY,
    col-2 int,
    CONSTRAINT <contstraint-name> FOREIGN KEY (col of this table  ) REFERENCES <reference-table>(col reference-table-column)
    CONSTRAINT <contstraint-name> CHECK <Expression>
);


Manufacturing Production
------------------------
Analyze production, machine, inventory, quality, maintainance
 
 1) create Database 
      
      CREATE DATABASE manufacturing_db;

2) creating Tables

      products table
      ---------------      
      CREATE TABLE products(
      product_id INT PRIAMARY KEY,
      product_name VARCHAR(75),
      category VARCHAR(50),
      product_cost DECIMAL(9,2)
      );

      machine table
      ---------------

      CREATE TABLE machine(
      machine_id INT PRIAMARY KEY,
      machine_name VARCHAR(75),
      production_line VARCHAR(50),
      machine_install_date DATE
      )

      production table
      ---------------

     CREATE TABLE production(
      production_id INT PRIAMARY KEY,
      product_id INT,
      machine_id INT,
      produciton_date DATE,
      units_produced INT,
      units_defective INT,
      production_duration DECIMAL(5,2)
      CONSTRAINT FK_Product FOREIGN KEY (product_id) REFERENCES products(product_id),
      CONSTRAINT FK_Machine FOREIGN KEY (machine_id) REFERENCES machine(machine_id),
      );

      maintainance table
      ---------------

      CREATE TABLE maintainance(
      maintainance_id INT PRIAMARY KEY,
      machine_id INT,
      maintainance_date DATE,
      machine_name VARCHAR(75),
      production_line VARCHAR(50),
      )

      production table
      ---------------

-- 12-08-2026

mysql> select sum(product_cost) "Total sum of products" from products;
+-----------------------+
| Total sum of products |
+-----------------------+
|               1261.95 |
+-----------------------+

1 row in set (0.005 sec)
mysql> select avg(product_cost) from products;
+-------------------+
| avg(product_cost) |
+-------------------+
|         84.130000 |
+-------------------+
1 row in set (0.006 sec)

mysql> select min(product_cost) from products;
+-------------------+
| min(product_cost) |
+-------------------+
|              0.25 |
+-------------------+
1 row in set (0.105 sec)

mysql> select max(product_cost) from products;
+-------------------+
| max(product_cost) |
+-------------------+
|            600.00 |
+-------------------+
1 row in set (0.007 sec)


mysql> select count(*) from products where category = 'container';
+----------+
| count(*) |
+----------+
|        6 |
+----------+
1 row in set (0.108 sec)


mysql>  select distinct category from products;
+-----------+
| category  |
+-----------+
| container |
| holdings  |
| packaging |
+-----------+
3 rows in set (0.112 sec)

mysql>  select count(distinct category) from products;
+--------------------------+
| count(distinct category) |
+--------------------------+
|                        3 |
+--------------------------+
1 row in set (0.008 sec)


*/



