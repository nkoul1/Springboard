/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:


https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

/* Solution 1: SELECT name FROM Facilities WHERE membercost > 0


/* Q2: How many facilities do not charge a fee to members? */

/* Solution 2: SELECT COUNT(membercost = 0) FROM Facilities


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

/* Solution 3: SELECT facid,
	   				name,
	   				membercost,
	   				monthlymaintenance
				FROM Facilities
				WHERE membercost < (0.2 * monthlymaintenance)


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

/* Solution 4: SELECT * FROM Facilities WHERE facid = 1

			 UNION

			 SELECT * FROM Facilities Where facid = 5

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

/* Solution 5: SELECT name,
	   				monthlymaintenance,
	   				CASE WHEN monthlymaintenance > 100 THEN 'expensive'
	   				ELSE 'cheap' END AS pricing
				FROM Facilities  


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

/* Solution 6: SELECT firstname, surname, MAX(joindate) 
				FROM Members 
				WHERE firstname != 'GUEST'

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

/* Solution 7: Select member_name from 

				(select distinct concat(m.firstname,' ',m.surname) as member_name, 
						CASE WHEN f.name LIKE 'Tennis%' THEN 'yes'
							ELSE 'no' END as used_a_tennis_court
				FROM Bookings b
				Join Members m ON b.memid = m.memid
				Join Facilities f ON b.facid = f.facid) as a

				Where used_a_tennis_court = 'yes'
				AND member_name NOT LIKE '%GUEST%'
				ORDER BY member_name






/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

/* Solution 8: Select * from(

				select f.name, concat(m.firstname,' ',m.surname),
						CASE WHEN b.memid = 0 THEN f.guestcost*b.slots 
	     					 WHEN b.memid != 0 THEN f.membercost*b.slots END as patron_cost
				FROM Bookings b
				Left Join Facilities f on f.facid = b.facid
				Left Join Members m on m.memid = b.memid
				Where b.starttime LIKE '2012-09-14%'

					) table1

			WHERE patron_cost > 30
			Order by patron_cost DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */

/* Solution 9: SELECT *
				FROM

				(SELECT concat(m.firstname,' ',m.surname) as member_name, 
	   					f.name as facility_name,
	   					CASE WHEN m.firstname LIKE '%GUEST%' THEN f.guestcost * b.slots
						ELSE f.membercost * b.slots END AS cost



					FROM Bookings b
					LEFT JOIN Facilities f on f.facid = b.facid
					LEFT JOIN Members m on m.memid = b.memid

					WHERE b.starttime like '%2012-09-14%') as innertable

WHERE cost > 30
ORDER by cost DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Solution 10:
				

select * from (

			select a.facility_name,a.guest_slots * a.guest_cost + b.member_slots*b.member_cost AS revenue 
			from
			(
			(select f.name as facility_name, SUM(b.slots) as guest_slots, f.guestcost as guest_cost
			from Bookings b
		join Facilities f on f.facid = b.facid
		where b.memid = 0
		group by 1
		order by 2 asc) as a

		Left Join
		(select f.name as facility_name, SUM(b.slots) as member_slots, f.membercost as member_cost
			from Bookings b
			join Facilities f on f.facid = b.facid
			where b.memid != 0
			group by 1
			order by 2 asc) as b ON a.facility_name = b.facility_name

			)

		) as table1

Where revenue < 1000 




