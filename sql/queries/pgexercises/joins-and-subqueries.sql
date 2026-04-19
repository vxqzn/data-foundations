# Joins Section

-- How can you produce a list of the start times for bookings by members named 'David Farrell'?
SELECT starttime
FROM cd.bookings
INNER JOIN cd.members ON cd.bookings.memid = cd.members.memid
WHERE surname = 'Farrell' AND firstname = 'David';

-- How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
SELECT starttime AS start, name
FROM cd.bookings
INNER JOIN cd.facilities ON cd.bookings.facid = cd.facilities.facid
WHERE DATE(starttime) = '2012-09-21' AND name LIKE 'Tennis Court%'
ORDER BY starttime;

-- How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
SELECT DISTINCT recs.firstname AS firstname, recs.surname AS surname
FROM cd.members mems
INNER JOIN cd.members recs ON recs.memid = mems.recommendedby
ORDER BY surname, firstname;

-- How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).
SELECT
    mem.firstname AS memfname,
    mem.surname AS memsname,
    rec.firstname AS recfname,
    rec.surname AS recsname
FROM cd.members mem
LEFT JOIN cd.members rec
    ON rec.memid = mem.recommendedby
ORDER BY mem.surname, mem.firstname;

-- How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name followed by the facility name.
SELECT DISTINCT
    mem.firstname || ' ' || mem.surname AS members,
    fac.name AS facility
FROM cd.members mem
INNER JOIN cd.bookings book
    ON mem.memid = book.memid
INNER JOIN cd.facilities fac
    ON book.facid = fac.facid
        AND fac.name LIKE 'Tennis Court%'
WHERE fac.name IS NOT NULL
ORDER BY members, facility;

-- How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries.
SELECT
    mem.firstname || ' ' || mem.surname AS member,
    fac.name as facility,
    CASE
        WHEN mem.memid = 0 THEN book.slots * fac.guestcost
        ELSE book.slots * fac.membercost
    END AS cost
FROM cd.members mem
INNER JOIN cd.bookings book
    ON mem.memid = book.memid
INNER JOIN cd.facilities fac
    ON book.facid = fac.facid
WHERE DATE(book.starttime) = '2012-09-14'
    AND (
        CASE
            WHEN mem.memid = 0 THEN book.slots * fac.guestcost
            ELSE book.slots * fac.membercost
        END 
    ) > 30
ORDER BY cost DESC;