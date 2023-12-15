# 7. Get the number of days with precipitation above 1 inches in San Antonio 
 select count(*) as "The Precip_Number"
 from weatherdatabase.`texas daily weather data 2022`
 where Precipitation > 1 and  city_name = "san antonio";
 
 # 11. Get the average temperature, precipitation, humidity, wind speed, and daylight hours for Houston
 select City_Name,
     AVG(Temperature) AS Avg_Temperature,
     AVG(Precipitation) AS Avg_Precipitation,
     AVG(Humidity) AS Avg_Humidity,
     AVG(Wind_Speed) AS Avg_Wind_Speed,
     AVG(Daylight_Hours) AS Avg_Daylight_Hours
from weatherdatabase.`texas daily weather data 2022`
where City_Name = "Houston"
group by city_name;

#12. Find the days with the highest precipitation for each city
 SELECT City_Name, D_Date, Precipitation
FROM (
   SELECT City_Name, D_Date, Precipitation,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Precipitation DESC) AS rn
    FROM weatherdatabase.`texas daily weather data 2022`
 ) ranked
 WHERE rn = 1;

# 13. Calculate the total precipitation for each city in January
select city_name, sum(precipitation) as Total_Precipitation
from weatherdatabase.`texas daily weather data 2022`
where d_date like "%/1/%"
group by city_name;

# 19. Retrieve the date and precipitation for days with significant rainfall (more than 0.5 inches) for Houston
SELECT City_Name, D_Date, Precipitation
FROM weatherdatabase.`texas daily weather data 2022`
WHERE City_Name = 'Houston' AND Precipitation > 0.5;

# 21. Find the cities where it rained on consecutive days (at least two days in a row)
SELECT DISTINCT w1.City_Name
FROM weatherdatabase.`texas daily weather data 2022` w1
JOIN weatherdatabase.`texas daily weather data 2022` w2 ON w1.City_Name = w2.City_Name AND w2.D_Date - w1.D_Date = 1 
WHERE w1.Precipitation > 0 AND w2.Precipitation > 0;

# 30. Get the average temperature, precipitation, humidity, wind speed, and daylight hours for Dallas with descriptions

SELECT City_Name, 
       AVG(Temperature) AS avg_temperature,
       CASE 
           WHEN AVG(Temperature) >= 90 THEN 'Hot'
           WHEN AVG(Temperature) >= 80 THEN 'Warm'
           WHEN AVG(Temperature) >= 60 THEN 'Mild'
           WHEN AVG(Temperature) >= 40 THEN 'Cool'
           ELSE 'Cold'
       END AS description_avg_temperature,
       AVG(Precipitation) AS avg_precipitation,
       CASE 
           WHEN AVG(Precipitation) >= 0.5 THEN 'Wet'
           WHEN AVG(Precipitation) >= 0.1 THEN 'Drizzly'
           ELSE 'Dry'
       END AS avg_precipitation_description,
       AVG(Humidity) AS avg_humidity,
       CASE 
           WHEN AVG(Humidity) >= 80 THEN 'High'
           WHEN AVG(Humidity) >= 60 THEN 'Moderate'
           ELSE 'Low'
       END AS avg_humidity_description,
       AVG(Wind_Speed) AS avg_wind_speed,
       CASE 
           WHEN AVG(Wind_Speed) >= 10 THEN 'Windy'
           WHEN AVG(Wind_Speed) >= 5 THEN 'Breezy'
           ELSE 'Calm'
       END AS avg_wind_speed_description,
       AVG(Daylight_Hours) AS avg_daylight_hours,
       CASE 
           WHEN AVG(Daylight_Hours) >= 12 THEN 'Long'
           WHEN AVG(Daylight_Hours) >= 10 THEN 'Average'
           ELSE 'Short'
       END AS avg_daylight_hours_description
FROM weatherdatabase.`texas daily weather data 2022`
WHERE City_Name = 'Dallas'
GROUP BY City_Name;

# 31. Find the days with the highest precipitation for each city with descriptions:

SELECT City_Name,
       D_Date,
       Precipitation,
       CASE 
           WHEN Precipitation >= 2.0 THEN 'Heavy Rain'
           WHEN Precipitation >= 1.0 THEN 'Moderate Rain'
           WHEN Precipitation >= 0.1 THEN 'Light Rain'
           ELSE 'No Significant Rain'
       END AS Precipitation_Description
FROM (
    SELECT City_Name, D_Date, Precipitation,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Precipitation DESC) AS RowNum
    FROM weatherdatabase.`texas daily weather data 2022`
    WHERE City_Name IN ('Austin', 'Dallas', 'Houston', 'San Antonio', 'Pecos', 'El Paso', 'Midland')
) Ranked
WHERE RowNum = 1;

