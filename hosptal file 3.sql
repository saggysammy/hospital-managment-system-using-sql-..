-- Problem 1: What is the average patient age for each medical specialty?
SELECT d.Specialty, ROUND(AVG(p.Age), 1) AS AverageAge
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Patients p ON a.PatientID = p.PatientID
WHERE a.Status = 'Completed'
GROUP BY d.Specialty
ORDER BY AverageAge DESC;

-- Problem 2: What is the seasonal trend in appointment cancellations?


SELECT 
    CASE 
        WHEN MONTH(AppointmentDate) IN (12,1,2) THEN 'Winter'
        WHEN MONTH(AppointmentDate) IN (3,4,5) THEN 'Spring'
        WHEN MONTH(AppointmentDate) IN (6,7,8) THEN 'Summer'
        ELSE 'Fall'
    END AS Season,
    COUNT(*) AS TotalAppointments,
    SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled,
    ROUND(SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS CancelRate
FROM Appointments
GROUP BY Season
ORDER BY CancelRate DESC;


-- Problem 3: What is the cost difference between male and female patients?
SELECT p.Gender,
       ROUND(AVG(t.Cost), 2) AS AvgTreatmentCost,
       ROUND(SUM(t.Cost), 2) AS TotalSpent,
       COUNT(DISTINCT p.PatientID) AS PatientCount
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Treatments t ON a.AppointmentID = t.AppointmentID
WHERE a.Status = 'Completed'
GROUP BY p.Gender;

-- Problem 4: Which time of day has the highest appointment success rate?
SELECT 
    CASE 
        WHEN HOUR(AppointmentDate) BETWEEN 6 AND 11 THEN 'Morning (6AM-12PM)'
        WHEN HOUR(AppointmentDate) BETWEEN 12 AND 16 THEN 'Afternoon (12PM-5PM)'
        ELSE 'Evening (5PM-9PM)'
    END AS TimeOfDay,
    COUNT(*) AS TotalAppointments,
    SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
    ROUND(SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS SuccessRate
FROM Appointments
GROUP BY TimeOfDay
ORDER BY SuccessRate DESC;

-- Problem 5: What is the patient satisfaction correlation with treatment cost?
SELECT 
    CASE 
        WHEN t.Cost < 100 THEN 'Under $100'
        WHEN t.Cost BETWEEN 100 AND 200 THEN '$100-$200'
        WHEN t.Cost BETWEEN 201 AND 300 THEN '$201-$300'
        ELSE 'Over $300'
    END AS CostRange,
    ROUND(AVG(f.Rating), 2) AS AvgRating,
    COUNT(*) AS TotalTreatments
FROM Treatments t
JOIN Feedback f ON t.AppointmentID = f.AppointmentID
GROUP BY CostRange
ORDER BY AvgRating DESC;

--  Problem 6: What is the revenue growth rate month over month?
WITH MonthlyRevenue AS (
    SELECT 
        YEAR(a.AppointmentDate) AS Year,
        MONTH(a.AppointmentDate) AS Month,
        ROUND(SUM(t.Cost), 2) AS Revenue
    FROM Appointments a
    JOIN Treatments t ON a.AppointmentID = t.AppointmentID
    WHERE a.Status = 'Completed'
    GROUP BY YEAR(a.AppointmentDate), MONTH(a.AppointmentDate)
)
SELECT 
    Year, Month, Revenue,
    ROUND(((Revenue - LAG(Revenue) OVER (ORDER BY Year, Month)) / 
    LAG(Revenue) OVER (ORDER BY Year, Month)) * 100, 2) AS GrowthRate
FROM MonthlyRevenue;

-- Problem 7: What is the no-show rate by patient age group?
SELECT 
    CASE 
        WHEN p.Age < 30 THEN 'Under 30'
        WHEN p.Age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS AgeGroup,
    COUNT(*) AS TotalAppointments,
    SUM(CASE WHEN a.Status = 'No-Show' THEN 1 ELSE 0 END) AS NoShows,
    ROUND(SUM(CASE WHEN a.Status = 'No-Show' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS NoShowRate
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
GROUP BY AgeGroup
ORDER BY NoShowRate DESC;

 -- Problem 8: What is the patient satisfaction trend by doctor experience?
 SELECT 
    CASE 
        WHEN DATEDIFF('2024-03-31', HireDate) < 365 THEN 'Less than 1 year'
        WHEN DATEDIFF('2024-03-31', HireDate) BETWEEN 365 AND 1095 THEN '1-3 years'
        ELSE 'Over 3 years'
    END AS ExperienceLevel,
    ROUND(AVG(f.Rating), 2) AS AvgRating,
    COUNT(DISTINCT d.DoctorID) AS DoctorCount
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Feedback f ON a.AppointmentID = f.AppointmentID
GROUP BY ExperienceLevel
ORDER BY AvgRating DESC;

-- Problem 9: What is the patient wait time between appointment booking and actual visit?
SELECT d.Specialty,
       ROUND(AVG(DATEDIFF(a.AppointmentDate, p.RegistrationDate)), 1) AS AvgDaysToFirstAppointment,
       COUNT(*) AS PatientCount
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE a.Status = 'Completed'
GROUP BY d.Specialty
HAVING PatientCount >= 3
ORDER BY AvgDaysToFirstAppointment DESC;


