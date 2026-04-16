How can you produce a list of the start times for bookings by members named 'David Farrell'?

bselect starttime
from cd.bookings inner join cd.members on cd.bookings.memid = cd.members.memid
where surname = 'Farrell' AND firstname = 'David'

How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

select starttime as start, name
from cd.bookings inner join cd.facilities
on cd.bookings.facid = cd.facilities.facid
where date(starttime) = '2012-09-21' and name like 'Tennis Court%'
order by starttime

How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).

select distinct recs.firstname as firstname, recs.surname as surname
	from 
		cd.members mems 
		inner join cd.members recs
			on recs.memid = mems.recommendedby
order by surname, firstname;