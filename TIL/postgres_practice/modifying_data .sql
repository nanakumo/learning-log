-- Q1: The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
-- facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
INSERT INTO cd.facilities VALUES (
  9, 'Spa', 20, 30, 100000, 800);

-- Q2: n the previous exercise, you learned how to add a facility. Now you're going to add multiple facilities in one command. Use the following values:
--facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
-- facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80.
INSERT INTO cd.facilities VALUES 
(9, 'Spa', 20, 30, 100000, 800),
(10, 'Squash Court 2', 3.5, 17.5, 5000, 80);

-- Q3: We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2'; 

-- Q4: We want to increase the price of the tennis courts for both members and guests. Update the costs to be 6 for members, and 30 for guests.
UPDATE cd.facilities
SET membercost = 6, guestcost = 30
WHERE facid IN (0, 1); 

-- Q5: We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
UPDATE cd.facilities 
SET 
membercost = (SELECT membercost*1.1 FROM cd.facilities WHERE facid = 0),
guestcost = (SELECT guestcost*1.1 FROM cd.facilities WHERE facid = 0)
WHERE facid = 1;

-- Q6: As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. How can we accomplish this?
DELETE FROM cd.bookings;

-- Q7: We want to remove member 37, who has never made a booking, from our database. How can we achieve that?
DELETE FROM cd.members WHERE memid = 37;

-- Q8: In our previous exercises, we deleted a specific member who had never made a booking. How can we make that more general, to delete all members who have never made a booking?
DELETE FROM cd.members WHERE memid NOT IN (SELECT memid FROM cd.bookings);