# University Course Management System — SQL Final Project

## Project objective
Create a relational database for a university using SQL. The database manages departments, students, instructors, courses, and enrollments.

## Software
- MySQL 8.0 or newer
- MySQL Workbench (recommended) or another MySQL client

## Files
- `University_Course_Management_System.sql` — creates the database, creates five related tables, inserts sample data, demonstrates CRUD, and runs all 16 assigned queries.

## How to run in MySQL Workbench
1. Open MySQL Workbench and connect to your local MySQL server.
2. Select **File → Open SQL Script**.
3. Open `University_Course_Management_System.sql`.
4. Click the lightning-bolt **Execute** button to run the script.
5. In the SCHEMAS panel, refresh and select `UniversityCourseDB` if needed.
6. Scroll through the **Result Grid** sections to view query outputs.

## Tables and relationships
- `Departments`: department details.
- `Students`: student details.
- `Instructors`: instructor details and salary.
- `Courses`: courses and their department.
- `Enrollments`: links students to courses.

Primary keys uniquely identify rows. Foreign keys maintain valid relationships. A student cannot be enrolled in the same course twice because of `UNIQUE (StudentID, CourseID)`.

## Assumptions
1. MySQL 8.0+ is used because Query 15 uses a window function.
2. The assignment asks for maximum instructor salary but the screenshot does not list a Salary field, so `Salary` was added to `Instructors`.
3. “Students who enrolled after 2022” means student `EnrollmentDate` on or after 1 January 2023.
4. “Senior” means the student's enrollment date is more than four years before today's date. The `CASE` query uses `CURDATE()`, so its result changes over time.
5. The sample data is small for beginner-friendly testing. Therefore, queries asking for more than 5 or more than 10 students may return no rows until you add more enrollments. That is expected, not an SQL error.
6. The CRUD examples use temporary ID 99 rows and delete them after demonstrating INSERT, SELECT, UPDATE, and DELETE. The main sample data remains intact.

## GitHub upload
Create a repository named `University-Course-Management-System`, then upload this SQL file and `README.md`. Add screenshots of successful query results if your instructor requests them.
# Final-Project_sql-README.md
