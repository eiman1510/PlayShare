CREATE DATABASE Playshare
USE Playshare
CREATE TABLE Sports (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE,
    capacity INT
);


CREATE TABLE Team (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE,
    sportstype INT,
    rating INT,
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

CREATE TABLE Matches (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
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
    name VARCHAR(50),
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
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Links VARCHAR(50) UNIQUE,
    sportstype INT,
    Title VARCHAR(50),
    pic BLOB,
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
('TeamA', 1, 80),
('TeamB', 2, 75),
('TeamC', 3, 85),
('TeamD', 4, 70),
('TeamE', 1, 78),
('TeamF', 2, 82),
('TeamG', 3, 79),
('TeamH', 4, 88),
('TeamI', 1, 77),
('TeamJ', 2, 81),
('TeamK', 3, 83),
('TeamL', 4, 76),
('TeamM', 1, 84),
('TeamN', 2, 74),
('TeamO', 3, 87),
('TeamP', 4, 73),
('TeamQ', 1, 86),
('TeamR', 2, 72),
('TeamS', 3, 89),
('TeamT', 4, 71);

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

INSERT INTO Matches (name, matchtype, TimeOfMatch, DateofMatch, Team1, Team2, field)
VALUES
('Match1', 1, '18:00:00', '2024-05-10', 1, 2, 1),
('Match2', 2, '15:30:00', '2024-05-11', 3, 4, 2),
('Match3', 1, '14:00:00', '2024-05-12', 5, 6, 3),
('Match4', 2, '17:45:00', '2024-05-13', 7, 8, 4),
('Match5', 1, '20:00:00', '2024-05-14', 9, 10, 5),
('Match6', 2, '13:15:00', '2024-05-15', 11, 12, 6),
('Match7', 1, '16:30:00', '2024-05-16', 13, 14, 7),
('Match8', 2, '19:45:00', '2024-05-17', 15, 16, 8),
('Match9', 1, '11:00:00', '2024-05-18', 17, 18, 9),
('Match10', 2, '14:45:00', '2024-05-19', 19, 20, 10),
('Match11', 1, '17:00:00', '2024-05-20', 1, 3, 11),
('Match12', 2, '12:30:00', '2024-05-21', 2, 4, 12),
('Match13', 1, '15:45:00', '2024-05-22', 5, 7, 13),
('Match14', 2, '18:15:00', '2024-05-23', 6, 8, 14),
('Match15', 1, '20:30:00', '2024-05-24', 9, 11, 15),
('Match16', 2, '11:45:00', '2024-05-25', 10, 12, 16),
('Match17', 1, '14:15:00', '2024-05-26', 13, 15, 17),
('Match18', 2, '17:30:00', '2024-05-27', 14, 16, 18),
('Match19', 1, '19:00:00', '2024-05-28', 17, 19, 19),
('Match20', 2, '13:00:00', '2024-05-29', 18, 20, 20);

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

INSERT INTO Payment (name, DateofPayment, amount, BankTo, BankFrom, PlayerID, field)
VALUES
('Payment1', '2024-06-01', 100, 'Bank1', 'Bank2', 1, 1),
('Payment2', '2024-06-02', 150, 'Bank2', 'Bank3', 2, 2),
('Payment3', '2024-06-03', 200, 'Bank3', 'Bank4', 3, 3),
('Payment4', '2024-06-04', 250, 'Bank4', 'Bank5', 4, 4),
('Payment5', '2024-06-05', 300, 'Bank5', 'Bank6', 5, 5),
('Payment6', '2024-06-06', 350, 'Bank6', 'Bank7', 6, 6),
('Payment7', '2024-06-07', 400, 'Bank7', 'Bank8', 7, 7),
('Payment8', '2024-06-08', 450, 'Bank8', 'Bank9', 8, 8),
('Payment9', '2024-06-09', 500, 'Bank9', 'Bank10', 9, 9),
('Payment10', '2024-06-10', 550, 'Bank10', 'Bank11', 10, 10),
('Payment11', '2024-06-11', 600, 'Bank11', 'Bank12', 11, 11),
('Payment12', '2024-06-12', 650, 'Bank12', 'Bank13', 12, 12),
('Payment13', '2024-06-13', 700, 'Bank13', 'Bank14', 13, 13),
('Payment14', '2024-06-14', 750, 'Bank14', 'Bank15', 14, 14),
('Payment15', '2024-06-15', 800, 'Bank15', 'Bank16', 15, 15),
('Payment16', '2024-06-16', 850, 'Bank16', 'Bank17', 16, 16),
('Payment17', '2024-06-17', 900, 'Bank17', 'Bank18', 17, 17),
('Payment18', '2024-06-18', 950, 'Bank18', 'Bank19', 18, 18),
('Payment19', '2024-06-19', 1000, 'Bank19', 'Bank20', 19, 19),
('Payment20', '2024-06-20', 1050, 'Bank20', 'Bank21', 20, 20);

INSERT INTO feed (Links, sportstype, Title)
VALUES
('link1', 1, 'Title 1'),
('link2', 2, 'Title 2'),
('link3', 3, 'Title 3'),
('link4', 4, 'Title 4'),
('link5', 1, 'Title 5'),
('link6', 2, 'Title 6'),
('link7', 3, 'Title 7'),
('link8', 4, 'Title 8'),
('link9', 1, 'Title 9'),
('link10', 2, 'Title 10'),
('link11', 3, 'Title 11'),
('link12', 4, 'Title 12'),
('link13', 1, 'Title 13'),
('link14', 2, 'Title 14'),
('link15', 3, 'Title 15'),
('link16', 4, 'Title 16'),
('link17', 1, 'Title 17'),
('link18', 2, 'Title 18'),
('link19', 3, 'Title 19'),
('link20', 4, 'Title 20');

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
DELIMITER //

CREATE PROCEDURE inserttournament(
    IN name VARCHAR(50),
    IN fieldname VARCHAR(50),
    IN noofteams INT,
    IN duration INT,
    IN sd DATE,
    IN sports INT,
    IN entry_fee INT
)
BEGIN
    DECLARE idnn INT;
    SELECT  ID INTO idnn  FROM Field WHERE name =fieldname ;
    INSERT INTO Tournament (name, field, noofmatches, duration, startingDate,sports,entry_fee)
    VALUES (name, idnn, noofteams, duration, sd,sports,entry_fee);
END //

DELIMITER ;
CALL inserttournament("112901","FieldT",3,3,"2025-06-14",1,23);
select* from Tournament;

SELECT ID  FROM Field as f WHERE f.name ="FieldT" ;

drop procedure inserttournament