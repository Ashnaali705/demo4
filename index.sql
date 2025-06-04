-- Create database
CREATE DATABASE NetflixTVShowsDB;
USE NetflixTVShowsDB;

-- Create table for General
CREATE TABLE General (
    General_ID INT AUTO_INCREMENT PRIMARY KEY,
    General_Name VARCHAR(100) NOT NULL UNIQUE
);

-- Create table for TV Shows
CREATE TABLE TVShows (
    Show_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ReleaseYear YEAR NOT NULL,
    General_ID INT,
    Language VARCHAR(100) NOT NULL,
    Rating DECIMAL(2,1) CHECK (Rating >= 0.0 AND Rating <= 10.0),
    FOREIGN KEY (General_ID) REFERENCES General(General_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create table for seasons
CREATE TABle seasons (
    seasons_ID INT AUTO_INCREMENT PRIMARY KEY,
    Show_ID INT,
    seasons_Number INT NOT NULL,
    ReleaseDate DATE,
    FOREIGN KEY (Show_ID) REFERENCES TVShows(Show_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create table for Episodes
CREATE TABLE Episodes (
    Episode_ID INT AUTO_INCREMENT PRIMARY KEY,
    seasons_ID INT,
    Episode_Title VARCHAR(255) NOT NULL,
    Duration INT CHECK (Duration > 0), -- in minutes
    AirDate DATE,
    FOREIGN KEY (seasons_ID) REFERENCES seasons(seasons_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Insert General
INSERT INTO General (General_Name) VALUES
('Drama'),
('Comedian'),
('Thriller'),
('Documentary'),
('crime');

-- Insert TV Shows
INSERT INTO TVShows (Title, ReleaseYear, General_ID, Language, Rating) VALUES
('Stranger Things', 2016, 5, 'English', 8.7),
('The Crown', 2016, 1, 'English', 8.6),
('Narcos', 2015, 3, 'japan', 8.8),
('Our Planet', 2019, 4, 'English', 9.3),
('Brooklyn Nine-Nine', 2013, 2, 'English', 8.4);

-- Insert seasons
INSERT INTO seasons (Show_ID, seasons_Number, ReleaseDate) VALUES
(1, 1, '2016-07-15'),
(1, 2, '2017-10-27'),
(2, 1, '2016-11-04'),
(3, 1, '2015-08-28'),
(4, 1, '2019-04-05'),
(5, 1, '2013-09-17'),
(5, 2, '2014-09-28');

-- Insert Episodes
INSERT INTO Episodes (seasons_ID, Episode_Title, Duration, AirDate) VALUES
(1, 'Chapter One: The Vanishing', 48, '2016-07-15'),
(1, 'Chapter Two: The Weirdo', 55, '2016-07-15'),
(2, 'MADMAX', 46, '2017-10-27'),
(3, 'Wolferton Splash', 57, '2016-11-04'),
(4, 'Descenso', 57, '2015-08-28'),
(5, 'One Planet', 50, '2019-04-05'),
(6, 'Pilot', 22, '2013-09-17'),
(7, 'Undercover', 22, '2014-09-28');


-- Sample Analysis Questions:
-- 1. CRUD: Update rating for a show
UPDATE TVShows SET Rating = 9.0 WHERE Title = 'Stranger Things';

-- 2. Aggregate with GROUP BY and HAVING: Average rating of shows by genre
SELECT G.General_Name, AVG(T.Rating) AS AvgRating
FROM TVShows T
JOIN General G ON T.General_ID = G.General_ID
GROUP BY G.General_Name
HAVING AVG(T.Rating) > 8.5;

-- 3. WHERE + ORDER BY: List shows released after 2015 ordered by rating
SELECT Title, ReleaseYear, Rating
FROM TVShows
WHERE ReleaseYear > 2015
ORDER BY Rating DESC;

-- 4. INNER JOIN: List all episodes with show titles, create view for it as AllEpisodes
CREATE VIEW All_Episodes AS
SELECT T.Title, S.Seasons_Number, E.Episode_Title, E.Duration
FROM Episodes E
JOIN Seasons S ON E.Seasons_ID = S.Seasons_ID
JOIN TVShows T ON S.Show_ID = T.Show_ID;

-- 5. LEFT JOIN: List all shows with or without any seasons create view for it as SeasonsInfo
CREATE VIEW Seasons_Info AS
SELECT T.Title, S.Seasons_Number
FROM TVShows T
LEFT JOIN Seasons S ON T.Show_ID = S.Show_ID
ORDER BY T.Title;