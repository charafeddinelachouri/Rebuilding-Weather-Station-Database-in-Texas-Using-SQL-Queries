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

# 16. Retrieve the date and daylight hours for the day with the longest daylight in each city
SELECT City_Name, D_Date, Daylight_Hours
FROM (
    SELECT City_Name, D_Date, Daylight_Hours,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Daylight_Hours DESC) AS rn
    FROM weatherdatabase.`texas daily weather data 2022`
) ranked
WHERE rn = 1;

# 22. Get the date and daylight hours for the shortest day in each city
SELECT City_Name, D_Date, Daylight_Hours
FROM (
   SELECT City_Name, D_Date, Daylight_Hours,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Daylight_Hours ASC) AS rn
    FROM weatherdatabase.`texas daily weather data 2022`
) ranked
WHERE rn = 1;

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

