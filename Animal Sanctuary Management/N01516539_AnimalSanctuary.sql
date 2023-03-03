-- Aadrit Chauhan
-- N01516539


-- Creating Tables

-- 1 Employee Table 
CREATE TABLE Employees (EmployeeId INT PRIMARY KEY AUTO_INCREMENT, EmployeeName varchar(200) NOT NULL, ContactNumber int NOT NULL);

-- 2 Shift Table
CREATE TABLE Shift (ShiftId INT PRIMARY KEY AUTO_INCREMENT, EmployeeId INT, StartTime TIME NOT NULL, EndTime TIME NOT NULL, day_ofWeek varchar(20), FOREIGN KEY(EmployeeId) REFERENCES Employees(EmployeeId));

-- 3 Animal Types Table
CREATE TABLE Animal (AnimalId INT PRIMARY KEY AUTO_INCREMENT, AnimalName varchar(20) NOT NULL ,AnimalType varchar(200) NOT NULL);

-- 4 Donation Table
CREATE TABLE Donation (DonationId INT PRIMARY KEY AUTO_INCREMENT, DonationAmt Decimal(24,2) NOT NULL, AnimalId INT, FOREIGN KEY (AnimalId) REFERENCES Animal(AnimalId));

-- 5 Feeding Table
CREATE TABLE Feeding (FeedingId INT PRIMARY KEY AUTO_INCREMENT, AnimalId INT, FeedingTime TIME NOT NULL, FOREIGN KEY (AnimalId) REFERENCES Animal(AnimalId));

-- 6 Log Table
CREATE TABLE LogTable (logId INT PRIMARY KEY AUTO_INCREMENT, TableName varchar(20), TableRecordId INT, Delete_dateTime TIMESTAMP NOT NULL, EmployeeName varchar(200), ContactNumber INT, AnimalId varchar(200), DonationAmt Decimal(24,2));


-- Inserting Data into tables 


-- 1 Employee Table
INSERT INTO Employees(EmployeeName, ContactNumber) VALUES 
 ("Jesse Shera", 1234324),
("Anne Carroll", 8923432),
("Beverly Cleary", 7863450),
("Marcel Duchamp", 3276488);

-- 2 Shift Table 
INSERT INTO Shift (EmployeeId, StartTime, EndTime, day_ofWeek) VALUES 
 (1,"09:00:00", "12:00:00", "Monday"),
 (1,"15:00:00", "18:00:00", "Wednesday"),
 (1,"11:00:00", "17:00:00", "Friday"),
 (2,"06:00:00", "14:00:00", "Tuesday"),
 (2,"16:00:00", "23:00:00", "Thursday"),
 (2,"09:00:00", "17:00:00", "Saturday"),
 (3,"18:00:00", "23:00:00", "Saturday"),
 (3,"06:00:00", "14:00:00", "Sunday"),
 (4,"14:00:00", "22:00:00", "Monday"),
 (4,"15:00:00", "22:00:00", "Tuesday"),
 (4,"06:00:00", "14:00:00", "Thursday"),
 (4,"06:00:00", "11:00:00", "Friday"),
 (4,"06:00:00", "14:00:00", "Wednesday");


-- 3 Animal Type Table
INSERT INTO Animal (AnimalName, AnimalType) VALUES 
 ("Kyle", "Lion"),
("Hope", "Bird"),
("Alisha", "Chimpanze"),
("justice", "Bird"),
("Donald", "Bear"),
("Bea", "Tigress"),
("Ellis", "Lion"),
("Mike", "Hippopotamus"),
("Kelly", "Rhino"),
("Shanky", "Bear");


-- 4 Donations Table 
INSERT INTO Donation(DonationAmt, AnimalId ) VALUES 
(456.43, 1),
(20, 2),
(786.50, 3),
(100.50, 9),
(634, 5),
(78.67, 6),
(10, 4),
(634, 5),
(50, 6);

-- 5 Feeding Table
INSERT INTO Feeding(AnimalId, FeedingTime) VALUES 
(1, "11:00:00"),
(1, "18:00:00"),
(2, "11:00:00"),
(2, "18:00:00"),
(3, "09:00:00"),
(3, "15:00:00"),
(3, "20:00:00"),
(4, "11:00:00"),
(4, "19:00:00"),
(5, "11:00:00"),
(5, "19:00:00"),
(6, "09:00:00"),
(6, "17:00:00"),
(7, "09:00:00"),
(7, "18:00:00"),
(8, "20:00:00"),
(9, "10:00:00"),
(9, "21:00:00"),
(10, "08:00:00"),
(10, "16:00:00");

-- 6.1 Log Table Trigger (From Employees Table)
DELIMITER //
CREATE TRIGGER Trg_employees AFTER DELETE ON Employees
FOR EACH ROW 
BEGIN
INSERT INTO LogTable (TableName, TableRecordId, Delete_dateTime, EmployeeName, ContactNumber)
VALUES ("Employees Table", OLD.EmployeeId, NOW(), OLD.EmployeeName, OLD.ContactNumber);
END //
DELIMITER ; 


-- 6.2 Log Table Trigger (From Animal Table)
DELIMITER //
CREATE TRIGGER Trg_Animal AFTER DELETE ON Animal
FOR EACH ROW 
BEGIN
INSERT INTO LogTable (TableName, TableRecordId, Delete_dateTime)
VALUES ("Animal Table", AnimalId , NOW());
END //
DELIMITER ;


-- 6.3 Log Table Trigger (From Donation Table)
DELIMITER //
CREATE TRIGGER Trg_donation AFTER DELETE ON Donation
FOR EACH ROW 
BEGIN
INSERT INTO LogTable (TableName, TableRecordId, Delete_dateTime, AnimalId, DonationAmt)
VALUES ("Donation Table", DonationId, NOW(), AnimalId, DonationAmt);
END //
DELIMITER ;


-- Views
-- This view displays the total donation amounts for animals where donation amount is greater than 200.00.
CREATE VIEW TotalDonationAmount AS
SELECT a.AnimalName, a.AnimalType, d.AnimalId,
SUM(DonationAmt) as Total_DonationAmount
FROM Donation d
LEFT JOIN Animal a ON a.AnimalId=d.AnimalId
GROUP BY d.AnimalId, a.AnimalName, a.AnimalType
HAVING SUM(DonationAmt) > 200.00;


-- Procedure(1)  
-- This procedure displays the list of employees available on a specific week day to feed the animals. The day of week will be provided by the end user
DELIMITER //
CREATE PROCEDURE EmployeeAvailability (DayOfWeek varchar(20))
BEGIN 
SELECT e.EmployeeName, e.day_ofWeek as DayOfWeek, s.StartTime as ShiftStartTime, s.EndTime as ShiftEndTime
FROM Shift s
LEFT JOIN Employees e ON s.EmployeeId=e.EmployeeId
WHERE DATENAME(WeekDay, Getdate()) = DayOfWeek;
END //
DELIMITER ;

-- PROCEDURE (2)
-- This procedure adds a new row in the donation table if an end- user wants to make a new donation to any animal
DELIMITER //
CREATE PROCEDURE DonationAdd (DonationAmount decimal(24,2), AnimalName varchar(20))
BEGIN 
DECLARE AnimalId INT;
SELECT AnimalId = AnimalId
FROM Animal 
WHERE AnimalName = AnimalName;
INSERT INTO Donation (DonationAmt,AnimalId)
VALUES(DonationAmount, AnimalId);
END //

DELIMITER ;
















