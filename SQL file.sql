-- Advanced SQL Project -- Spotify Datasets

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA
Select count (*)
from spotify;

Select count (distinct artist)
from spotify;

Select distinct album_type
from spotify;

Select max(duration_min)
from spotify;

Select min(duration_min)
from spotify;

Select *
from spotify
where duration_min = 0;

Delete from spotify 
where duration_min =0;

Select distinct channel 
from spotify;

Select distinct most_played_on
from spotify;



-- -------------------------------
-- Data Analysis -- Easy level
-- -------------------------------


-- Q.1 Retrieve the names of all tracks that have more than 1 billion streams.
Select track
from spotify
where stream > 1000000000;

-- Q.2 List all albums along with their respective artists.
Select album, artist
from spotify;

-- Q.3 Get the total number of comments for tracks where licensed = TRUE.
Select sum(comments)
from spotify
where licensed = TRUE;

-- Q.4 Find all tracks that belong to the album type single.
Select *
from spotify
where album_type = 'single';

-- Q.5 Count the total number of tracks by each artist.
Select artist, count(*) as total_songs
from spotify
group by artist
order by 2;

-- ------------------------------
-- Data Analysis - Medium Level
-- ------------------------------

-- Q.6 Calculate the average danceability of tracks in each album.
Select album, round(avg(danceability)::numeric,2) as avg_danceability
from spotify
group by album
order by 2 desc;

-- Q.7 Find the top 5 tracks with the highest energy values.
Select track, energy
from spotify
order by 2 desc
limit 5;

-- Q.8 List all tracks along with their views and likes where official_video = TRUE.
Select track, sum(views) as total_views, sum(likes) as total_likes
from spotify
where official_video = 'true'
group by 1
order by 2 desc;

-- Q.9 For each album, calculate the total views of all associated tracks.
Select album, track,sum(views)
from spotify
group by 1,2
order by 3 desc;

-- Q.10 Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT track
FROM spotify
GROUP BY track
HAVING 
    SUM(CASE WHEN most_played_on = 'Spotify' THEN stream ELSE 0 END) >
    SUM(CASE WHEN most_played_on = 'Youtube' THEN stream ELSE 0 END);

-- ------------------------------
-- Data analysis -- Advanced level
-- ------------------------------

-- Q.11 Find the top 3 most-viewed tracks for each artist using window functions.

Select artist, track, total_views
from(
	Select artist, 
	track, 
	sum(views) as total_views,
	row_number() over(partition by artist order by sum(views) desc) as rn
	from spotify
	group by 1,2)
where rn<=3;

-- Q.12 Write a query to find tracks where the liveness score is above the average.
Select track, liveness
from spotify
where liveness >(
Select avg(liveness) as avg_liveness
from spotify)
order by 2;

-- Q.13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

With Temp_table as
(Select album,
round(max(energy)::numeric,2) as max_energy,
round(min(energy)::numeric,2) as min_energy
from spotify
group by album) 
Select album,
max_energy - min_energy as Energy_Difference
from Temp_table
order by 2 desc;

-- Q.14 Find tracks where the energy-to-liveness ratio is greater than 1.2
Select track, energy_to_liveness_ratio
from (
Select track, round((energy/liveness)::numeric,2) as energy_to_liveness_ratio
from spotify
where liveness <>0)
where energy_to_liveness_ratio > 1.2
order by 2;

-- Q.15 Calculate the cumulative sum of likes for tracks ordered by views using window functions

select track,
sum(likes) over (order by views) as cumulative_likes
from spotify
order by cumulative_likes desc;






