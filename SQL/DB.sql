CREATE DATABASE clinic_db;

USE clinic_db;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(50) NOT NULL
);

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE,
    Gender VARCHAR(10),
    Phone VARCHAR(20)
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    DoctorName VARCHAR(100) NOT NULL,
    Specialty VARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Visits (
    VisitID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    VisitDate DATE NOT NULL,
    ReasonForVisit VARCHAR(100),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE Vitals (
    VitalID INT PRIMARY KEY AUTO_INCREMENT,
    VisitID INT,
    BloodPressure VARCHAR(20),
    GlucoseLevel DECIMAL(5,2),
    CholesterolLevel DECIMAL(5,2),
    Weight DECIMAL(5,2),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

CREATE TABLE Diagnoses (
    DiagnosisID INT PRIMARY KEY AUTO_INCREMENT,
    VisitID INT,
    DiagnosisName VARCHAR(100) NOT NULL,
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

CREATE TABLE Medications (
    MedicationID INT PRIMARY KEY AUTO_INCREMENT,
    VisitID INT,
    MedicationName VARCHAR(100) NOT NULL,
    Dosage VARCHAR(50),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

CREATE TABLE FollowUps (
    FollowUpID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    VisitID INT,
    FollowUpDate DATE,
    Status VARCHAR(30),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);


INSERT INTO Departments (DepartmentName)
VALUES
('Cardiology'),
('Endocrinology'),
('General Medicine');


INSERT INTO Patients (FirstName, LastName, DOB, Gender, Phone)
VALUES
('Ali', 'Zardosht', '1995-07-06', 'Male', '555-1111'),
('Sara', 'Smith', '1988-07-21', 'Female', '555-2222'),
('John', 'Miller', '1975-02-15', 'Male', '555-3333'),
('Emily', 'Davis', '1992-09-05', 'Female', '555-4444'),
('David', 'Wilson', '1968-12-30', 'Male', '555-5555');


INSERT INTO Doctors (DoctorName, Specialty, DepartmentID)
VALUES
('Dr. Brown', 'Cardiologist', 1),
('Dr. Lee', 'Endocrinologist', 2),
('Dr. Taylor', 'Physician', 3);


INSERT INTO Visits (PatientID, DoctorID, VisitDate, ReasonForVisit)
VALUES
(1, 2, '2026-04-01', 'Diabetes Checkup'),
(2, 1, '2026-04-02', 'High Blood Pressure'),
(3, 3, '2026-04-03', 'Routine Checkup'),
(4, 2, '2026-04-04', 'High Glucose'),
(5, 1, '2026-04-05', 'Chest Pain');


INSERT INTO Vitals (VisitID, BloodPressure, GlucoseLevel, CholesterolLevel, Weight)
VALUES
(1, '130/85', 145, 190, 78),
(2, '150/95', 98, 210, 82),
(3, '120/80', 92, 180, 75),
(4, '135/88', 160, 220, 68),
(5, '160/100', 105, 240, 90);


INSERT INTO Diagnoses (VisitID, DiagnosisName)
VALUES
(1, 'Diabetes'),
(2, 'Hypertension'),
(3, 'Healthy'),
(4, 'Diabetes'),
(5, 'High Cholesterol');


INSERT INTO Medications (VisitID, MedicationName, Dosage)
VALUES
(1, 'Metformin', '500 mg'),
(2, 'Lisinopril', '10 mg'),
(4, 'Metformin', '850 mg'),
(5, 'Atorvastatin', '20 mg');


INSERT INTO FollowUps (PatientID, VisitID, FollowUpDate, Status)
VALUES
(1, 1, '2026-05-01', 'Scheduled'),
(2, 2, '2026-05-03', 'Completed'),
(4, 4, '2026-05-05', 'Scheduled'),
(5, 5, '2026-05-10', 'Missed');


CREATE USER 'admin1'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'doctor1'@'localhost' IDENTIFIED BY 'doctor123';
CREATE USER 'reception1'@'localhost' IDENTIFIED BY 'recep123';


GRANT ALL PRIVILEGES ON clinic_db.* TO 'admin1'@'localhost';


GRANT SELECT, INSERT, UPDATE ON clinic_db.Patients TO 'doctor1'@'localhost';
GRANT SELECT, INSERT, UPDATE ON clinic_db.Visits TO 'doctor1'@'localhost';
GRANT SELECT, INSERT, UPDATE ON clinic_db.Vitals TO 'doctor1'@'localhost';
GRANT SELECT, INSERT, UPDATE ON clinic_db.Diagnoses TO 'doctor1'@'localhost';
GRANT SELECT, INSERT, UPDATE ON clinic_db.Medications TO 'doctor1'@'localhost';


GRANT SELECT, INSERT, UPDATE ON clinic_db.Patients TO 'reception1'@'localhost';
GRANT SELECT, INSERT, UPDATE ON clinic_db.Visits TO 'reception1'@'localhost';
GRANT SELECT, INSERT, UPDATE ON clinic_db.FollowUps TO 'reception1'@'localhost';


FLUSH PRIVILEGES;


CREATE VIEW Reception_View AS
SELECT PatientID, FirstName, LastName, Phone
FROM Patients;


CREATE VIEW Doctor_View AS
SELECT p.PatientID, p.FirstName, p.LastName,
       v.VisitDate,
       d.DiagnosisName
FROM Patients p
JOIN Visits v ON p.PatientID = v.PatientID
JOIN Diagnoses d ON v.VisitID = d.VisitID;


SELECT * FROM patients;

-- Query 2: Patients with high glucose level
SELECT p.PatientID, p.FirstName, p.LastName, v.GlucoseLevel
FROM Patients p
JOIN Visits vt ON p.PatientID = vt.PatientID
JOIN Vitals v ON vt.VisitID = v.VisitID
WHERE v.GlucoseLevel > 140;

-- Query 3: Patients with high blood pressure
SELECT p.PatientID, p.FirstName, p.LastName, v.BloodPressure
FROM Patients p
JOIN Visits vt ON p.PatientID = vt.PatientID
JOIN Vitals v ON vt.VisitID = v.VisitID
WHERE v.BloodPressure > '140/90';

-- Query 4: Most common diagnosis
SELECT DiagnosisName, COUNT(*) AS TotalCases
FROM Diagnoses
GROUP BY DiagnosisName
ORDER BY TotalCases DESC;

-- Query 5: Doctor with most visits
SELECT d.DoctorName, COUNT(v.VisitID) AS TotalVisits
FROM Doctors d
JOIN Visits v ON d.DoctorID = v.DoctorID
GROUP BY d.DoctorName
ORDER BY TotalVisits DESC;

-- Query 6: Average cholesterol level
SELECT AVG(CholesterolLevel) AS AverageCholesterol
FROM Vitals;


-- Query 7: Missed follow-up appointments
SELECT p.FirstName, p.LastName, f.FollowUpDate, f.Status
FROM Patients p
JOIN FollowUps f ON p.PatientID = f.PatientID
WHERE f.Status = 'Missed';

use clinic_db;

SELECT 
    p.PatientID,
    p.FirstName,
    p.LastName,
    p.Gender,
    d.DoctorName,
    dep.DepartmentName,
    v.VisitDate,
    diag.DiagnosisName,
    vt.BloodPressure,
    vt.GlucoseLevel,
    vt.CholesterolLevel,
    vt.Weight,
    m.MedicationName,
    f.Status AS FollowUpStatus
FROM Patients p
JOIN Visits v ON p.PatientID = v.PatientID
JOIN Doctors d ON v.DoctorID = d.DoctorID
JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
JOIN Vitals vt ON v.VisitID = vt.VisitID
JOIN Diagnoses diag ON v.VisitID = diag.VisitID
LEFT JOIN Medications m ON v.VisitID = m.VisitID
LEFT JOIN FollowUps f ON v.VisitID = f.VisitID;


