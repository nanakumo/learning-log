-- Joins and Subquries Exercises
-- Q1: (inner join 1)How can you produce a list of the start times for bookings by members named 'David Farrell'?
-- 一つ目の書き方(サブクエリ)
SELECT starttime FROM cd.bookings WHERE memid = (SELECT memid FROM cd.members WHERE surname = 'Farrell' AND firstname = 'David');
-- 二つ目の書き方(inner join)
SELECT bks.starttime
	FROM
		cd.bookings bks, cd.members mems
	WHERE
		mems.firstname = 'David'
		AND mems.surname = 'Farrell'
		AND mems.memid = bks.memid;

-- Q2: (inner join 2)How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
SELECT bks.starttime AS start, facs.name AS name
	FROM  cd.facilities facs
	INNER JOIN cd.bookings bks
		ON facs.facid = bks.facid
	WHERE facs.name IN('Tennis Court 2', 'Tennis Court 1')
		AND bks.starttime >= '2012-09-21'
		AND bks.starttime < '2012-09-22'
ORDER BY bks.starttime;

-- Q3: (self join 1) How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
SELECT DISTINCT recs.firstname, recs.surname
	FROM cd.members mems
	INNER JOIN cd.members recs
		ON recs.memid = mems.recommendedby
ORDER BY surname, firstname;

-- Q4: (self join 2)How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).
SELECT mems.firstname AS memfname, mems.surname AS memsname, recs.firstname AS recfname, recs.surname AS recsname
	FROM cd.members mems
	LEFT JOIN cd.members recs
		ON mems.recommendedby = recs.memid
ORDER BY mems.surname, mems.firstname;

-- Q5: (Threejoin 1)How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name followed by the facility name.
SELECT DISTINCT mems.firstname || ' ' || mems.surname AS member, facs.name AS name
	FROM cd.members mems
	INNER JOIN cd.bookings bks
		ON mems.memid = bks.memid
	INNER JOIN cd.facilities facs
		ON bks.facid = facs.facid
	WHERE facs.name IN ('Tennis Court 1', 'Tennis Court 2')
ORDER BY member, name;

-- Q6: (Threejoin 2)How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries.
SELECT mems.firstname || ' ' || mems.surname AS member, facs.name AS facility,
	CASE
		WHEN mems.memid = 0 THEN (facs.guestcost * bks.slots)
		ELSE (facs.membercost * bks.slots)
	END AS cost
	FROM cd.members mems
	INNER JOIN cd.bookings bks
		ON mems.memid = bks.memid
	INNER JOIN cd.facilities facs
		ON bks.facid = facs.facid
WHERE bks.starttime >= '2012-09-14' AND  bks.starttime < '2012-09-15'
	AND(
		CASE
			WHEN mems.memid = 0 THEN (facs.guestcost * bks.slots)
			ELSE (facs.membercost * bks.slots)
			END
	) > 30
ORDER BY cost DESC;
-- CTEを使ってQ6を解く
WITH priced AS(
	SELECT mems.firstname || ' ' || mems.surname AS member, facs.name AS facility,
		CASE
			WHEN mems.memid = 0 THEN (facs.guestcost * bks.slots)
			ELSE (facs.membercost * bks.slots)
		END AS cost
		FROM cd.members mems
		INNER JOIN cd.bookings bks
			ON mems.memid = bks.memid
		INNER JOIN cd.facilities facs
			ON bks.facid = facs.facid
	WHERE bks.starttime >= '2012-09-14' AND  bks.starttime < '2012-09-15'
)
SELECT * FROM priced WHERE cost > 30
ORDER BY cost DESC

-- Q7: (Subquery)How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.
SELECT DISTINCT mems.firstname || ' ' || mems.surname AS member,
	(SELECT recs.firstname || ' ' || recs.surname
		FROM cd.members recs
		WHERE recs.memid = mems.recommendedby)
FROM cd.members mems
ORDER BY member;

-- Q8: (Tjsub)How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost.
SELECT member, facilities, cost FROM(
	SELECT
		mems.firstname || ' ' || mems.surname AS member,
		facs.name AS facilities,
		CASE
			WHEN mems.memid = 0 THEN (facs.guestcost * bks.slots)
		ELSE facs.membercost * bks.slots
		END AS cost
		FROM cd.members mems
		INNER JOIN cd.bookings bks
			ON mems.memid = bks.memid
		INNER JOIN cd.facilities facs
			ON bks.facid = facs.facid
		WHERE bks.starttime >= '2012-09-14' AND bks.starttime < '2012-09-15'
	) AS bookings
	WHERE cost > 30
ORDER By cost DESC;
