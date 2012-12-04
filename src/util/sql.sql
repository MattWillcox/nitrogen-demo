-- SQL
CREATE TABLE game (gid int NOT NULL AUTO_INCREMENT, user1 varchar(25), user2 varchar(25), elo1 int, elo2 int, winner varchar(25), keystrokes1 int, keystrokes2 int, length int, time timestamp, PRIMARY KEY (gid));
CREATE TABLE user (uid int NOT NULL AUTO_INCREMENT, email varchar(255), username varchar(25), password varchar(32), wins int, losses int, elo int, SecretQuestionAnswer varchar(255), PRIMARY KEY (uid));
CREATE TABLE friends (fid int NOT NULL AUTO_INCREMENT, user1 varchar(25), user2 varchar(25), status BOOLEAN, PRIMARY KEY(fid));
