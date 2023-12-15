# 29. Retrieve weather data for Houston on 8/8/2022 with temperature descriptions and the heat index :

SELECT City_Name, D_Date, Temperature, 
       CASE 
           WHEN Temperature >= 90 THEN 'Hot'
           WHEN Temperature >= 80 THEN 'Warm'
           WHEN Temperature >= 60 THEN 'Mild'
           WHEN Temperature >= 40 THEN 'Cool'
           ELSE 'Cold'
       END AS Temperature_Description,
       -- Calculate Heat Index
       0.5 * (Temperature + 61.0 + (Temperature - 68.0) * 1.2 + Humidity * 0.094) AS Feels_Like,
       CONCAT(Precipitation, ' inches') AS Precipitation,
       CONCAT(Humidity, '%') AS Humidity,
       CONCAT(Wind_Speed, ' mph') AS Wind_Speed,
       CONCAT(Daylight_Hours, ' hours') AS Daylight_Hours
FROM weatherdatabase.`texas daily weather data 2022`
WHERE City_Name = 'Houston' AND D_Date = '8/8/2022';

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

# 33. Retrieve the date and temperature for the coldest day in each city with descriptions with heat index:

WITH ColdestDays AS (
    SELECT City_Name, D_Date, Temperature, Humidity,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Temperature ASC) AS RowNum
    FROM weatherdatabase.`texas daily weather data 2022`
)

SELECT CD.City_Name, CD.D_Date, CD.Temperature,
       0.5 * (Temperature + 61.0 + (Temperature - 68.0) * 1.2 + Humidity * 0.094) AS Feels_Like,
       CASE 
           WHEN CD.Temperature >= 90 THEN 'Hot'
           WHEN CD.Temperature >= 80 THEN 'Warm'
           WHEN CD.Temperature >= 60 THEN 'Mild'
           WHEN CD.Temperature >= 40 THEN 'Cool'
           ELSE 'Cold'
       END AS Temperature_Description
FROM ColdestDays CD
WHERE RowNum = 1;

# 34. Find the average humidity and wind speed for each city in March with descriptions

SELECT City_Name,
       AVG(Humidity) AS Avg_Humidity,
       CASE 
           WHEN AVG(Humidity) >= 70 THEN 'High Humidity'
           WHEN AVG(Humidity) >= 50 THEN 'Moderate Humidity'
           ELSE 'Low Humidity'
       END AS Humidity_Description,
       AVG(Wind_Speed) AS Avg_Wind_Speed,
       CASE 
           WHEN AVG(Wind_Speed) >= 10 THEN 'Windy'
           WHEN AVG(Wind_Speed) >= 5 THEN 'Breezy'
           ELSE 'Calm'
       END AS Wind_Speed_Description
FROM weatherdatabase.`texas daily weather data 2022`
WHERE MONTH(STR_TO_DATE(D_Date, '%m/%d/%Y')) = 3
GROUP BY City_Name;

# 35.Retrieve the date and daylight hours for the day with the longest daylight in each city with descriptions

WITH LongestDaylightDays AS (
    SELECT City_Name, D_Date, Daylight_Hours,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Daylight_Hours DESC) AS RowNum
    FROM weatherdatabase.`texas daily weather data 2022`
)

SELECT LDD.City_Name, LDD.D_Date, LDD.Daylight_Hours,
       CASE 
           WHEN LDD.Daylight_Hours >= 12 THEN 'Long Daylight'
           WHEN LDD.Daylight_Hours >= 10 THEN 'Average Daylight'
           ELSE 'Short Daylight'
       END AS Daylight_Description
FROM LongestDaylightDays LDD
WHERE RowNum = 1;

# 36.Get the maximum temperature recorded for each city with descriptions:

SELECT City_Name,
       MAX(Temperature) AS Max_Temperature,
        round(0.5 * (MAX(Temperature) + 61.0 + (MAX(Temperature) - 68.0) * 1.2 + AVG(Humidity) * 0.094), 0) AS Feels_Like,
       CASE 
           WHEN MAX(Temperature) >= 90 THEN 'Hot'
           WHEN MAX(Temperature) >= 80 THEN 'Warm'
           WHEN MAX(Temperature) >= 60 THEN 'Mild'
           WHEN MAX(Temperature) >= 40 THEN 'Cool'
           ELSE 'Cold'
       END AS Temperature_Description
