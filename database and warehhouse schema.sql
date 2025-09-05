/******* Create a db LondonBikeJourney**************/
CREATE TABLE Stations (
    StationID INT PRIMARY KEY,
    StationName VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    CONSTRAINT UK_StationName UNIQUE (StationName)
);

CREATE TABLE Bikes (
    BikeID INT PRIMARY KEY,
    BikeModel VARCHAR(50) NOT NULL CHECK (BikeModel IN ('CLASSIC', 'PBSC_EBIKE')),
    Status VARCHAR(20) DEFAULT 'Available' CHECK (Status IN ('Available', 'In Use', 'Maintenance'))
);

CREATE TABLE Journeys (
    JourneyID INT PRIMARY KEY,
    StartDateTime DATETIME NOT NULL,
    EndDateTime DATETIME NOT NULL,
    StartStationID INT NOT NULL,
    EndStationID INT NOT NULL,
    BikeID INT NOT NULL,
    TotalDurationMS BIGINT NOT NULL,
    CONSTRAINT FK_Journey_StartStation FOREIGN KEY (StartStationID) REFERENCES Stations(StationID),
    CONSTRAINT FK_Journey_EndStation FOREIGN KEY (EndStationID) REFERENCES Stations(StationID),
    CONSTRAINT FK_Journey_Bike FOREIGN KEY (BikeID) REFERENCES Bikes(BikeID),
    CONSTRAINT CHK_EndDateTime CHECK (EndDateTime >= StartDateTime),
    CONSTRAINT CHK_TotalDurationMS CHECK (TotalDurationMS >= 0)
);

CREATE INDEX IDX_Journey_StartDateTime ON Journeys(StartDateTime);
CREATE INDEX IDX_Journey_BikeID ON Journeys(BikeID);

/***** Dataware house schema*******************/

/******* Create a db LondonBikeJourneyDW **************/

CREATE TABLE DateDim (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Day INT NOT NULL,
    DayOfWeek VARCHAR(10) NOT NULL,
    Hour INT NOT NULL,
    IsWeekend BIT NOT NULL
);

CREATE TABLE StationDim (
    StationKey INT PRIMARY KEY IDENTITY(1,1),
    StationID INT NOT NULL,
    StationName VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    CONSTRAINT UK_StationDim_StationID UNIQUE (StationID)
);

CREATE TABLE BikeDim (
    BikeKey INT PRIMARY KEY IDENTITY(1,1),
    BikeID INT NOT NULL,
    BikeModel VARCHAR(50) NOT NULL,
    CONSTRAINT UK_BikeDim_BikeID UNIQUE (BikeID)
);

CREATE TABLE JourneyFacts (
    JourneyFactID BIGINT PRIMARY KEY IDENTITY(1,1),
    StartDateKey INT NOT NULL,
    EndDateKey INT NOT NULL,
    StartStationKey INT NOT NULL,
    EndStationKey INT NOT NULL,
    BikeKey INT NOT NULL,
    JourneyCount INT NOT NULL DEFAULT 1,
    TotalDurationMS BIGINT NOT NULL,
    CONSTRAINT FK_JourneyFacts_StartDate FOREIGN KEY (StartDateKey) REFERENCES DateDim(DateKey),
    CONSTRAINT FK_JourneyFacts_EndDate FOREIGN KEY (EndDateKey) REFERENCES DateDim(DateKey),
    CONSTRAINT FK_JourneyFacts_StartStation FOREIGN KEY (StartStationKey) REFERENCES StationDim(StationKey),
    CONSTRAINT FK_JourneyFacts_EndStation FOREIGN KEY (EndStationKey) REFERENCES StationDim(StationKey),
    CONSTRAINT FK_JourneyFacts_Bike FOREIGN KEY (BikeKey) REFERENCES BikeDim(BikeKey)
);

CREATE INDEX IDX_JourneyFacts_StartDateKey ON JourneyFacts(StartDateKey);
CREATE INDEX IDX_JourneyFacts_StartStationKey ON JourneyFacts(StartStationKey);