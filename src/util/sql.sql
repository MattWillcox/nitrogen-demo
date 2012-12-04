-- SQL

CREATE TABLE game_history (gid int  NOT NULL AUTO_INCREMENT, user1 varchar(25), user2 varchar(25), winner varchar(25), time timestamp, PRIMARY KEY (gid));

CREATE TABLE players (pid int NOT NULL AUTO_INCREMENT, user varchar(25), password varchar(32), PRIMARY KEY (pid));

INSERT INTO players (user, password) VALUES ('noob1@test.test', 'plaintextlol');
INSERT INTO players (user, password) VALUES ('noob2@test.test', 'plaintextlol');
INSERT INTO players (user, password) VALUES ('noob3@test.test', 'plaintextlol');
INSERT INTO players (user, password) VALUES ('noob4@test.test', 'plaintextlol');
INSERT INTO players (user, password) VALUES ('noob5@test.test', 'plaintextlol');
INSERT INTO players (user, password) VALUES ('noob6@test.test', 'plaintextlol');

INSERT INTO game_history (user1, user2, winner) VALUES ('noob1', 'noob2', 'noob1');
INSERT INTO game_history (user1, user2, winner) VALUES ('noob1', 'noob3', 'noob1');
INSERT INTO game_history (user1, user2, winner) VALUES ('noob2', 'noob4', 'noob4');
INSERT INTO game_history (user1, user2, winner) VALUES ('noob2', 'noob5', 'noob2');
INSERT INTO game_history (user1, user2, winner) VALUES ('noob1', 'noob6', 'noob6');
INSERT INTO game_history (user1, user2, winner) VALUES ('noob1', 'noob5', 'noob5');
INSERT INTO game_history (user1, user2, winner) VALUES ('noob3', 'noob4', 'noob3');

ALTER TABLE players ADD SecretQuestionAnswer varchar(255);