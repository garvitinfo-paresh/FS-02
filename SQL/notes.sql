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


*/



