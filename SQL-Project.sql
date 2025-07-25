-- Drop tables if they already exist
DROP TABLE IF EXISTS GPA_Log;
DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS Semesters;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Students;

-- Create schema
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits INT
);

CREATE TABLE Semesters (
    semester_id INT PRIMARY KEY,
    semester_name VARCHAR(20)
);

CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    semester_id INT,
    marks INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id)
);

-- Insert sample data
INSERT INTO Students VALUES 
(1, 'Amit', 'CSE'), 
(2, 'Rita', 'ECE');

INSERT INTO Courses VALUES 
(101, 'Maths', 4), 
(102, 'DSA', 3), 
(103, 'English', 2);

INSERT INTO Semesters VALUES 
(1, 'Sem 1'), 
(2, 'Sem 2');

INSERT INTO Grades (student_id, course_id, semester_id, marks, grade) VALUES
(1, 101, 1, 88, 'A'),
(1, 102, 1, 76, 'B'),
(1, 103, 1, 66, 'C'),
(2, 101, 1, 92, 'A'),
(2, 102, 1, 81, 'B'),
(2, 103, 1, 59, 'D');

-- GPA per student per semester
SELECT 
  g.student_id,
  s.name,
  g.semester_id,
  SUM(
    CASE grade
      WHEN 'A' THEN 10
      WHEN 'B' THEN 8
      WHEN 'C' THEN 6
      WHEN 'D' THEN 4
      ELSE 0
    END * c.credits
  ) / SUM(c.credits) AS GPA
FROM Grades g
JOIN Students s ON g.student_id = s.student_id
JOIN Courses c ON g.course_id = c.course_id
GROUP BY g.student_id, g.semester_id;

-- Pass/Fail statistics
SELECT 
  student_id,
  COUNT(CASE WHEN grade IN ('A', 'B', 'C', 'D') THEN 1 END) AS passed,
  COUNT(CASE WHEN grade = 'F' THEN 1 END) AS failed
FROM Grades
GROUP BY student_id;

-- GPA_Log table for trigger
CREATE TABLE GPA_Log (
    student_id INT,
    semester_id INT,
    gpa DECIMAL(4,2)
);

-- Set delimiter before trigger
DELIMITER $$

-- Trigger to auto-update GPA
CREATE TRIGGER calc_gpa AFTER INSERT ON Grades
FOR EACH ROW
BEGIN
    DELETE FROM GPA_Log WHERE student_id = NEW.student_id AND semester_id = NEW.semester_id;
    
    INSERT INTO GPA_Log(student_id, semester_id, gpa)
    SELECT 
        g.student_id,
        g.semester_id,
        SUM(
          CASE g.grade
            WHEN 'A' THEN 10
            WHEN 'B' THEN 8
            WHEN 'C' THEN 6
            WHEN 'D' THEN 4
            ELSE 0
          END * c.credits
        ) / SUM(c.credits)
    FROM Grades g
    JOIN Courses c ON g.course_id = c.course_id
    WHERE g.student_id = NEW.student_id AND g.semester_id = NEW.semester_id
    GROUP BY g.student_id, g.semester_id;
END$$

-- Reset delimiter
DELIMITER ;

-- Semester-wise result summary
SELECT 
  s.name AS Student,
  sem.semester_name,
  c.course_name,
  g.marks,
  g.grade
FROM Grades g
JOIN Students s ON g.student_id = s.student_id
JOIN Courses c ON g.course_id = c.course_id
JOIN Semesters sem ON g.semester_id = sem.semester_id
ORDER BY s.student_id, g.semester_id;
