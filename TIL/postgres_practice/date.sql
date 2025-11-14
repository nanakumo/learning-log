-- Q1: Produce a timestamp for 1 a.m. on the 31st of August 2012.
SELECT TIMESTAMP '2012-08-31 01:00:00';

-- Q2: Find the result of subtracting the timestamp '2012-07-30 01:00:00' from the timestamp '2012-08-31 01:00:00'
SELECT TIMESTAMP '2012-08-31 01:00:00' - TIMESTAMP '2012-07-30 01:00:00' AS interval;

-- Q3: Produce a list of all the dates in October 2012. They can be output as a timestamp (with time set to midnight) or a date.
SELECT GENERATE_SERIES(TIMESTAMP '2012-10-01', TIMESTAMP '2012-10-31', INTERVAL '1 DAY') AS ts ;

-- Q4: Get the day of the month from the timestamp '2012-08-31' as an integer.
SELECT EXTRACT(DAY FROM TIMESTAMP '2012-08-31') AS date_part;
SELECT DATE_PART('day', TIMESTAMP '2012-08-31');

-- Q5: Work out the number of seconds between the timestamps '2012-08-31 01:00:00' and '2012-09-02 00:00:00'
SELECT DATE_PART('epoch', TIMESTAMP '2012-09-02 00:00:00' - TIMESTAMP '2012-08-31 01:00:00');

-- Q6: For each month of the year in 2012, output the number of days in that month. Format the output as an integer column containing the month of the year, and a second column containing an interval data type.
SELECT EXTRACT(MONTH FROM cal.month ) AS month, (cal.month + INTERVAL '1 MONTH') - cal.month AS length
	FROM (
		SELECT GENERATE_SERIES(TIMESTAMP '2012-01-01', TIMESTAMP '2012-12-31', INTERVAL '1 MONTH') AS month
) AS cal

-- Q7: For any given timestamp, work out the number of days remaining in the month. The current day should count as a whole day, regardless of the time. Use '2012-02-11 01:00:00' as an example timestamp for the purposes of making the answer. Format the output as a single interval value.
SELECT (DATE_TRUNC('MONTH', ts.time) + INTERVAL '1 MONTH') - (DATE_TRUNC('DAY', ts.time)) AS remaining
	FROM(
		SELECT TIMESTAMP '2012-02-11 01:00:00' AS time
	) AS ts

-- Q8: Return a list of the start and end time of the last 10 bookings (ordered by the time at which they end, followed by the time at which they start) in the system.
SELECT starttime, starttime + slots * (INTERVAL '30 MINUTES') AS endtime
	FROM cd.bookings
ORDER BY endtime DESC, starttime DESC
LIMIT 10;

-- Q10: Return a count of bookings for each month, sorted by month
SELECT DATE_TRUNC('MONTH', starttime) AS month, COUNT(*)
	FROM cd.bookings
	GROUP BY month
ORDER BY month;
