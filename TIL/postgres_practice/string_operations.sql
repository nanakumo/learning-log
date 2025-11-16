-- Q1: Output the names of all members, formatted as 'Surname, Firstname'
SELECT surname || ', ' || firstname AS name
	FROM cd.members;

-- Q2: Find all facilities whose name begins with 'Tennis'. Retrieve all columns.
SELECT * FROM cd.facilities
	WHERE name LIKE 'Tennis%';

-- Q3: Perform a case-insensitive search to find all facilities whose name begins with 'tennis'. Retrieve all columns.
SELECT * FROM cd.facilities
	WHERE name ILIKE 'TENNIS%';

-- Q4: You've noticed that the club's member table has telephone numbers with very inconsistent formatting. You'd like to find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.
SELECT memid, telephone
	FROM cd.members
	WHERE telephone ~ '[()]';


-- Q5: The zip codes in our example dataset have had leading zeroes removed from them by virtue of being stored as a numeric type. Retrieve all zip codes from the members table, padding any zip codes less than 5 characters long with leading zeroes. Order by the new zip code.
SELECT LPAD(CAST(zipcode AS CHAR(5)), 5, '0') AS zip
	FROM cd.members
ORDER BY zipcode;

-- Q6: You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet. Sort by the letter, and don't worry about printing out a letter if the count is 0.
SELECT SUBSTR(surname, 1, 1) AS letter, COUNT(*)
	FROM cd.members
	GROUP BY letter
ORDER BY letter;

-- Q7: The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.
SELECT memid, translate(telephone, '-() ', '') AS telephone
	FROM cd.members
ORDER BY memid;
