
{{ config(alias='AS_darbuotojai') }}

/*select "Tour No_",
	 --"Vairuotojo_tab_nr" 	as "Darbuotojo ID",
     "Vairuotojo_vardas" 	as "Darbuotojas",
     'Vairuotojas' 		as "Pareigybė",
     'Vairuotojas' 		as "Pareigybė2",
     "Trukmė"*24 			as "Dirbtas darbo laikas"
from {{ref ('AS_GoldTours_data') }}  
Where "Vairuotojo_vardas" is not null ---"_vairuotojas"=1

union all

select "Tour No_",
	 --"Kroviko_tab_nr" 	as "Darbuotojo ID",
     "Kroviko_vardas" 	as "Darbuotojas",
     'Krovikas1' 		as "Pareigybė",
     'Krovikas' 		as "Pareigybė2",
     "Trukmė"*24 			as "Dirbtas darbo laikas"
from {{ref ('AS_GoldTours_data') }} 
Where "Kroviko_vardas" is not null --"_krovikas"=1

union all 

select "Tour No_",
	 --"Kroviko2_tab_nr" 	as "Darbuotojo ID",
     "Kroviko2_vardas" 	as "Darbuotojas",
     'Krovikas2' 		as "Pareigybė",
     'Krovikas' 		as "Pareigybė2",
     "Trukmė"*24 			as "Dirbtas darbo laikas"
from {{ref ('AS_GoldTours_data') }} 
Where "Kroviko2_vardas" is not null --"_krovikas2"=1*/

select 
    CAST(GT_data."Tour No_" AS VARCHAR)                         as "Tour No_"
    ,null                                                       as "Darbuotojo ID"
    ,Staff."FName" ||' '|| Staff."LName"                        as "Darbuotojas"
    ,CASE Staff."WorkFunction" 
        WHEN '18' then 'Vairuotojas'
        WHEN '19' then 'Pagalbinis darbininkas'
        WHEN '21' then 'Vairuotojas-pagalbinis darbininkas'
    end                                                         as "Pareigybė"
    ,CASE Staff."WorkFunction" 
        WHEN '18' then 'Vairuotojas'
        WHEN '19' then 'Pagalbinis darbininkas'
        WHEN '21' then 'Vairuotojas-pagalbinis darbininkas'
    end                                                         as "Pareigybė2"
    ,GT_data."Trukmė" 			                                as "Dirbtas darbo laikas"
from {{ref ('AS_GoldTours_data') }}         as GT_data
LEFT JOIN  {{ source("ASMIL", "STAFF") }}   as Staff    ON EQUAL_NULL(cast(Staff."StaffId" as varchar),GT_data."StaffId")
where Staff."StaffId" is not null