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



