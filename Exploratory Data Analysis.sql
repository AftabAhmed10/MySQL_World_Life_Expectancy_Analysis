# World Life Expectancy Project (Exploratory Data Analysis)

USE world_life_expectancy;

SELECT *
FROM world_life_expectancy;

# Calculate minimum, maximum, and increase in life expectancy over 15 years by country
SELECT Country,
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC
;

#  Calculate average life expectancy by year
SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year ASC
;


#Finding Correlations (Negative/Positive) between different columns

# Retrieve all records again for correlation analysis
SELECT *
FROM world_life_expectancy;

# Calculate average life expectancy and GDP by country
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Expectancy > 0
AND GDP > 0
ORDER BY GDP DESC
;

# Compare life expectancy between high and low GDP countries
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END),1) AS High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END),1) AS Low_GDP_Life_Expectancy
FROM world_life_expectancy
;


SELECT *
FROM world_life_expectancy;

# Calculate average life expectancy by status (Developed/Developing)
SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

# Count distinct countries and calculate average life expectancy by status
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;


# Calculate average life expectancy and BMI by country
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Expectancy, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Expectancy > 0
AND BMI > 0
ORDER BY BMI ASC
;


# Analyze adult mortality rates for Pakistan with a rolling total calculation
SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE COUNTRY LIKE 'Pakistan';


SELECT DISTINCT Status
FROM world_life_expectancy
WHERE Country = 'Pakistan';
