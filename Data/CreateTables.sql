/*
CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra
FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;
*/
if object_id('WeeklyPredictionResults') is not null
    drop table WeeklyPredictionResults;

if object_id('Game') is not null
    drop table Game;

if object_id('AppUserTeam') is not null
    drop table AppUserTeam;

if object_id('Team') is not null
    drop table Team;

if object_id('Stadium') is not null
    drop table Stadium;

if object_id('AppUser') is not null
    drop table AppUser;

go

create table Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(100) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeOfField VARCHAR(50) NOT NULL,
    constraint PK_Stadium PRIMARY KEY (StadiumID),
    constraint UQ_Stadium UNIQUE (StadiumName, StadiumCity, StadiumState),
    constraint CK_TypeOfField CHECK (TypeOfField IN ('Grass', 'Artificial Turf'))
);

go

create table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID),
    constraint UQ_UniversityName UNIQUE (UniversityName),
    constraint FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

go


CREATE table Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate Date NOT NULL,
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Game PRIMARY KEY (GameID),
    constraint UQ_Game UNIQUE (HomeTeamID, GameDate, GameTime),
    constraint FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

go

CREATE TABLE AppUser (
    AppUserID INT NOT NULL IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    AppUserEmail VARCHAR(50) NOT NULL,
    AppUserPassword VARCHAR(50) NOT NULL,
    CONSTRAINT PK_AppUser PRIMARY KEY (AppUserID),
    CONSTRAINT UQ_AppUser UNIQUE (AppUserEmail)
);

go

create table AppUserTeam (
    AppUserTeamID INT NOT NULL IDENTITY(1,1),
    TeamID INT NOT NULL,
    AppUserID INT NOT NULL,
    constraint PK_AppUserTeam Primary Key (AppUserTeamID),
    constraint UQ_AppUserTeam UNIQUE (TeamID, AppUserID),
    constraint FK_AppUserTeam_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    constraint FK_AppUserTeam_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID)
);

go

CREATE table WeeklyPredictionResults (
    WeeklyPredictionResultsID INT NOT NULL IDENTITY(1,1),
    StartDate DATE NOT NULL default GETDATE(),
    NumberOfCorrectPredictions INT NOT NULL default 0,
    AppUserID INT NOT NULL,
    constraint PK_WeeklyPredictionResults PRIMARY KEY (WeeklyPredictionResultsID), 
    constraint FK_WeeklyPredictionResults_AppUser FOREIGN KEY (AppUserID) REFERENCES AppUser(AppUserID),
);