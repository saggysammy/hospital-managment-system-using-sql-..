use hospital;
-- Problem 1: Which doctors have the most appointments?
SELECT d.DoctorID, d.FirstName, d.LastName, 
       COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName
ORDER BY TotalAppointments DESC
LIMIT 5;

-- Problem 2: What are the most common appointment reasons?

SELECT Reason, COUNT(*) AS TotalAppointments
FROM Appointments
WHERE Reason IS NOT NULL
GROUP BY Reason
ORDER BY TotalAppointments DESC
LIMIT 5;



-- Problem 3: What is the overall cancellation rate?
SELECT 
    ROUND(SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
    AS CancellationRate
FROM Appointments;

-- Problem 4: Which specialty has the highest patient satisfaction

SELECT d.Specialty, ROUND(AVG(f.Rating), 2) AS AvgRating
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Feedback f ON a.AppointmentID = f.AppointmentID
GROUP BY d.Specialty
ORDER BY AvgRating DESC
LIMIT 3;



-- Problem 5: How many new patients registered each month?
SELECT 
    YEAR(RegistrationDate) AS Year,
    MONTH(RegistrationDate) AS Month,
    COUNT(*) AS NewPatients
FROM Patients
GROUP BY YEAR(RegistrationDate), MONTH(RegistrationDate)
ORDER BY Year, Month;

-- Problem 6: Which treatment generates the most revenue?
SELECT TreatmentType, ROUND(SUM(Cost), 2) AS TotalRevenue
FROM Treatments
GROUP BY TreatmentType
ORDER BY TotalRevenue DESC
LIMIT 3;


-- Problem 7: Which doctors have the highest no-show rate?
SELECT d.DoctorID, d.FirstName, d.LastName,
       ROUND(SUM(CASE WHEN a.Status = 'No-Show' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
       AS NoShowRate
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName
HAVING NoShowRate > 0
ORDER BY NoShowRate DESC;

-- Problem 8: What is the average treatment cost by specialty?
SELECT d.Specialty, ROUND(AVG(t.Cost), 2) AS AvgTreatmentCost
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
GROUP BY d.Specialty
ORDER BY AvgTreatmentCost DESC;

-- 
-- Problem 9: What is the patient age distribution?
SELECT 
    CASE 
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 35 THEN '18-35'
        WHEN Age BETWEEN 36 AND 55 THEN '36-55'
        ELSE '55+'
    END AS AgeGroup,
    COUNT(*) AS PatientCount
FROM Patients
GROUP BY AgeGroup
ORDER BY PatientCount DESC;

-- Problem 10: What is the monthly revenue trend?
SELECT 
    YEAR(a.AppointmentDate) AS Year,
    MONTH(a.AppointmentDate) AS Month,
    ROUND(SUM(t.Cost), 2) AS MonthlyRevenue
FROM Appointments a
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
WHERE a.Status = 'Completed'
GROUP BY YEAR(a.AppointmentDate), MONTH(a.AppointmentDate)
ORDER BY Year, Month;

-- Problem 11: How many male vs. female patients are there
SELECT Gender, COUNT(*) AS PatientCount
FROM Patients
GROUP BY Gender;

-- -- Problem 12: What is the total revenue generated from each specialty?
SELECT d.Specialty, ROUND(SUM(t.Cost), 2) AS TotalRevenue
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
WHERE a.Status = 'Completed'
GROUP BY d.Specialty
ORDER BY TotalRevenue DESC;

-- Problem 13: What percentage of appointments receive feedback?
SELECT 
    ROUND((SELECT COUNT(DISTINCT AppointmentID) FROM Feedback) * 100.0 / 
    (SELECT COUNT(*) FROM Appointments), 2) AS FeedbackPercentage;
    
    -- Problem 14: What is the average treatment duration by specialty?
SELECT d.Specialty, ROUND(AVG(t.DurationMinutes), 2) AS AvgDuration
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
GROUP BY d.Specialty
ORDER BY AvgDuration DESC;

-- Problem 15: What is the distribution of appointment statuses?
SELECT Status, COUNT(*) AS Count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Appointments), 2) AS Percentage
FROM Appointments
GROUP BY Status;