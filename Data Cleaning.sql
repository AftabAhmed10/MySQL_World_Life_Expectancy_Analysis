# World Life Expectancy Project (Data Cleaning)

USE world_life_expectancy;

SELECT *
FROM world_life_expectancy;

#Removing Duplicates
# Identify duplicate entries based on Country and Year
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

# Select rows with duplicate entries for review
SELECT *
FROM (
	SELECT Row_ID,
    CONCAT(Country, Year),
	ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
	) AS Row_Table
WHERE Row_Num > 1
;

# Delete duplicate records from the life expectancy table
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
		FROM (
			SELECT Row_ID,
            CONCAT(Country, Year),
			ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
			FROM world_life_expectancy
			) AS Row_Table
	WHERE Row_Num > 1
    )
;


#Working with NULL/ Blank Values
# Retrieve records with blank Status values for review
SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

# Get distinct Status values excluding blanks
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

# List distinct countries with non-blank Status values
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status <> ''
;

#  List countries with 'Developing' status
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;


#It not works we have to use JOIN for this
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Status IN (SELECT DISTINCT(Country)
				FROM world_life_expectancy
				WHERE Status = 'Developing'
				)
;

# Update blank Status values to 'Developing' using JOIN
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

                
SELECT * 
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

# Update blank Status values to 'Developed' using JOIN
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;


#Life Expectancy

# Retrieve all records from the life expectancy table again for analysis purposes
SELECT * 
FROM world_life_expectancy
;

# Identify records with missing Life Expectancy values for review
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

# Calculate average Life Expectancy using neighboring years for missing data points
SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

# Update missing Life Expectancy values using the average of neighboring years 
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2, 1)
WHERE t1.`Life expectancy` = ''
; 


SELECT * 
FROM world_life_expectancy
;