# 32. Calculate the total precipitation for each city in January with descriptions

SELECT City_Name,
       SUM(Precipitation) AS Total_Precipitation,
       CASE 
       
           WHEN SUM(Precipitation) >= 25 THEN 'Heavy Rainfall'
           WHEN SUM(Precipitation) >= 15 THEN 'Moderate Rainfall'
           WHEN SUM(Precipitation) >= 5 THEN 'Light Rainfall'
           ELSE 'Very Low Precipitation'
       END AS Precipitation_Description
FROM weatherdatabase.`texas daily weather data 2022`
WHERE City_Name IN ('Austin', 'Dallas', 'Houston', 'San Antonio', 'Pecos', 'El Paso', 'Midland')
      AND D_Date like "%/1/%"
GROUP BY City_Name;

# 38. Retrieve the date and precipitation for days with significant rainfall (more than 4 inches) for Houston with descriptions:

SELECT D_Date,
       Precipitation,
       CASE 
           WHEN Precipitation > 4 THEN 'Significant Rainfall'
           ELSE 'No Significant Rainfall'
       END AS Precipitation_Description
FROM weatherdatabase.`texas daily weather data 2022`
WHERE City_Name = 'Houston' AND Precipitation > 4;

# 39. Get the average temperature and humidity for each city on weekdays with descriptions:

SELECT City_Name,
       AVG(Temperature) AS Avg_Temperature,
       CAST(AVG(0.5 * (Temperature + 61.0 + (Temperature - 68.0) * 1.2 + Humidity * 0.094)) AS DECIMAL(10,0)) AS Feels_Like,
       CASE 
           WHEN AVG(Temperature) >= 90 THEN 'Hot'
           WHEN AVG(Temperature) >= 80 THEN 'Warm'
           WHEN AVG(Temperature) >= 60 THEN 'Mild'
           WHEN AVG(Temperature) >= 40 THEN 'Cool'
           ELSE 'Cold'
       END AS Avg_Temperature_Description,
       avg(Humidity) as Avg_Humidity,
       CASE 
           WHEN AVG(Humidity) >= 80 THEN 'High'
           WHEN AVG(Humidity) >= 60 THEN 'Moderate'
           ELSE 'Low'
       END AS Avg_Humidity_Description
FROM weatherdatabase.`texas daily weather data 2022`
WHERE WEEKDAY(STR_TO_DATE(D_Date, '%m/%d/%Y')) BETWEEN 0 AND 4 -- Weekdays (Monday to Friday)
GROUP BY City_Name;

# 41. Find the cities where it rained on consecutive days (at least two days in a row) with descriptions

WITH RainData AS (
    SELECT City_Name, D_Date, Precipitation,
           LAG(Precipitation, 1) OVER (PARTITION BY City_Name ORDER BY D_Date) AS PrevDayPrecipitation
    FROM weatherdatabase.`texas daily weather data 2022`
)

SELECT RD.City_Name,
       SUM(RD.Precipitation) AS Total_Rain,
       COUNT(*) AS Consecutive_Days
FROM RainData RD
WHERE RD.Precipitation > 0
GROUP BY RD.City_Name
HAVING MAX(CASE WHEN RD.Precipitation > 0 AND RD.PrevDayPrecipitation > 0 THEN 1 ELSE 0 END) = 1;

# 45. Calculate the average temperature for each city, considering only days when it rained with descriptions:

WITH RainData AS (
    SELECT City_Name, D_Date, Temperature, Humidity, Precipitation
    FROM weatherdatabase.`texas daily weather data 2022`
    WHERE Precipitation > 0
),

AvgTempData AS (
    SELECT City_Name, AVG(Temperature) AS Avg_Temperature, 
           AVG(0.5 * (Temperature + 61.0 + (Temperature - 68.0) * 1.2 + Humidity * 0.094)) AS Feels_Like,
           SUM(Precipitation) AS Total_Rain
    FROM RainData
    GROUP BY City_Name
)

SELECT RD.City_Name, RD.D_Date, RD.Precipitation, AD.Avg_Temperature, AD.Feels_Like, AD.Total_Rain,
       CASE 
           WHEN AD.Avg_Temperature >= 90 THEN 'Hot'
           WHEN AD.Avg_Temperature >= 80 THEN 'Warm'
           WHEN AD.Avg_Temperature >= 60 THEN 'Mild'
           WHEN AD.Avg_Temperature >= 40 THEN 'Cool'
           ELSE 'Cold'
       END AS Temperature_Description
FROM AvgTempData AD
JOIN RainData RD ON AD.City_Name = RD.City_Name;