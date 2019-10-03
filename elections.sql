-- The comment lines starting -- ! are used by the automatic testing tool to
-- help mark your coursework. You must not modify them or add further lines
-- starting with -- !. Of course you can create comments of your own, just use
-- the normal -- to start them.

-- !elections

-- !question0
-- This is an example question and answer.

SELECT Party.name FROM Party 
JOIN Candidate ON Candidate.party = Party.id 
WHERE Candidate.name = 'Mark Bradshaw';

-- !question1

SELECT name FROM Party ORDER BY name ASC;

-- !question2

SELECT SUM(votes) AS tot_votes FROM Candidate;

-- !question3

SELECT Candidate.name, votes FROM Candidate JOIN Ward 
ON Candidate.ward = Ward.id
WHERE Ward.name = 'Bedminster';

-- !question4

SELECT Candidate.votes 
FROM Candidate JOIN Ward ON Candidate.ward = Ward.id 
JOIN Party ON Candidate.party = Party.id
WHERE (Ward.name = 'Filwood'AND Party.name = 'Liberal Democrat');

-- !question5

SELECT Candidate.name, Party.name AS party, votes FROM Candidate 
JOIN Party ON Candidate.party = Party.id 
JOIN Ward ON Candidate.ward = Ward.id
WHERE Ward.name = 'Hengrove'
ORDER BY votes DESC;

-- !question6

SELECT 1 + COUNT(1) AS Ranking FROM (
SELECT votes FROM Candidate JOIN Ward ON Candidate.ward = Ward.id 
WHERE Ward.name ='Bishopsworth' AND votes > (SELECT votes FROM Candidate JOIN Party ON Candidate.party = Party.id JOIN Ward ON Ward.id = Candidate.ward WHERE Ward.name ='Bishopsworth' AND Party.name = 'Labour') )AS rnk; 

-- !question7

SELECT bname AS ward_name, (avotes/bvotes)*100 AS percent FROM (
SELECT votes AS avotes, Ward.name AS aname
FROM Candidate 
JOIN Party ON Candidate.party = Party.id
JOIN Ward ON Candidate.ward = Ward.id
WHERE Party.name = 'Green') AS a
JOIN (
SELECT SUM(votes) AS bvotes, Ward.name AS bname
FROM Candidate
JOIN Party ON Candidate.party = Party.id
JOIN Ward ON Candidate.ward = Ward.id
GROUP BY Ward.name) AS b
ON a.aname = b.bname;

-- !question8

SELECT gward AS ward_name, (gvotes-lvotes)/Ward.electorate*100 AS rel, (gvotes-lvotes) AS abs FROM
(SELECT votes AS gvotes, Ward.name AS gward
FROM Candidate
JOIN Party ON Candidate.party = Party.id
JOIN Ward ON Candidate.ward = Ward.id
WHERE Party.name = 'Green') AS g
JOIN 
(SELECT votes AS lvotes, Ward.name AS lward
FROM Candidate
JOIN Party ON Candidate.party = Party.id
JOIN Ward ON Candidate.ward = Ward.id
WHERE Party.name = 'Labour') AS l 
ON g.gward = l.lward
JOIN Ward ON l.lward = Ward.name
WHERE gvotes > lvotes;

-- !end
