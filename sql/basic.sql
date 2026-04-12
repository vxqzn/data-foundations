# Basic SQL Section

-- Retrieve all information from cd.facilities
SELECT * FROM cd.facilities;

-- List facility names and costs to members
SELECT name, membercost FROM cd.facilities;

-- Facilities that charge a fee to members
SELECT name, membercost FROM cd.facilities WHERE membercost > 0;

-- Facilities with member cost > 0 and less than 1/50th of monthly maintenance
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0 AND membercost * 50 < monthlymaintenance;

-- Facilities with 'Tennis' in their name
SELECT *
FROM cd.facilities
WHERE name ILIKE '%tennis%';

-- Details of facilities with ID 1 and 5
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);

-- Label facilities as 'cheap' or 'expensive' based on monthly maintenance > $100
SELECT name,
CASE WHEN monthlymaintenance > 100 THEN 'expensive' ELSE 'cheap' END AS cost
FROM cd.facilities;

-- Members who joined after September 1, 2012
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= '2012-09-01';

-- Ordered list of first 10 distinct surnames
SELECT DISTINCT surname
FROM cd.members
ORDER BY surname ASC
LIMIT 10;

-- Combined list of surnames and facility names
SELECT surname FROM cd.members
UNION
SELECT name FROM cd.facilities;

-- Signup date of the last member
SELECT MAX(joindate) AS latest
FROM cd.members;

-- First and last name of the last member(s) who signed up
SELECT firstname, surname, joindate
FROM cd.members
WHERE joindate = (SELECT MAX(joindate) FROM cd.members);