FROM weatherdatabase.`texas daily weather data 2022`
GROUP BY City_Name;

# 37. Find the cities where the temperature exceeded 110 degrees Fahrenheit on a specific date with descriptions

SELECT City_Name,
       D_Date,
       Temperature,
       round(0.5 * (Temperature + 61.0 + (Temperature - 68.0) * 1.2 + Humidity * 0.094), 0) AS Feels_Like,
       CASE 
           WHEN Temperature >= 90 THEN 'Hot'
           WHEN Temperature >= 80 THEN 'Warm'
           WHEN Temperature >= 60 THEN 'Mild'
           WHEN Temperature >= 40 THEN 'Cool'
           ELSE 'Cold'
       END AS Temperature_Description
FROM weatherdatabase.`texas daily weather data 2022`
WHERE Temperature > 110
order by Temperature desc;

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

# 40. Retrieve the date and wind speed for the windiest day in each city with descriptions

WITH WindiestDays AS (
    SELECT City_Name, D_Date, Wind_Speed,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Wind_Speed DESC) AS RowNum
    FROM weatherdatabase.`texas daily weather data 2022`
)

SELECT WD.City_Name, WD.D_Date, WD.Wind_Speed,
       CASE 
           WHEN WD.Wind_Speed >= 15 THEN 'Very Windy'
           WHEN WD.Wind_Speed >= 10 THEN 'Windy'
           WHEN WD.Wind_Speed >= 5 THEN 'Breezy'
           ELSE 'Calm'
       END AS Wind_Speed_Description
FROM WindiestDays WD
WHERE RowNum = 1;

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

# 42. Get the date and daylight hours for the shortest day in each city with descriptions:

WITH DaylightData AS (
    SELECT City_Name, D_Date, Daylight_Hours,
           RANK() OVER (PARTITION BY City_Name ORDER BY Daylight_Hours ASC) AS RankShortestDay
    FROM weatherdatabase.`texas daily weather data 2022`
)

SELECT DD.City_Name, DD.D_Date, DD.Daylight_Hours,
       CASE 
           WHEN DD.RankShortestDay = 1 THEN 'Shortest Day'
       END AS Daylight_Description
FROM DaylightData DD
WHERE DD.RankShortestDay = 1;

# 43. Retrieve the date and temperature for days when the temperature increased by more than 10 degrees Fahrenheit compared to the previous day in San Antonio city with descriptions

WITH TemperatureData AS (
    SELECT City_Name, D_Date, Temperature,
           LAG(Temperature, 1) OVER (PARTITION BY City_Name ORDER BY D_Date) AS PrevDayTemperature
    FROM weatherdatabase.`texas daily weather data 2022`
    WHERE City_Name = 'San Antonio'
)

SELECT TD.City_Name, TD.D_Date, TD.Temperature,
       CASE 
           WHEN TD.Temperature - TD.PrevDayTemperature > 10 THEN 'Temperature Increased by More Than 10°F'
       END AS Temperature_Description
FROM TemperatureData TD
WHERE TD.Temperature - TD.PrevDayTemperature > 10;

# 44. Find the cities where the temperature was within 5 degrees Fahrenheit of the average temperature for the entire dataset on a 2/18/2022 with descriptions
WITH AvgTemp AS (
    SELECT AVG(Temperature) AS Average_Temperature
    FROM weatherdatabase.`texas daily weather data 2022`
),

TemperatureData AS (
    SELECT City_Name, D_Date, Temperature,
           (SELECT Average_Temperature FROM AvgTemp) AS Average_Temperature,
           CASE 
               WHEN Temperature >= (SELECT Average_Temperature FROM AvgTemp) - 5
                AND Temperature <= (SELECT Average_Temperature FROM AvgTemp) + 5 THEN 'Within 5°F of Average'
           END AS Temperature_Description
    FROM weatherdatabase.`texas daily weather data 2022`
    WHERE D_Date = '2/18/2022'
)

SELECT TD.City_Name, TD.Temperature, TD.Average_Temperature, TD.Temperature_Description
FROM TemperatureData TD
WHERE TD.Temperature_Description IS NOT NULL;

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
