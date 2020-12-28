https://www.youtube.com/watch?v=QjICgmk31js

.output ./Desktop/Life/test.sql
CREATE TABLE employees (id integer primary key, name text);
.dump


PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE employees (id integer primary key, name text, house text, age integer);
INSERT INTO employees VALUES(1,'Harsh Sinha', 'Currier', 21);
INSERT INTO employees VALUES(2,'Rana Bansal', 'Currier', 21);
INSERT INTO employees VALUES(3,'Eric Timmerman', 'Currier', 23);
INSERT INTO employees VALUES(4,'Noah Golowhich', 'Currier',22);
INSERT INTO employees VALUES(5,'John Beadle', 'Currier',23);
INSERT INTO employees VALUES(6,'John Beadle', 'Currier',23);
INSERT INTO employees VALUES(7,'Shashwat Kishore', 'Cabot',22);
INSERT INTO employees VALUES(8,'Easton Shultz', 'Winthrop',20);
INSERT INTO employees VALUES(9,'Johnathon Paek', 'Elliot',20);
INSERT INTO employees VALUES(10,'Tyler Lott', 'Winthrop',20);
INSERT INTO employees VALUES(11,'Aashay Sanghvi', 'Winthrop',23);
COMMIT;

CREATE TABLE employers (id integer primary key, name text, house text, age integer);
INSERT INTO employers VALUES(12,'Mark Zuckerberg', 'Kirkland', 21);
INSERT INTO employers VALUES(13,'Barack Obama', 'Law', 21);
INSERT INTO employers VALUES(14,'FDR', 'Adams', 23);
INSERT INTO employers VALUES(15,'JFK', 'Adams',22);
INSERT INTO employers VALUES(16,'Ted Kennedy', 'Adams',23);
INSERT INTO employers VALUES(17,'Mark Cuban', 'Currier',23);
INSERT INTO employers VALUES(18,'Donald Trump', 'Cabot',22);
INSERT INTO employers VALUES(19,'Sheraton Commander', 'Winthrop',20);
INSERT INTO employers VALUES(20,'Ali Partovi', 'Elliot',20);
INSERT INTO employers VALUES(21,'Rick Smith', 'Winthrop',20);
INSERT INTO employers VALUES(22,'Mich Church', 'Winthrop',23);
INSERT INTO employers VALUES(23,'Mich Church', 'Winthrop',23);
