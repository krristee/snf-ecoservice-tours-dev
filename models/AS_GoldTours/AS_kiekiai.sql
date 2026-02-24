
{{ config(alias='AS_kiekai') }}


 select
    CAST(RouteHistory."RouteHistoryId" as VARCHAR)	                    as "Tour No_",
    CAST(WasteList."NoInAccounting" as VARCHAR)                         AS "No_", 
    Department."Name"                                                   AS "Location Code",
    null                                                                AS "Document No_", /*reikia patikslinimo*/ 
    null                                                                as "_Document No_", /*reikia patikslinimo*/ 
    WasteOrigin."Code"		                                            as "Waste Material Code",
    CAST(null AS NUMBER)			                                    as "Order Line Qty", /*nėr info*/ 
    SUM(IFNULL(PickupHistory."ObjectCount", 0))+SUM(IFNULL(PickupObjects."ObjectCount", 0))   
                                                                        as "Planinis konteinerių kiekis",
    SUM(IFNULL(PickupHistory."ObjectCount", 0))                         as "Konteinerių kiekis",
    SUM(IFNULL(PickupHistory2."ObjectCount", 0))                        as "Served",
    sum(RouteMotorings."TakedCount")           			                as "Quantity",
    CAST(null AS NUMBER)			                                    AS "Gross Weight", -- A.B: Mobiliosios dalies svoris - iš  automobilio atėjusių svorių suma. Lygindavome su faktu. Pasitikslinsiu kokie konkretesni duomenų šaltiniai
    CAST(null AS NUMBER)			                                    as "Net Weight", -- A.B: Mobiliosios dalies svoris - iš  automobilio atėjusių svorių suma. Lygindavome su faktu. Pasitikslinsiu kokie konkretesni duomenų šaltiniai
    SUM(EmtyedVolume."Volume")                                          as "TotalWeight"

 
FROM {{ source("ASMIL", "ROUTE_HISTORY") }}                   as RouteHistory
LEFT JOIN {{ source("ASMIL", "DEPARTMENT") }}                 as Department     ON EQUAL_NULL(Department."DepartmentPath",RouteHistory."DepartmentPath")
LEFT JOIN {{ source("ASMIL", "ROUTE") }}                      as Route          ON EQUAL_NULL(Route."RouteId",RouteHistory."RouteHistoryId")
LEFT JOIN {{ source("ASMIL", "WASTE_ORIGIN") }}               as WasteOrigin    ON EQUAL_NULL(WasteOrigin."WasteOriginId",RouteHistory."WasteOriginId")
LEFT JOIN (select sum("TakedCount") as "TakedCount" , sum("PickupObjectCount") as "PickupObjectCount", "RouteHistoryId"
            FROM {{ source("ASMIL", "ROUTE_MONITORINGS") }}   
            group by  "RouteHistoryId")                       as RouteMotorings ON EQUAL_NULL(RouteMotorings."RouteHistoryId",RouteHistory."RouteHistoryId")

LEFT JOIN ( SELECT "RouteHistoryId"
                    ,Count(*) AS "ObjectCount"
                   -- ,Sum(Cast("IsInRoute" AS INT)) AS "IsInRouteSum",
                  --  ,Min("DateTime") AS "FirstServe",
                  --  ,Max("DateTime") AS "LastServe",
                  --  ,Sum(IFNULL("CalculatedWaste", 0)) AS "WeighingSum"
             FROM {{ source("ASMIL", "PICKUP_HISTORY") }}
             GROUP BY "RouteHistoryId" )                    AS PickupHistory    ON EQUAL_NULL(RouteHistory."RouteHistoryId", PickupHistory."RouteHistoryId" )  
LEFT JOIN ( SELECT "RouteHistoryId",
                    Count(*) AS "ObjectCount"
             FROM {{ source("ASMIL", "PICKUP_OBJECTS") }}
             GROUP BY "RouteHistoryId" )                    AS PickupObjects    ON EQUAL_NULL(RouteHistory."RouteHistoryId", PickupObjects."RouteHistoryId" )   

LEFT JOIN ( SELECT "RouteHistoryId",
                    Count(*) AS "ObjectCount"
             FROM {{ source("ASMIL", "PICKUP_HISTORY") }}
             WHERE "TakeStateId" = (SELECT "ClassifierId" FROM {{ source("ASMIL", "CLASSIFIER") }} WHERE "ClassifierCode" = 'TS_TAKED')
             GROUP BY "RouteHistoryId" )                    AS PickupHistory2    ON EQUAL_NULL(RouteHistory."RouteHistoryId", PickupHistory2."RouteHistoryId" ) 

LEFT JOIN (select "RouteHistoryId", sum("Volume") as "Volume"  
            FROM {{ source("ASMIL", "EMPTYED_VOLUME") }}  
            group by "RouteHistoryId")          as EmtyedVolume     ON EQUAL_NULL(EmtyedVolume."RouteHistoryId",RouteHistory."RouteHistoryId") 
LEFT JOIN {{ source("ASMIL", "WASTE_LIST") }}   as WasteList        ON EQUAL_NULL(WasteList."WasteListCodeId",RouteHistory."WasteListId") 

  where RouteHistory."NewDate" >= '2025-06-01'    
  and RouteHistory."RouteHistoryId" in (select distinct "Tour No_" from {{ref ('AS_GoldTours_data') }}  )

  group by WasteOrigin."Code", Department."Name" , RouteHistory."RouteHistoryId",WasteList."NoInAccounting"
