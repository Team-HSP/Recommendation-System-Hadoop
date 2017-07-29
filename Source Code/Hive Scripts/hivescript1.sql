create database recomsys;
use recomsys;

CREATE EXTERNAL TABLE collab(
uid int, 
itemid int)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
stored as textfile LOCATION '/RcomSys/CollabOut';

CREATE EXTERNAL TABLE content(
uid int, 
itemid int)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
STORED AS textfile LOCATION '/RcomSys/ContentOut';

CREATE EXTERNAL TABLE hybrid(
uid int, 
itemid int)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
STORED AS textfile LOCATION '/RcomSys/HybridOut';

CREATE EXTERNAL TABLE items(
itemid int, 
itemtitle string, 
release_date string, 
video_release_date string, 
url string, 
g0 int,g1 int,g2 int,g3 int,g4 int,g5 int,g6 int,g7 int,g8 int,g9 int,g10 int,
g11 int,g12 int,g13 int,g14 int,g15 int,g16 int,g17 int,g18 int)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n' 
STORED AS textfile LOCATION '/RcomSys/Item';


CREATE EXTERNAL TABLE users(
uid int, 
age int, 
gender string, 
occupation string, 
zip int)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n' 
STORED AS textfile LOCATION '/RcomSys/User';

CREATE EXTERNAL TABLE uir(
uid int, 
itemid int, 
rating int)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n' 
STORED AS textfile LOCATION '/RcomSys/UserItemRating';

CREATE EXTERNAL TABLE genre(
genre string, 
gid int)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n' 
STORED AS textfile LOCATION '/RcomSys/Genre';

