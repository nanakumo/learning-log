-- Q1: Find the upward recommendation chain for member ID 27: that is, the member who recommended them, and the member who recommended that member, and so on. Return member ID, first name, and surname. Order by descending member id.
WITH RECURSIVE recommenders(recommender) AS (
	SELECT recommendedby FROM cd.members WHERE memid = 27
	UNION ALL
	SELECT mems.recommendedby
		FROM recommenders recs
		INNER JOIN cd.members mems
		ON mems.memid = recs.recommender
)
SELECT recs.recommender, mems.firstname, mems.surname
	FROM recommenders recs
		INNER JOIN cd.members mems
		ON recs.recommender = mems.memid
ORDER BY memid DESC;

-- Q2: Find the downward recommendation chain for member ID 1: that is, the members they recommended, the members those members recommended, and so on. Return member ID and name, and order by ascending member id.
WITH RECURSIVE recommendeds(memid) AS (
	SELECT memid FROM cd.members WHERE recommendedby = 1
	UNION ALL
	SELECT mems.memid
		FROM recommendeds recs
		INNER JOIN cd.members mems
		ON mems.recommendedby = recs.memid
)
SELECT recs.memid, mems.firstname, mems.surname
	FROM recommendeds recs
		INNER JOIN cd.members mems
		ON recs.memid = mems.memid
ORDER BY mems.memid;

-- Q3: Produce a CTE that can return the upward recommendation chain for any member. You should be able to select recommender from recommenders where member=x. Demonstrate it by getting the chains for members 12 and 22. Results table should have member and recommender, ordered by member ascending, recommender descending.
-- 難しかったので60％しか理解できていないです。
WITH RECURSIVE recommenders(recommender, member) AS (
	SELECT recommendedby, memid
		FROM cd.members
	UNION ALL
	SELECT mems.recommendedby, recs.member
		FROM recommenders recs
			INNER JOIN cd.members mems
			ON mems.memid = recs.recommender
)
SELECT recs.member, recs.recommender, mems.firstname, mems.surname
	FROM recommenders recs
		INNER JOIN cd.members mems
		ON recs.recommender = mems.memid
	WHERE recs.member = 12 OR recs.member = 22
ORDER BY recs.member ASC, recs.recommender DESC;