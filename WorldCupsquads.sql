--SQL Project
--FIFA World Cup 2022 Squads Dataset Exploration

--As a soccer/football enthusiast, I have always been fascinated by how the data can bring useful insights to that data 
-- to the sports industry. 

--Lets begin by looking at our dataset
SELECT *
FROM WorldCup2022.dbo.[2022worldcupsquads] ; 

--At a first glance, the dataset looks great. No issues with missing values, no inaccurate data. We have to keep in mind
--that the dataset contains information up until the date before the world cup started. We are currently in February 2023 and some
--players have changed teams. 

--Lets explore our dataset by looking at some interesting questions: 

--Question 1: Which players scored the most WCGoals before the start of the WorldCup 2022?

SELECT TOP (5) Player, [WC Goals]
FROM WorldCup2022.dbo.[2022worldcupsquads]
ORDER BY [WC Goals] DESC ; 

--Thomas Muller has scored the most WC goals, 10 to be exact. Here we have an additional information that 3/5 of our top players are the current
--captains of their national team.

--Question 2: How many midfielders that play in England ("Premier League") have scored more than one goal with their National Team? 

SELECT COUNT(*) as NumMidfieldersEnglandScorers
FROM WorldCup2022.dbo.[2022worldcupsquads]
WHERE Position = 'Midfielder' AND League = 'England' AND Goals > 1;

--We do have 40 midfielders that have scored at least one goal. Premier League is arguably the best league in the world where the best players compete at, 
--which makes sense to have a relatively high number. Midfielder is a crucial position on the field that can add goal contribution to a team. 
--It connects the defense with the offense. If you have players that can We can use different conditions within the WHERE clause
--and answer multiple questions at the same time.

--Question 3: How many Leagues participated in the tournament? 

SELECT DISTINCT League
FROM WorldCup2022.dbo.[2022worldcupsquads] ;

--We had players representing 44 different professional Leagues, which shows the wide variety of talent from all around the world and why almost all
--the professional Leagues stopped playing in order to watch the tournament. The DISTINCT of SQL function helps us to identify only different values within our table.

--Question 4: Which club has the most players in the FIFA World Cup 2022?
SELECT TOP (5) Club, COUNT(*) AS NumPlayers
FROM WorldCup2022.dbo.[2022worldcupsquads] 
GROUP BY Club
ORDER BY NumPlayers DESC; 

--Bayern Munich had a total number of 17 players in the world cup, followed by Barcelona and Manchester City with 16.
--An impressive number!

--Question 5: Which league had the most players?

SELECT TOP(10)League, COUNT(League) AS TopLeagueCount
FROM WorldCup2022.dbo.[2022worldcupsquads]
GROUP BY League
ORDER BY TopLeagueCount DESC ; 

--Similar to the question before, the League with the most players by a big margin is "England". 
--This shows why it's worth exploring the Premier League in our analysis as we did before. 
--Not surprisingly, the top 5 leagues are all from Europe, where the highest level of football/soccer is played.'. 


--Question 6: What’s the average age of players within each squad? 

SELECT Team, 
 MIN(Age) as Minimum,
 MAX(CASE WHEN Quartile = 1 THEN Age END) As Q1,
 MAX(CASE WHEN Quartile = 2 THEN Age END) AS Median,
 MAX(CASE WHEN Quartile = 3 THEN Age END) AS Q3,
 MAX(Age) as Maximum

FROM (
 SELECT Team, Age,
 NTILE(4) OVER (PARTITION BY Team ORDER BY Age) AS Quartile
 FROM WorldCup2022.dbo.[2022worldcupsquads]) w

GROUP BY Team
ORDER BY Median; 

--When we are trying to find the average age is a data that is easily skewed so one of the best ways to measure it is median. 
--I had to create a subqueary and use CASE command as the data set is pretty large and it gives us an easier way to break it down 
--while maintaining logical consistency. As we can see in the table below, Ecuador, Ghana, and 
--USA have the lowest Median with 24 and Belgium the lodesr with 29. 

--Question 7: What is the percentage of the players that play for their domestic League?

CREATE VIEW NationalPlayers AS
SELECT Team, COUNT(*) AS NumNationalPlayers
FROM WorldCup2022.dbo.[2022worldcupsquads]
WHERE League = Team
GROUP BY Team;

CREATE VIEW AllPlayers AS
SELECT Team, COUNT(*) AS NumAllPlayers
FROM WorldCup2022.dbo.[2022worldcupsquads]
GROUP BY Team;

SELECT NationalPlayers.Team, NumNationalPlayers, NumAllPlayers, (NumNationalPlayers * 100 / NumAllPlayers) AS Percentage
FROM NationalPlayers
JOIN AllPlayers ON NationalPlayers.Team = AllPlayers.Team
ORDER BY Percentage DESC;

--This is by far the hardest question of the project as I had to improvise on how to connect the players and the country.
--I used two different views and then join them together and creating a new variable "Percentage". As we can see on the table,
-- there are two teams that had all of their players from their domestic League: Qatar & Saudi Arabia. On the other hand,
--Argentina (Winner!) and Serbia had only one of their players (3%) playing in the domestic league. 