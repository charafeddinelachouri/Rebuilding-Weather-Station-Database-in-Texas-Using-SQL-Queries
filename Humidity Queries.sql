# 5. Find the average humidity in Texas for the month of February
 Select avg(Humidity) as Average_Humidity
 from weatherdatabase.`texas daily weather data 2022`
 Where D_Date like "%/2/%";
 
 # 8. Find the date with the lowest humidity for Midland
 select D_Date as Lowest_Humidity_Date from weatherdatabase.`texas daily weather data 2022` 
 where city_name = "Midland"
 order by Humidity asc limit 1;
 
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

# 15. Find the average humidity and wind speed for each city in 2022
select city_name, avg(humidity) as Avg_Humidity, avg(wind_speed) as Avg_Wind_Speed
from weatherdatabase.`texas daily weather data 2022`
where d_date like "%2022"
group by City_Name;
# 16. Retrieve the date and daylight hours for the day with the longest daylight in each city
SELECT City_Name, D_Date, Daylight_Hours
FROM (
    SELECT City_Name, D_Date, Daylight_Hours,
           ROW_NUMBER() OVER (PARTITION BY City_Name ORDER BY Daylight_Hours DESC) AS rn
    FROM weatherdatabase.`texas daily weather data 2022`
) ranked
WHERE rn = 1;

# 26. Retrieve the date and humidity for days when the humidity was above 80% in Houston

 SELECT City_Name, D_Date, Humidity
 FROM weatherdatabase.`texas daily weather data 2022`
 WHERE City_Name = 'Houston' AND Humidity > 80;
 
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

