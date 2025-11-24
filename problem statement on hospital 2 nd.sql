use hospital;
-- Problem 11: How many male vs. female patients are there
SELECT Gender, COUNT(*) AS PatientCount
FROM Patients
GROUP BY Gender;

-- Problem 12: Which appointment reason has the highest cancellation rate
SELECT Reason, 
       COUNT(*) AS TotalAppointments,
       SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
       ROUND(SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS CancelRate
FROM Appointments
WHERE Reason IS NOT NULL
GROUP BY Reason
HAVING Cancelled > 0
ORDER BY CancelRate DESC;

-- Problem 13: What is the average rating for each doctor?
SELECT d.DoctorID, d.FirstName, d.LastName, d.Specialty,
       ROUND(AVG(f.Rating), 2) AS AvgRating,
       COUNT(f.FeedbackID) AS TotalRatings
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Feedback f ON a.AppointmentID = f.AppointmentID
GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Specialty
ORDER BY AvgRating DESC;

-- Problem 14: What is the total revenue generated from each specialty?
SELECT d.Specialty, ROUND(SUM(t.Cost), 2) AS TotalRevenue
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
WHERE a.Status = 'Completed'
GROUP BY d.Specialty
ORDER BY TotalRevenue DESC;

-- Problem 15: Which patients have the most appointments?-- 
SELECT p.PatientID, p.FirstName, p.LastName, 
       COUNT(a.AppointmentID) AS TotalAppointments
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.FirstName, p.LastName
ORDER BY TotalAppointments DESC
LIMIT 5;

-- Problem 16: What percentage of appointments receive feedback?
SELECT 
    ROUND((SELECT COUNT(DISTINCT AppointmentID) FROM Feedback) * 100.0 / 
    (SELECT COUNT(*) FROM Appointments), 2) AS FeedbackPercentage;
    
-- Problem 17: What is the average treatment duration by specialty?
SELECT d.Specialty, ROUND(AVG(t.DurationMinutes), 2) AS AvgDuration
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
GROUP BY d.Specialty
ORDER BY AvgDuration DESC;

-- Problem 18: Which month had the highest number of appointments?
SELECT YEAR(AppointmentDate) AS Year, 
       MONTH(AppointmentDate) AS Month,
       COUNT(*) AS TotalAppointments
FROM Appointments
GROUP BY YEAR(AppointmentDate), MONTH(AppointmentDate)
ORDER BY TotalAppointments DESC;

-- Problem 19: What is the distribution of appointment statuses?
SELECT Status, COUNT(*) AS Count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Appointments), 2) AS Percentage
FROM Appointments
GROUP BY Status;

-- Problem 20: Which doctors have the shortest average appointment duration?
SELECT d.DoctorID, d.FirstName, d.LastName, d.Specialty,
       ROUND(AVG(t.DurationMinutes), 2) AS AvgDuration
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Specialty
ORDER BY AvgDuration ASC
LIMIT 5;

-- Problem 21: How many patients are in each age group?
SELECT 
    CASE 
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS AgeGroup,
    COUNT(*) AS PatientCount
FROM Patients
GROUP BY AgeGroup
ORDER BY PatientCount DESC;

-- Problem 22: What is the total cost of cancelled appointments?
SELECT ROUND(SUM(t.Cost), 2) AS LostRevenue
FROM Appointments a
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
WHERE a.Status = 'Cancelled';

-- Problem 23: Which treatment type is most frequently performed?
SELECT TreatmentType, COUNT(*) AS Frequency
FROM Treatments
GROUP BY TreatmentType
ORDER BY Frequency DESC
LIMIT 5;

-- Problem 24: What is the patient satisfaction trend over time?
SELECT YEAR(a.AppointmentDate) AS Year,
       MONTH(a.AppointmentDate) AS Month,
       ROUND(AVG(f.Rating), 2) AS AvgRating
FROM Appointments a
JOIN Feedback f ON a.AppointmentID = f.AppointmentID
GROUP BY YEAR(a.AppointmentDate), MONTH(a.AppointmentDate)
ORDER BY Year, Month;

-- Problem 25: Which doctors have no cancellations or no-shows?
SELECT d.DoctorID, d.FirstName, d.LastName, d.Specialty,
       COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
WHERE a.Status = 'Completed'
GROUP BY d.DoctorID, d.FirstName, d.LastName, d.Specialty
HAVING COUNT(a.AppointmentID) = (
    SELECT COUNT(*) 
    FROM Appointments a2 
    WHERE a2.DoctorID = d.DoctorID
)
ORDER BY TotalAppointments DESC;

    

