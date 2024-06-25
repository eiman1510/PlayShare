CREATE DATABASE Final
USE Final
CREATE TABLE Sports (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE,
    capacity INT
);


CREATE TABLE Team (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE,
    sportstype INT,
    rating decimal(4,2),
    check(rating>=1 and rating<=5),
    FOREIGN KEY (sportstype) REFERENCES Sports(ID)
);

CREATE TABLE Player (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    username VARCHAR(50) UNIQUE,
    password VARCHAR(50),
    email VARCHAR(50),
    contactnumber VARCHAR(11) UNIQUE,
    gender CHAR CHECK(gender='F' OR gender='M'),
    sportstype INT,
    AssociatedTeam INT,
    FOREIGN KEY (sportstype) REFERENCES Sports(ID),
    FOREIGN KEY (AssociatedTeam) REFERENCES Team(ID)
);

CREATE TABLE captains (
    teamid INT,
    playerid INT,
    PRIMARY KEY (teamid, playerid),
    FOREIGN KEY (teamid) REFERENCES Team(ID),
    FOREIGN KEY (playerid) REFERENCES Player(ID)
);
create table torregistration(
	torid int ,
    teamid int,
    foreign key(torid) references tournament(ID),
    foreign key(teamid) references team(ID),
    primary key(torid,teamid)
);
CREATE TABLE MatchType (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE Field (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    location VARCHAR(50),
    sportsoffering INT,
    FOREIGN KEY (sportsoffering) REFERENCES Sports(ID)
);
Alter table Field
add ownername varchar(50) after ID;
Alter table Field
add ownermail varchar(50) after ownername;
Alter table Field
MODIFY name varchar(50) unique;
Alter table Field
add PhoneNumber varchar(11)
select* from Field;

CREATE TABLE Tournament (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE,
    field INT,
    noofmatches INT,
    duration INT,
    startingDate DATE,
    sports INT,
    entry_fee INT,
    FOREIGN KEY (field) REFERENCES Field(ID),
    FOREIGN KEY(sports) REFERENCES Sports(ID)
);
alter table Tournament
add PlayerID INT,
add constraint xyz foreign key(PlayerID) references Player(ID);
select* from Tournament;
select* from torregistration;
select* from matches
insert into torregistration(torid,teamid)
values (1,1),
(1,2);
update Tournament
set PlayerID=1
where ID=1 or ID=2;
CREATE TABLE Matches (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    matchtype INT,
    TimeOfMatch TIME,
    DateofMatch DATE,
    Team1 INT,
    Team2 INT,
    field INT,
    CHECK (Team1 != Team2),
    UNIQUE (field, TimeOfMatch, DateOfMatch),
    FOREIGN KEY (matchtype) REFERENCES MatchType(ID),
    FOREIGN KEY (Team1) REFERENCES Team(ID),
    FOREIGN KEY (Team2) REFERENCES Team(ID),
    FOREIGN KEY (field) REFERENCES Field(ID)
);

CREATE TABLE TournamentMatch (
    MatchId INT,
    TournamentId INT,
    PRIMARY KEY (MatchId, TournamentId),
    FOREIGN KEY (MatchId) REFERENCES Matches(ID),
    FOREIGN KEY (TournamentId) REFERENCES Tournament(ID)
);

CREATE TABLE Payment (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    DateofPayment DATE,
    amount INT,
    BankTo VARCHAR(50),
    BankFrom VARCHAR(50),
    PlayerID INT,
    field INT,
    FOREIGN KEY (PlayerID) REFERENCES Player(ID),
    FOREIGN KEY (field) REFERENCES Field(ID)
);

CREATE TABLE feed (
    Links VARCHAR(255) UNIQUE,
    sportstype INT,
    Title VARCHAR(50),
    FOREIGN KEY (sportstype) REFERENCES Sports(ID)
);

CREATE TABLE rewards (
    nofofmatches INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO Sports (name, capacity) VALUES
('Football', 15),
('Cricket', 15),
('Tennis', 2),
('Basketball', 15);

INSERT INTO Team (name, sportstype, rating)
VALUES
('TeamA', 1, 1),
('TeamB', 2, 1),
('TeamC', 3, 2),
('TeamD', 4, 2),
('TeamE', 1, 3),
('TeamF', 2, 3),
('TeamG', 3, 4),
('TeamH', 4, 4),
('TeamI', 1, 5),
('TeamJ', 2, 5),
('TeamK', 3, 1),
('TeamL', 4, 1),
('TeamM', 1, 1),
('TeamN', 2, 2),
('TeamO', 3, 2),
('TeamP', 4, 2),
('TeamQ', 1, 3),
('TeamR', 2, 3),
('TeamS', 3, 4),
('TeamT', 4, 5);

INSERT INTO Player (name, username, password, email, contactnumber, gender, sportstype, AssociatedTeam)
VALUES
('John Doe', 'john_doe', 'password123', 'john@example.com', '033431517', 'M', 1, 1),
('Alice Smith', 'alice_smith', 'secret456', 'alice@example.com', '03349931607', 'F', 2, 2),
('Michael Johnson', 'mike_j', 'pass1234', 'mike@example.com', '03349931697', 'M', 1, 1),
('Emily Brown', 'em_brown', 'abc123', 'emily@example.com', '03349931687', 'F', 3, 3),
('James Wilson', 'jw_92', 'qwerty', 'james@example.com', '03349931677', 'M', 2, 2),
('Sophia Lee', 'sophia_lee', 'passpass', 'sophia@example.com', '03349931667', 'F', 4, 4),
('Robert Garcia', 'rob_g', 'password', 'rob@example.com', '03349931657', 'M', 3, 3),
('Emma Johnson', 'emma_j', 'ilovecats', 'emma@example.com', '03349931647', 'F', 1, 1),
('Daniel Brown', 'danny_b', 'danny123', 'daniel@example.com', '03349931637', 'M', 2, 2),
('Olivia White', 'olivia_w', 'letmein', 'olivia@example.com', '0334931627', 'F', 3, 3),
('William Davis', 'will_d', 'passpass', 'will@example.com', '03349931617', 'M', 4, 4),
('Ava Martinez', 'ava_m', 'martinez', 'ava@example.com', '0334993116', 'F', 1, 1),
('Alexander Taylor', 'alex_t', 'password', 'alex@example.com', '049931615', 'M', 2, 2),
('Mia Rodriguez', 'mia_r', 'hello123', 'mia@example.com', '033931614', 'F', 3, 3),
('Ethan Hernandez', 'ethan_h', 'password', 'ethan@example.com', '3349931613', 'M', 4, 4),
('Charlotte Nguyen', 'charlotte_n', 'qwerty', 'charlotte@example.com', '0334931612', 'F', 1, 1),
('Benjamin Gonzalez', 'ben_g', 'ilovecats', 'benjamin@example.com', '033491611', 'M', 2, 2),
('Amelia King', 'amelia_k', 'king123', 'amelia@example.com', '0334993161', 'F', 3, 3),
('Henry Perez', 'henry_p', 'letmein', 'henry@example.com', '0334993169', 'M', 4, 4),
('Sofia Flores', 'sofia_f', 'password', 'sofia@example.com', '033491618', 'F', 1, 1);

INSERT INTO captains (teamid, playerid) VALUES
(1, 1),  -- Captain of TeamA
(2, 2),  -- Captain of TeamB
(3, 3),  -- Captain of TeamC
(4, 4),  -- Captain of TeamD
(5, 5),  -- Captain of TeamE
(6, 6),  -- Captain of TeamF
(7, 7),  -- Captain of TeamG
(8, 8),  -- Captain of TeamH
(9, 9),  -- Captain of TeamI
(10, 10);-- Captain of TeamJ

INSERT INTO Field (name, location, sportsoffering)
VALUES
('FieldA', 'LocationA', 1),
('FieldB', 'LocationB', 2),
('FieldC', 'LocationC', 3),
('FieldD', 'LocationD', 4),
('FieldE', 'LocationE', 1),
('FieldF', 'LocationF', 2),
('FieldG', 'LocationG', 3),
('FieldH', 'LocationH', 4),
('FieldI', 'LocationI', 1),
('FieldJ', 'LocationJ', 2),
('FieldK', 'LocationK', 3),
('FieldL', 'LocationL', 4),
('FieldM', 'LocationM', 1),
('FieldN', 'LocationN', 2),
('FieldO', 'LocationO', 3),
('FieldP', 'LocationP', 4),
('FieldQ', 'LocationQ', 1),
('FieldR', 'LocationR', 2),
('FieldS', 'LocationS', 3),
('FieldT', 'LocationT', 4);

INSERT INTO MatchType (name)
VALUES
('Regular Match'),
('Tournament Match');

INSERT INTO Matches ( matchtype, TimeOfMatch, DateofMatch, Team1, Team2, field)
VALUES
( 1, '18:00:00', '2024-05-10', 1, 2, 1),
( 2, '15:30:00', '2024-05-11', 3, 4, 2),
(1, '14:00:00', '2024-05-12', 5, 6, 3),
( 2, '17:45:00', '2024-05-13', 7, 8, 4),
( 1, '20:00:00', '2024-05-14', 9, 10, 5),
( 2, '13:15:00', '2024-05-15', 11, 12, 6),
( 1, '16:30:00', '2024-05-16', 13, 14, 7),
( 2, '19:45:00', '2024-05-17', 15, 16, 8),
( 1, '11:00:00', '2024-05-18', 17, 18, 9),
( 2, '14:45:00', '2024-05-19', 19, 20, 10),
( 1, '17:00:00', '2024-05-20', 1, 3, 11),
( 2, '12:30:00', '2024-05-21', 2, 4, 12),
( 1, '15:45:00', '2024-05-22', 5, 7, 13),
( 2, '18:15:00', '2024-05-23', 6, 8, 14),
( 1, '20:30:00', '2024-05-24', 9, 11, 15),
( 2, '11:45:00', '2024-05-25', 10, 12, 16),
( 1, '14:15:00', '2024-05-26', 13, 15, 17),
( 2, '17:30:00', '2024-05-27', 14, 16, 18),
( 1, '19:00:00', '2024-05-28', 17, 19, 19),
( 2, '13:00:00', '2024-05-29', 18, 20, 20);

INSERT INTO Tournament (name, field, noofmatches, duration, startingDate, sports,entry_fee )
VALUES
('Tournament1', 1, 5, 7, '2024-06-01',1,1000),
('Tournament2', 2, 6, 8, '2024-06-05',1,1000),
('Tournament3', 3, 7, 9, '2024-06-10',1,1000),
('Tournament4', 4, 8, 10, '2024-06-15',1,1000),
('Tournament5', 5, 9, 11, '2024-06-20',1,1000),
('Tournament6', 6, 10, 12, '2024-06-25',1,1000),
('Tournament7', 7, 11, 13, '2024-07-01',1,1000),
('Tournament8', 8, 12, 14, '2024-07-05',1,1000),
('Tournament9', 9, 13, 15, '2024-07-10',1,1000),
('Tournament10', 10, 14, 16, '2024-07-15',1,1000);

INSERT INTO Payment ( DateofPayment, amount, BankTo, BankFrom, PlayerID, field)
VALUES
( '2024-06-01', 100, 'Bank1', 'Bank2', 1, 1),
( '2024-06-02', 150, 'Bank2', 'Bank3', 2, 2),
( '2024-06-03', 200, 'Bank3', 'Bank4', 3, 3),
( '2024-06-04', 250, 'Bank4', 'Bank5', 4, 4),
( '2024-06-05', 300, 'Bank5', 'Bank6', 5, 5),
( '2024-06-06', 350, 'Bank6', 'Bank7', 6, 6),
( '2024-06-07', 400, 'Bank7', 'Bank8', 7, 7),
( '2024-06-08', 450, 'Bank8', 'Bank9', 8, 8),
( '2024-06-09', 500, 'Bank9', 'Bank10', 9, 9),
('2024-06-10', 550, 'Bank10', 'Bank11', 10, 10),
('2024-06-11', 600, 'Bank11', 'Bank12', 11, 11),
('2024-06-12', 650, 'Bank12', 'Bank13', 12, 12),
( '2024-06-13', 700, 'Bank13', 'Bank14', 13, 13),
( '2024-06-14', 750, 'Bank14', 'Bank15', 14, 14),
( '2024-06-15', 800, 'Bank15', 'Bank16', 15, 15),
( '2024-06-16', 850, 'Bank16', 'Bank17', 16, 16),
( '2024-06-17', 900, 'Bank17', 'Bank18', 17, 17),
( '2024-06-18', 950, 'Bank18', 'Bank19', 18, 18),
( '2024-06-19', 1000, 'Bank19', 'Bank20', 19, 19),
( '2024-06-20', 1050, 'Bank20', 'Bank21', 20, 20);

INSERT INTO rewards (nofofmatches, name)
VALUES
(10,'Noob'),
(50,'Half-Century'),
(100,'Century');

SELECT * FROM Sports;
SELECT * FROM Team;
SELECT * FROM Player;
SELECT * FROM Field;
SELECT * FROM captains;
SELECT * FROM Matches;
SELECT * FROM Tournament;
SELECT * FROM feed;
SELECT * FROM MatchType;
SELECT * FROM rewards;
-- Procedures:
DELIMITER //
CREATE PROCEDURE UserSignup(
    IN name VARCHAR(50),
    IN user VARCHAR(50),
    IN pass VARCHAR(50),
    IN sp INT,
    IN phone VARCHAR(50),
    IN em VARCHAR(50),
    IN gr CHAR,
    OUT Flag INT
)
BEGIN
    DECLARE username_count INT;
    DECLARE email_count INT;
    DECLARE phone_count INT;

    SELECT COUNT(*) INTO username_count FROM Player WHERE username = user;

    IF (username_count > 0) THEN
        -- Username already taken
        SET Flag = 1;
    ELSE
        SELECT COUNT(*) INTO email_count FROM Player WHERE email = em;

        IF (email_count > 0) THEN
            -- Gmail already taken
            SET Flag = 2;
        ELSE
            SELECT COUNT(*) INTO phone_count FROM Player WHERE contactnumber = phone;

            IF (phone_count > 0) THEN
                -- User with this contact already exists
                SET Flag = 3;
            ELSE
                SET Flag = 0;
                
            END IF;
        END IF;
    END IF;
    IF (Flag=0) THEN
		INSERT INTO Player(name,username,password,email,contactnumber,gender,sportstype)
        VALUES(name,user,pass,em,phone,gr,sp);
        END IF;
END//

DELIMITER ;
DELIMITER //

CREATE PROCEDURE UserLogin(
    IN user VARCHAR(50),
    IN pass VARCHAR(50),
    OUT Flag INT
)
BEGIN
    DECLARE P INT;
    DECLARE PA INT;
    
    SELECT COUNT(*) INTO P FROM Player WHERE username = user;

    IF (P > 0) THEN
		 SELECT COUNT(*) INTO PA FROM Player WHERE username = user and password=pass;
         if(PA>0) THEN
			SET FLAG=0; 
		 ELSE
			SET FLAG=1;
          END IF;
     ELSE
        SET FLAG=2;
        END IF;
END//

DELIMITER ;
DELIMITER //

CREATE PROCEDURE inserttournament(
    IN p_name VARCHAR(50),
    IN p_fieldname VARCHAR(50),
    IN p_noofteams INT,
    IN p_duration INT,
    IN p_sd DATE,
    IN spo INT,
    IN ent INT,
    IN userid INT,
    IN p_teamid INT,
    OUT flag INT
)
BEGIN
    DECLARE v_id INT;
    DECLARE v_f INT;
	DECLARE exi INT;
    -- Initialize flag to 1
    SET flag = 1;
	SELECT count(*) into exi from captains where teamid=p_teamid and playerid=userid;
    if(p_sd<current_date()) then 
    set flag=3;
    end if;
    if(exi=0 and flag=1) then
     SET flag=2;
     end if;
    -- Check if the tournament name already exists
    SELECT ID INTO v_f FROM Tournament WHERE name = p_name;

    -- If tournament name already exists, set flag to 0
    IF v_f IS NOT NULL THEN
        SET flag = 0;
    END IF;
	
    -- If flag is 1 (i.e., tournament name doesn't exist), proceed with insertion
    IF flag = 1 THEN
        -- Get the ID of the field
        SELECT ID INTO v_id FROM Field WHERE name = p_fieldname;

        -- Insert into Tournament table
        INSERT INTO Tournament (name, field, noofmatches, duration, startingDate,sports,entry_fee)
        VALUES (p_name, v_id, p_noofteams, p_duration, p_sd,spo,ent,userid);
    END IF;

END //

DELIMITER ;
DELIMITER //
create procedure Checktournament
(
IN p_toname varchar(50),
IN userid int,
IN p_teamid int,
out flag int
)
Begin
	declare p_torid int;
	Declare coun int;
    Declare c int;
    Declare exi int;
    set flag=1;
    select ID into p_torid from tournament where name = p_toname;
    SELECT count(*) into coun from torregistration where torid=p_torid;
    SELECT noofmatches into c from tournament  where ID=p_torid;
    SELECT count(*) into exi from captains where teamid=p_teamid and playerid=userid;
    if(exi=0) then 
		set flag=2;
	end if;
    if(c=coun and flag=1) then 
		set flag=0;
	end if;
END //
DELIMITER ;	
DELIMITER //

CREATE PROCEDURE pamin(
    IN p_date DATE,
    IN amount INT,
    IN to_bank VARCHAR(50),
    IN from_bank VARCHAR(50),
    IN pid INT,
    IN fid INT
)
BEGIN
    INSERT INTO Payment ( DateofPayment, amount, BankTo, BankFrom, PlayerID, field)
    VALUES ( p_date, amount, to_bank, from_bank, pid, fid);
END//

DELIMITER ;
DELIMITER //
CREATE PROCEDURE insertteam(
IN nam VARCHAR(50),
IN PID INT,
OUT flag INT
)
BEGIN
DECLARE S INT;
DECLARE t INT;
-- Check if the team already exists
IF EXISTS (SELECT 1 FROM team WHERE name = nam) THEN
SET flag = 2; -- Team already exists
ELSE
-- Get the sportstype from the Player table
SELECT sportstype INTO S FROM Player WHERE ID = PID;
-- Insert new team into the team table
INSERT INTO team (name, sportstype, rating) VALUES (nam, S, 1);
-- Get the ID of the newly inserted team
SELECT ID INTO t FROM team WHERE name = nam;
-- Insert into captains table
INSERT INTO captains (teamid, playerid) VALUES (t, PID);
-- Update the Player table with the associated team
UPDATE Player SET Associatedteam = t WHERE ID = PID;
-- Indicate success
SET flag = 1;
END IF;
END//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE insertField(
    IN f_fieldname VARCHAR(50),
    IN f_ownername VARCHAR(50),
    IN f_mail VARCHAR(50),
    IN f_location varchar(50),
    IN phone VARCHAR(50),
    IN f_sports int,
    OUT Flag INT
)
BEGIN
    DECLARE username_count INT;

    SELECT COUNT(*) INTO username_count FROM Field WHERE name = f_fieldname;
	set Flag=1;
    IF (username_count > 0) THEN
        -- Username already taken
        SET Flag = 0;
	END IF;
    IF (Flag=1) THEN
		INSERT INTO Field(ownername,ownermail,name,location,sportsoffering,PhoneNumber)
        VALUES(f_ownername,f_mail,f_fieldname,f_location,f_sports,phone);
        END IF;
END//

DELIMITER ;
DELIMITER //

CREATE PROCEDURE insertTourMatch(
    IN matcht int,
    IN timeofm TIME,
    IN dateofm DATE,
    IN T1name VARCHAR(50),
    IN T2name VARCHAR(50),
    IN fid INT,
    IN p_torid INT,
    OUT flag INT
)
BEGIN
    
    DECLARE T1id INT;
    DECLARE T2id INT;
    declare matid int;
    set flag=1;
    IF T1name IS NULL THEN
        SET T1id = NULL;
    ELSE
        SELECT ID INTO T1id FROM Team WHERE name = T1name;
    END IF;

    IF T2name IS NULL THEN
        SET T2id = NULL;
    ELSE
        SELECT ID INTO T2id FROM Team WHERE name = T2name;
    END IF;
    if(T1id=T2id) then
    set flag=0;
    end if;
    if(dateofm<current_date()) then
    set flag=2;
    end if;
    if(flag=1) then
    INSERT INTO Matches (matchtype, TimeOfmatch, DateofMatch, Team1, Team2, field) 
    VALUES (matcht, timeofm, dateofm, T1id, T2id, fid);
    end if;
    if (matcht=2 and flag=1) 
    then
    select ID into matid from matches as m where m.DateofMatch = dateofm and field = fid and m.TimeofMatch = timeofm;
    INSERT into tournamentmatch(MatchId, TournamentId)
    Values (matid, p_torid);
	end if;


END //


DELIMITER ;
DELIMITER //

CREATE PROCEDURE findmatch(
    IN fieldname VARCHAR(50),
    IN timeofmat TIME,
    IN userid INT,
    IN p_teamid INT,
    IN sd DATE,
    OUT flag INT
)
BEGIN
    DECLARE test INT;
	DECLARE t INT;
    DECLARE exi INT;
    SET flag=1;
    SELECT ID INTO test FROM Field WHERE name = fieldname;
	SELECT 	count(*) INTO t FROM matches WHERE TimeOfMatch=timeofmat and field=test and DateofMatch=sd;
    SELECT count(*) into exi from captains where teamid=p_teamid and playerid=userid;
    if(sd<current_date()) then 
    set flag=3;
    end if;
    if(exi=0 and flag=1) then
     SET flag=2;
     end if;
    If(t!=0 and flag=1) then
		SET flag=0;
	END IF;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE insertMatch(
    IN timeofm TIME,
    IN dateofm DATE,
    IN T1ID VARCHAR(50),
    IN fieldname VARCHAR(50)
)
BEGIN
    DECLARE fid INT;
    SELECT ID INTO fid FROM Field WHERE name = fieldname;
    INSERT INTO Matches (matchtype, TimeOfmatch, DateofMatch, Team1, Team2, field) 
    VALUES (1, timeofm, dateofm, T1ID, NULL, fid);
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE addteam
(IN nam varchar(50),
IN PID INT,
OUT flag INT)
BEGIN
Declare S int;
Declare c int;
Declare t int;
Declare l int;
set flag=0;
select sportstype into S from Player where ID=PID;
select  capacity into l from sports where ID=S;
select ID into t from team where name=nam;
select count(*) into c from Player group by AssociatedTeam having AssociatedTeam=t  ;
IF c < l THEN
        UPDATE Player
        SET AssociatedTeam = t
        WHERE ID = PID;
        SET flag = 1;
    ELSE
        SET flag = 3;
    END IF;

END//
DELIMITER ;