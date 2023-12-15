# 2. Get the average temperature for Dallas
 select avg(temperature) from weatherdatabase.`texas daily weather data 2022`
 where City_Name = "Dallas";
# 3. Find the maximum temperature in Texas recorded on 8/8/2022
 select max(temperature) from weatherdatabase.`texas daily weather data 2022`
 where D_Date = "8/8/2022";
 # 6. Retrieve the weather data for the hottest day
 SELECT * FROM weatherdatabase.`texas daily weather data 2022` 
  WHERE temperature = (SELECT MAX(temperature) FROM weatherdatabase.`texas daily weather data 2022`);
 # 9. Retrieve the average temperature for each city
 select City_Name, avg(temperature) from weatherdatabase.`texas daily weather data 2022`
 group by City_Name;
 # 10. Retrieve weather data for Pecos on 7/15/2022
 select city_name, d_date, temperature, humidity, wind_speed, Daylight_hours
 from weatherdatabase.`texas daily weather data 2022`
 where d_date = "7/15/2022" and city_name = "Pecos";
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
# 14. Retrieve the date and temperature for the coldest day in each city
SELECT City_Name, D_Date, Temperature 
FROM (
   SELECT City_Name, D_Date, Temperature,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Temperature asc) AS rn
    FROM weatherdatabase.`texas daily weather data 2022`
) ranked
WHERE rn = 1;
# 17. Get the maximum temperature recorded for each city
select city_name, max(temperature) as Max_Temperature
from weatherdatabase.`texas daily weather data 2022`
group by City_Name;

# 18. Find the cities where the temperature exceeded 90 degrees Fahrenheit on 8/15/2022
SELECT City_Name
FROM weatherdatabase.`texas daily weather data 2022`
WHERE Temperature > 90 AND D_Date = '8/15/2022';
# 23. Retrieve the date and temperature for days when the temperature increased by more than 10 degrees Fahrenheit compared to the previous day
SELECT w1.City_Name, w1.D_Date, w1.Temperature
FROM weatherdatabase.`texas daily weather data 2022` w1
JOIN weatherdatabase.`texas daily weather data 2022` w2 ON w1.City_Name = w2.City_Name AND w1.D_Date - w2.D_Date = 1
WHERE w1.Temperature - w2.Temperature > 10;

# 24. Find the cities where the temperature was within 5 degrees Fahrenheit of the average temperature for the entire dataset on 3.7.2022
SELECT w.City_Name
FROM weatherdatabase.`texas daily weather data 2022` w
JOIN (
    SELECT AVG(Temperature) AS avg_temp
    FROM weatherdatabase.`texas daily weather data 2022`
) AS avg_temps
WHERE ABS(w.Temperature - avg_temps.avg_temp) <= 5
AND w.D_Date = '3/7/2022';

# 25. Calculate the average temperature for each city, considering only days when it rained
SELECT City_Name, AVG(Temperature) AS Avg_Temperature
FROM weatherdatabase.`texas daily weather data 2022`
WHERE Precipitation > 0
GROUP BY City_Name;

# 27. Get the highest temperature and corresponding date for each city

SELECT City_Name, D_Date, Temperature
FROM (
    SELECT City_Name, D_Date, Temperature,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Temperature DESC) AS rn
    FROM weatherdatabase.`texas daily weather data 2022`
) ranked
WHERE rn = 1;

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