
{{ config(alias='AS_data') }}

  SELECT 
    CAST(RouteHistory."RouteHistoryId" as VARCHAR)                  as "Tour No_",
    CASE  RouteHistory."RouteState"
        WHEN 49     THEN 'Užbaigtas'
        WHEN 50     THEN 'Pradėtas'
        WHEN 57     THEN 'Naujas'
        WHEN 86     THEN 'Nepatvirtintas naujas maršrutas'
        WHEN 1091   THEN 'Uždarytas automatiškai' end               as "Status",
    RouteHistory."Title"                                            as "Description",
    PeriodicRoutePar."Name"                                         as "Description 2",
    null                                                            as "Document Type",
    null                                                            as "DocumentType",
    CAST(RouteHistory."RouteId"  as VARCHAR)                        as "Tour Plan No_",
    User."FirstName" ||' '|| User."LastName"                        as "Dispečerė",
    RouteHistory."NewDate"                                          as "Task Date",
    case when RouteHistory."NewDate"> '2000-01-01' AND RouteHistory."NewDate"<dateadd(day,-3, Getdate()) then 'Vėluojantys' else 'Nevėluojantys/būsimi' end     
                                                                    as "Vėluojanti registracija",
    -- case when RouteHistory."NewDate"> '2000-01-01' AND RouteHistory"NewDate"<dateadd(day,-3, Getdate()) then 1 else 0 end      
    CAST(null   as NUMBER)                                          as "veluojantys",
    CAST(Territory."TerritoryName" as VARCHAR)                      as "Site Code",
    SPLIT_PART(Department."Name", ' ', 3)						    as "LRS regionas",
    null 						                                    as "LVRS", /*--naikinama*/
    SPLIT_PART(Department."Name", ' ', 4)	                        as "LVRP",
    Case when RouteHistory."RouteState" = '49' OR RouteHistory."RouteState" = '1091' then RouteHistory."EndDate"
       end                                                          as "Completion Date",
    Classifier."Value"                                              as "Transport Group Code",
    Vehicle."RegNo"                                                 as "Vehicle No_",
    CAST(Vehicle."Norm_Travel100"  as VARCHAR)	                    as "Emisijos klasė",
    --case when len(trim(RouteHistory."VehicleId" ))>0 then 1 else 0 end   
    CAST(null   as NUMBER)                                          as "_automobiliai",
    null                                                            as "Driver No_", /*-- naikinama*/ 
    CASE when RouteHistStaff_18."StaffId" is not null then "Vairuotojas"
         when RouteHistStaff_18."StaffId" is null and RouteHistStaff_21."StaffId" is not null then "vairuotojas-krovikas" 
     end                                                            as "Vairuotojo_vardas",
    CASE when RouteHistStaff_18."StaffId" is not null then RouteHistStaff_18."TimeCardNumber"
    when RouteHistStaff_18."StaffId" is null and RouteHistStaff_21."StaffId" is not null then RouteHistStaff_21."TimeCardNumber"
    end                                                             as "Vairuotojo_tab_nr", 
    CASE when RouteHistStaff_18."StaffId" is not null then 1
         when RouteHistStaff_18."StaffId" is null and RouteHistStaff_21."StaffId" is not null then 1
    else 0 END     as "_vairuotojas", 
    null                                                            as "Co-Driver No_", /*--naikinama*/ 
    CASE when RouteHistStaff_19."StaffId" is not null then "krovikas" 
    end                                                             as "Kroviko_vardas",
    RouteHistStaff_19."TimeCardNumber"                              as "Kroviko_tab_nr",    
    case when RouteHistStaff_19."StaffId" is not null then 1
    else 0 end                                                      as "_krovikas",
    null                                                            as "Co-Driver 2 No_", /*--naikinama*/ 
    CASE when RouteHistStaff_18."StaffId" is not null and RouteHistStaff_21."StaffId" is not null then "vairuotojas-krovikas" 
     end                                                            as "Kroviko2_vardas",
    CASE when RouteHistStaff_18."StaffId" is not null and RouteHistStaff_21."StaffId" is not null then RouteHistStaff_21."TimeCardNumber"
     end as "Kroviko2_tab_nr",           
    case when RouteHistStaff_18."StaffId" is not null and RouteHistStaff_21."StaffId" is not null then 1 
    else 0 end                                                      as "_krovikas2",
    RouteHistory."MileageEnd" - RouteHistory."MileageStart"         as "Distance", 
    CAST(null   as NUMBER)                                          as "GPS kuras", /*?* nenurodyta  kur info */ 
    TIME(RouteHistory."StartDate")   				                as "Pradžios laikas",
    TIME(RouteHistory."EndDate") 				                    as "Pabaigos laikas",
    DATEDIFF('second',RouteHistory."StartDate","EndDate")/3600      as "Trukmė",
    RouteHistory."FuelStart"			                            as "Kuro likutis pradžioje",
    RouteHistory."FuelEnd"		                                    as "Kuro likutis pabaigoje",
    CAST(null   as NUMBER)                                          as "Motovalandų pradžioje", -- A.B: Moto valandos logistikai neaktualios (ASML bus tik km, motovalandos bus FO dalyje)
    CAST(null   as NUMBER)                                          as "Motovalandų pabaigoje",-- A.B: Moto valandos logistikai neaktualios (ASML bus tik km, motovalandos bus FO dalyje)
    RouteHistory."MileageStart"	                                    as "Spidometras pradžioje",
    RouteHistory."MileageEnd"                                       as "Spidometras pabaigoje", 
    RouteHistory."MileageGPS"					                    as "GPS rida", --SUM
    SupplierOperations."FuelAmount"			                        as "Įsigytas kuro kiekis", --SUM
    RouteHistory."FuelStart" - RouteHistory."FuelEnd"               as "Sunaudotas kuro kiekis", --SUM
    CAST(null   as NUMBER)                                          as "Planinis kuro sunaudojimas", /*?* nenurodyta  kur info */ 
    null                                                            as "Sutrumpinta kuro dimensija 1", /*? neaisku kaip sumachint*/ 
    null                                                            as "Sutrumpinta kuro dimensija 2", /*? neaisku kaip sumachint*/
    null                                                            as "LOG regionas", /*--naikinama*/ 
