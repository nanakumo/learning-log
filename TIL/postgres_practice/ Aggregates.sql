-- Q1: We want to know how many facilities exist - simply produce a total count.
SELECT COUNT(facid) FROM cd.facilities;

-- Q2: Produce a count of the number of facilities that have a cost to guests of 10 or more.
SELECT COUNT(facid) FROM cd.facilities WHERE guestcost > 10;

-- Q3: Produce a count of the number of recommendations each member has made. Order by member ID.
SELECT recommendedby, COUNT(*) FROM cd.members WHERE recommendedby IS NOT NULL
	GROUP BY recommendedby
ORDER BY recommendedby;

-- Q4: Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.
SELECT facid, SUM(slots) AS "Total Slots" FROM cd.bookings 
	GROUP BY facid
ORDER BY facid;

-- Q5: Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.
SELECT facid, SUM(slots) AS "Total Slots"
	FROM cd.bookings
	WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01' 
	GROUP BY facid
ORDER BY "Total Slots";

-- Q6: Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.
SELECT facid, EXTRACT(month FROM starttime) AS month, SUM(slots) AS "Total Slots" 
	FROM cd.bookings
	WHERE EXTRACT(year FROM starttime) = 2012
	GROUP BY facid, month
ORDER BY facid, month;

-- Q7: Find the total number of members (including guests) who have made at least one booking.
SELECT COUNT(DISTINCT memid) FROM cd.bookings;

-- Q8: Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and slots, sorted by facility id.
SELECT facid, SUM(slots) AS "Total Slots"
	FROM cd.bookings
	GROUP BY facid
	HAVING SUM(slots) > 1000
ORDER BY facid;

-- Q9: Produce a list of facilities along with their total revenue. The output table should consist of facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!
SELECT facs.name, SUM(slots * 
	CASE 
		WHEN memid = 0 THEN guestcost
		ELSE membercost
	END) AS revenue
	FROM  cd.facilities facs
		INNER JOIN cd.bookings bks
		ON facs.facid = bks.facid
	GROUP BY facs.name
ORDER BY revenue;

-- Q10: Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!
-- HAVING使用例
SELECT facs.name, SUM(slots * 
	CASE 
		WHEN memid = 0 THEN guestcost
		ELSE membercost
	END) AS revenue
	FROM cd.facilities facs
		INNER JOIN cd.bookings bks
		ON facs.facid = bks.facid
	GROUP BY facs.name
	HAVING SUM(slots * 
	CASE 
		WHEN memid = 0 THEN guestcost
		ELSE membercost
	END) < 1000
ORDER BY revenue;
-- サブクエリ使用例
SELECT name, revenue FROM (
	SELECT facs.name, SUM(slots * 
		CASE 
			WHEN memid = 0 THEN guestcost
			ELSE membercost
		END) AS revenue
		FROM cd.facilities facs
			INNER JOIN cd.bookings bks
			ON facs.facid = bks.facid
	GROUP BY facs.name) AS agg WHERE revenue < 1000
ORDER BY revenue;

-- Q11: Output the facility id that has the highest number of slots booked. 
SELECT facid, SUM(slots) AS "Total Slots"
	FROM cd.bookings
	GROUP BY facid
ORDER BY "Total Slots" DESC
LIMIT 1;

--Q12: Produce a list of the total number of slots booked per facility per month in the year of 2012. In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. The output table should consist of facility id, month and slots, sorted by the id and month. When calculating the aggregated values for all months and all facids, return null values in the month and facid columns.
SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) AS slots
	FROM cd.bookings
	WHERE EXTRACT(YEAR FROM starttime) = 2012
	GROUP BY rollup(facid, month)
ORDER BY facid, month;

--Q13: Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. The output table should consist of the facility id, name, and hours booked, sorted by facility id. Try formatting the hours to two decimal places.
-- まだ理解できないので後で考えてみる
SELECT facs.facid, facs.name, trim(to_char(SUM(bks.slots)/2.0, '9999999999999999D99')) AS "Total Hours"
	FROM cd.facilities facs
		INNER JOIN cd.bookings bks
		ON facs.facid = bks.facid
	GROUP BY facs.facid, facs.name
ORDER BY facs.facid;

-- Q14: Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
SELECT mems.surname, mems.firstname, mems.memid, MIN(bks.starttime)
	FROM cd.members mems
		INNER JOIN cd.bookings bks
		ON mems.memid = bks.memid
	WHERE starttime >= '2012-09-01'
	GROUP BY mems.surname, mems.firstname, mems.memid
ORDER BY mems.memid;

-- Q15: Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.
SELECT COUNT(*) over(), firstname, surname
	FROM cd.members
ORDER BY joindate;

-- Q16: Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.
SELECT ROW_NUMBER() OVER(ORDER BY joindate) AS row_number, firstname, surname
	FROM cd.members

-- Q17: Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.
-- まだ理解できないが後でもう少し考えてみる
select facid, total from (
	select facid, sum(slots) total, rank() over (order by sum(slots) desc) rank
        	from cd.bookings
		group by facid
	) as ranked
	where rank = 1   

