/*
///$tab Kalendorius
tmp:
LOAD Distinct [Task Date] as Date
Resident data;


[Kalendorius]:
LOAD
	Date 													AS [Task Date],
    Date													as Data,
	YEAR(Date) 												AS Metai,
	DUAL('H' & CEIL(MONTH(Date)/6),   CEIL(MONTH(Date)/6)) 	AS [Pusmetis],
	DUAL('Q'& CEIL(MONTH(Date)/3), CEIL(MONTH(Date)/3)) 	AS [Ketvirtis],
	NUM(MONTH(Date), '00') 									AS [Mėnuo],
	Week(Date,0,0) 											AS [Savaitė],
    WeekDay(Date)											as [Savaitės diena],
	DUAL(YEAR(Date) & '-' & NUM(MONTH(Date), '00'), YEAR(Date) * 100 + Month(Date)) 				AS [Metai, mėnuo],
	DUAL(WEEKYEAR(Date) & '-W' & NUM(Week(Date), '00'), WEEKYEAR(Date) * 100 + Week(Date)) 			AS [Metai, savaitė],
	DUAL(YEAR(Date) & '-Q' & NUM(CEIL(MONTH(Date)/3), '0'), YEAR(Date) * 10 + CEIL(MONTH(Date)/3)) 	AS [Metai, ketvirtis]
RESIDENT tmp;

*/

{{ config(alias='ENW_Kalendorius') }}


WITH tmp AS (
    SELECT DISTINCT "Task Date" AS Date
    FROM {{ ref('ENW_GoldTours_data') }}
)

SELECT
    Date                                                                                  AS "Task Date",
    Date                                                                                  AS "Data",
    EXTRACT(YEAR FROM Date)                                                               AS "Metai",
    CONCAT('H', CEIL(EXTRACT(MONTH FROM Date) / 6))                                       AS "Pusmetis",
    CONCAT('Q', CEIL(EXTRACT(MONTH FROM Date) / 3))                                       AS "Ketvirtis",
    MONTH (Date)                                                                          AS "Mėnuo",
    week(Date)                                                                            as "Savaitė",
    CASE dayofweek(Date)
        WHEN 1 THEN 'Pr'  -- Pirmadienis
        WHEN 2 THEN 'An'  -- Antradienis
        WHEN 3 THEN 'Tr'  -- Trečiadienis
        WHEN 4 THEN 'Kt'  -- Ketvirtadienis
        WHEN 5 THEN 'Pn'  -- Penktadienis
        WHEN 6 THEN 'Št'  -- Šeštadienis
        WHEN 0 THEN 'Sk'  -- Sekmadienis (Snowflake pradeda savaitę nuo sekmadienio)
    END                                                                                   AS "Savaitės diena",
    CONCAT(EXTRACT(YEAR FROM Date), '-', LPAD(EXTRACT(MONTH FROM Date)::TEXT, 2, '0'))    AS "Metai, mėnuo",
    CONCAT(EXTRACT(YEAR FROM Date), '-W',  week(Date))                                    as "Metai, savaitė",
    CONCAT(EXTRACT(YEAR FROM Date), '-Q', CEIL(EXTRACT(MONTH FROM Date) / 3))             AS "Metai, ketvirtis"
FROM tmp
where Date  is not null