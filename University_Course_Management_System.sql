CREATE DATABASE IF NOT EXISTS UniversityCourseDB;
USE UniversityCourseDB;

-- Remove old tables in child-to-parent order so the script can be rerun.
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;

-- 1. DEPARTMENTS
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

-- 2. STUDENTS
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(120) NOT NULL UNIQUE,
    BirthDate DATE,
    EnrollmentDate DATE NOT NULL
);

-- 3. INSTRUCTORS
-- Salary is included because Query 8 asks for the maximum instructor salary.
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(120) NOT NULL UNIQUE,
    DepartmentID INT NOT NULL,
    Salary DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 4. COURSES
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    Credits INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    CHECK (Credits > 0)
);

-- 5. ENROLLMENTS
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    UNIQUE (StudentID, CourseID)
);

-- =========================================================
-- SAMPLE DATA
-- =========================================================

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

INSERT INTO Students
(StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01'),
(3, 'Rahul', 'Patel', 'rahul.patel@email.com', '2003-03-12', '2023-07-15'),
(4, 'Priya', 'Shah', 'priya.shah@email.com', '2002-11-05', '2024-08-01'),
(5, 'Amit', 'Desai', 'amit.desai@email.com', '2001-06-20', '2020-08-01'),
(6, 'Neha', 'Joshi', 'neha.joshi@email.com', '2004-02-14', '2025-07-20');

INSERT INTO Instructors
(InstructorID, FirstName, LastName, Email, DepartmentID, Salary) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 65000.00),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2, 60000.00),
(3, 'Carol', 'Brown', 'carol.brown@univ.com', 1, 72000.00);

INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits) VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4),
(103, 'Python Programming', 1, 3),
(104, 'Calculus', 2, 4),
(105, 'Database Systems', 1, 3),
(106, 'Statistics', 2, 3);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01'),
(3, 1, 103, '2022-08-05'),
(4, 3, 101, '2023-07-20'),
(5, 3, 103, '2023-07-21'),
(6, 4, 104, '2024-08-02'),
(7, 5, 102, '2020-08-05'),
(8, 2, 104, '2021-08-03'),
(9, 6, 106, '2025-07-22'),
(10, 4, 101, '2024-08-03');

-- =========================================================
-- CRUD EXAMPLES FOR ALL TABLES
-- These are safe examples: temporary rows are inserted, updated,
-- displayed, and deleted. They do not change the main sample rows.
-- =========================================================

-- Departments: CREATE, READ, UPDATE, DELETE
INSERT INTO Departments VALUES (99, 'Temporary Department');
SELECT * FROM Departments WHERE DepartmentID = 99;
UPDATE Departments SET DepartmentName = 'Updated Temporary Department'
WHERE DepartmentID = 99;
DELETE FROM Departments WHERE DepartmentID = 99;

-- Students: CREATE, READ, UPDATE, DELETE
INSERT INTO Students VALUES
(99, 'Test', 'Student', 'test.student@example.com', '2000-01-01', '2025-01-01');
SELECT * FROM Students WHERE StudentID = 99;
UPDATE Students SET LastName = 'Updated' WHERE StudentID = 99;
DELETE FROM Students WHERE StudentID = 99;

-- Instructors: CREATE, READ, UPDATE, DELETE
INSERT INTO Instructors VALUES
(99, 'Test', 'Teacher', 'test.teacher@univ.com', 1, 40000.00);
SELECT * FROM Instructors WHERE InstructorID = 99;
UPDATE Instructors SET Salary = 42000.00 WHERE InstructorID = 99;
DELETE FROM Instructors WHERE InstructorID = 99;

-- Courses: CREATE, READ, UPDATE, DELETE
INSERT INTO Courses VALUES (199, 'Temporary Course', 1, 2);
SELECT * FROM Courses WHERE CourseID = 199;
UPDATE Courses SET Credits = 3 WHERE CourseID = 199;
DELETE FROM Courses WHERE CourseID = 199;

-- Enrollments: CREATE, READ, UPDATE, DELETE
INSERT INTO Enrollments VALUES (99, 6, 101, '2025-08-01');
SELECT * FROM Enrollments WHERE EnrollmentID = 99;
UPDATE Enrollments SET EnrollmentDate = '2025-08-02' WHERE EnrollmentID = 99;
DELETE FROM Enrollments WHERE EnrollmentID = 99;

-- =========================================================
-- ASSIGNED QUERIES (1-16)
-- =========================================================

-- 1. CRUD operations are demonstrated above for all five tables.

-- 2. Retrieve students who enrolled after 2022.
SELECT *
FROM Students
WHERE EnrollmentDate >= '2023-01-01';

-- 3. Courses offered by Mathematics department, maximum 5 courses.
SELECT c.CourseID, c.CourseName, c.DepartmentID, c.Credits
FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;

-- 4. Number of students enrolled in each course; show only courses
--    with more than 5 students.
SELECT c.CourseID, c.CourseName, COUNT(e.StudentID) AS StudentCount
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
HAVING COUNT(e.StudentID) > 5;

-- 5. Students enrolled in BOTH Introduction to SQL and Data Structures.
SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures')
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING COUNT(DISTINCT c.CourseName) = 2;

-- 6. Students enrolled in EITHER Introduction to SQL OR Data Structures.
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');

-- 7. Average credits for all courses.
SELECT AVG(Credits) AS AverageCredits
FROM Courses;

-- 8. Maximum instructor salary in Computer Science department.
SELECT MAX(i.Salary) AS MaximumSalary
FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

-- 9. Count of students enrolled in courses of each department.
SELECT d.DepartmentID, d.DepartmentName,
       COUNT(DISTINCT e.StudentID) AS StudentCount
FROM Departments d
LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentID, d.DepartmentName;

-- 10. INNER JOIN: students and their corresponding courses.
SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName,
       e.EnrollmentDate
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID
ORDER BY s.StudentID;

-- 11. LEFT JOIN: all students and their courses, if any.
SELECT s.StudentID, s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID
ORDER BY s.StudentID;

-- 12. Subquery: students enrolled in courses with more than 10 students.
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName
FROM Students s
WHERE s.StudentID IN (
    SELECT e.StudentID
    FROM Enrollments e
    WHERE e.CourseID IN (
        SELECT CourseID
        FROM Enrollments
        GROUP BY CourseID
        HAVING COUNT(DISTINCT StudentID) > 10
    )
);

-- 13. Extract the year from each enrollment date.
SELECT StudentID, CourseID, EnrollmentDate,
       YEAR(EnrollmentDate) AS EnrollmentYear
FROM Enrollments;

-- 14. Concatenate instructor's first and last name.
SELECT InstructorID,
       CONCAT(FirstName, ' ', LastName) AS InstructorFullName
FROM Instructors;

-- 15. Running total of students enrolled in courses, by enrollment date.
SELECT EnrollmentID, StudentID, CourseID, EnrollmentDate,
       COUNT(*) OVER (
           ORDER BY EnrollmentDate, EnrollmentID
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS RunningEnrollmentTotal
FROM Enrollments;

-- 16. Label each student Senior if their enrollment date is more than
--     4 years before today; otherwise Junior.
SELECT StudentID, FirstName, LastName, EnrollmentDate,
       CASE
           WHEN EnrollmentDate < DATE_SUB(CURDATE(), INTERVAL 4 YEAR)
           THEN 'Senior'
           ELSE 'Junior'
       END AS StudentLevel
FROM Students;

-- Extra useful checks
SELECT * FROM Departments;
SELECT * FROM Students;
SELECT * FROM Instructors;
SELECT * FROM Courses;
SELECT * FROM Enrollments;