ARRAY_TO_STRING(ARRAY_COMPACT(ARRAY_CONSTRUCT(RouteHistStaff_18."StaffId", RouteHistStaff_19."StaffId", RouteHistStaff_21."StaffId")), ', ') 
                                                                    AS "StaffId",
    CASE WHEN RouteHistory."RouteState" in (49, 1091) then DATE(RouteHistory."StartDate")
    END                                                             AS "StartingDate"

FROM {{ source("ASMIL", "ROUTE_HISTORY") }}                     as RouteHistory
  LEFT JOIN {{ source("ASMIL", "ROUTE") }}                      as Route            ON EQUAL_NULL(Route."RouteId",RouteHistory."RouteHistoryId")
  LEFT JOIN {{ source("ASMIL", "PERIODIC_ROUTE_PARAMETERS") }}  as PeriodicRoutePar ON EQUAL_NULL(PeriodicRoutePar."PeriodicRouteParametersId",Route."PeriodicRouteParameterId")
  LEFT JOIN {{ source("ASMIL", "USER") }}                       as User             ON EQUAL_NULL(User."UserId",RouteHistory."UserId")
  LEFT JOIN {{ source("ASMIL", "TERRITORY") }}                  as Territory        ON EQUAL_NULL(Territory."Id",RouteHistory."TerritoryId")
  LEFT JOIN {{ source("ASMIL", "DEPARTMENT") }}                 as Department       ON EQUAL_NULL(Department."DepartmentPath",RouteHistory."DepartmentPath")
  LEFT JOIN {{ source("ASMIL", "VEHICLE") }}                    as Vehicle          ON EQUAL_NULL(Vehicle."VehicleId",RouteHistory."VehicleId")
  LEFT JOIN {{ source("ASMIL", "CLASSIFIER") }}                 as Classifier       ON EQUAL_NULL(Classifier."ClassifierId",Vehicle."VehicleType")
  LEFT JOIN (SELECT "RouteHistoryId", sum("FuelAmount") as "FuelAmount"
            FROM {{ source("ASMIL", "SUPPLIER_OPERATIONS") }} 
            group by "RouteHistoryId")                          as SupplierOperations     ON EQUAL_NULL(SupplierOperations."RouteHistoryId",RouteHistory."RouteHistoryId")

  LEFT JOIN ( SELECT RouteHistStaff."RouteHistoryId",    
                    LISTAGG(Staff_18."FName" || ' ' || Staff_18."LName", ', ') WITHIN GROUP (ORDER BY Staff_18."TimeCardNumber") AS "Vairuotojas",
                    LISTAGG(Staff_18."TimeCardNumber", ', ') WITHIN GROUP (ORDER BY Staff_18."TimeCardNumber")                   AS "TimeCardNumber",
                    LISTAGG(Staff_18."StaffId", ', ') WITHIN GROUP (ORDER BY Staff_18."TimeCardNumber")                   AS "StaffId"
            FROM {{ source("ASMIL", "ROUTE_HISTORY_STAFF") }} AS RouteHistStaff   
            LEFT JOIN DEV.ASMIL."STAFF" AS Staff_18     ON EQUAL_NULL(Staff_18."StaffId", RouteHistStaff."StaffId")
            WHERE Staff_18."WorkFunction" = '18'
            GROUP BY RouteHistStaff."RouteHistoryId") as RouteHistStaff_18   ON EQUAL_NULL(RouteHistStaff_18."RouteHistoryId",RouteHistory."RouteHistoryId") 
    LEFT JOIN (SELECT RouteHistStaff."RouteHistoryId",    
                    LISTAGG(Staff_19."FName" || ' ' || Staff_19."LName", ', ') WITHIN GROUP (ORDER BY Staff_19."TimeCardNumber") AS "krovikas",
                    LISTAGG(Staff_19."TimeCardNumber", ', ') WITHIN GROUP (ORDER BY Staff_19."TimeCardNumber")                   AS "TimeCardNumber",
                    LISTAGG(Staff_19."StaffId", ', ') WITHIN GROUP (ORDER BY Staff_19."TimeCardNumber")                   AS "StaffId"
            FROM {{ source("ASMIL", "ROUTE_HISTORY_STAFF") }} AS RouteHistStaff   
            LEFT JOIN DEV.ASMIL."STAFF" AS Staff_19     ON EQUAL_NULL(Staff_19."StaffId", RouteHistStaff."StaffId")
            WHERE Staff_19."WorkFunction" = '19'
            GROUP BY RouteHistStaff."RouteHistoryId") as RouteHistStaff_19   ON EQUAL_NULL(RouteHistStaff_19."RouteHistoryId",RouteHistory."RouteHistoryId") 
    LEFT JOIN (SELECT RouteHistStaff."RouteHistoryId",    
                    LISTAGG(Staff_21."FName" || ' ' || Staff_21."LName", ', ') WITHIN GROUP (ORDER BY Staff_21."TimeCardNumber") AS "vairuotojas-krovikas",
                    LISTAGG(Staff_21."TimeCardNumber", ', ') WITHIN GROUP (ORDER BY Staff_21."TimeCardNumber")                   AS "TimeCardNumber",
                    LISTAGG(Staff_21."StaffId", ', ') WITHIN GROUP (ORDER BY Staff_21."TimeCardNumber")                   AS "StaffId"
            FROM {{ source("ASMIL", "ROUTE_HISTORY_STAFF") }} AS RouteHistStaff   
            LEFT JOIN DEV.ASMIL."STAFF" AS Staff_21     ON EQUAL_NULL(Staff_21."StaffId", RouteHistStaff."StaffId")
            WHERE Staff_21."WorkFunction" = '21'
            GROUP BY RouteHistStaff."RouteHistoryId") as RouteHistStaff_21   ON EQUAL_NULL(RouteHistStaff_21."RouteHistoryId",RouteHistory."RouteHistoryId")  

WHERE RouteHistory."NewDate" >= '2025-06-01'            