use rcomsys;

add jar /usr/local/Hive/lib/mongo-hadoop-core-1.5.2.jar;
add jar /usr/local/Hive/lib/mongo-hadoop-hive-1.5.2.jar;
add jar /usr/local/Hive/lib/mongo-java-driver-3.2.1.jar;

CREATE TABLE mongo_collab(uid INT,itemid INT)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"uid":"uid","itemid":"itemid"}')
TBLPROPERTIES('mongo.uri'='mlocalhost:27017/rsystem.collab');

insert into table mongo_collab
select * from collab;


CREATE TABLE mongo_content(uid INT,itemid INT)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"uid":"uid","itemid":"itemid"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/rsystem.content');

insert into table mongo_content
select * from content;


CREATE TABLE mongo_hybrid(uid INT,itemid INT)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"uid":"uid","itemid":"itemid"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/rsystem.hybrid');

insert into table mongo_hybrid
select * from hybrid;


CREATE TABLE mongo_items(itemid int,
itemtitle string,
release_date string,
video_release_date string,
url string,
g0 int,g1 int,g2 int,g3 int,g4 int,g5 int,g6 int,g7 int,g8 int,g9 int,g10 int,g11 int,g12 int,g13 int,g14 int,g15 int,g16 int,g17 int,g18 int)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"itemid":"itemid","itemtitle":"itemtitle","release_date":"release_date","video_release_date":"video_release_date","url":"url","g0":"g0","g1":"g1",
"g2":"g2","g3":"g3","g4":"g4","g5":"g5","g6":"g6","g7":"g7","g8":"g8","g9":"g9","g10":"g10","g11":"g11","g12":"g12","g13":"g13","g14":"g14","g15":"g15","g16":"g16","g17":"g17","g18":"g18"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/rsystem.items');

insert into table mongo_items
select * from items;



CREATE TABLE mongo_users(uid INT,age int,gender string,occupation string,zip int)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"uid":"uid","itemid":"itemid"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/rsystem.users');

insert into table mongo_users
select * from users;



CREATE TABLE mongo_uir(uid INT,itemid INT,rating int)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"uid":"uid","itemid":"itemid","rating":"rating"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/rsystem.uir');

insert into table mongo_uir
select * from uir;



CREATE TABLE mongo_genre(genre string,gid int)
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"genre":"genre","gid":"gid"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/rsystem.genre');


insert into table mongo_genre
select * from genre;

