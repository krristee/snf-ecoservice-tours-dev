/*
darbuotojai:
Load [Tour No_],
	 Vairuotojo_tab_nr 	as [Darbuotojo ID],
     Vairuotojo_vardas 	as Darbuotojas,
     'Vairuotojas' 		as Pareigybė,
     'Vairuotojas' 		as Pareigybė2,
     Trukmė*24 			as [Dirbtas darbo laikas]
Resident data
Where _vairuotojas=1
;

Concatenate (darbuotojai)
Load [Tour No_],
	 Kroviko_tab_nr 	as [Darbuotojo ID],
     Kroviko_vardas 	as Darbuotojas,
     'Krovikas1' 		as Pareigybė,
     'Krovikas' 		as Pareigybė2,
     Trukmė*24 			as [Dirbtas darbo laikas]
Resident data
Where _krovikas=1
;

Concatenate (darbuotojai)
Load [Tour No_],
	 Kroviko2_tab_nr 	as [Darbuotojo ID],
     Kroviko2_vardas 	as Darbuotojas,
     'Krovikas2' 		as Pareigybė,
     'Krovikas' 		as Pareigybė2,
     Trukmė*24 			as [Dirbtas darbo laikas]
Resident data
Where _krovikas2=1
;
*/

select "Tour No_",
	 "Vairuotojo_tab_nr" 	as "Darbuotojo ID",
     "Vairuotojo_vardas" 	as "Darbuotojas",
     'Vairuotojas' 		as "Pareigybė",
     'Vairuotojas' 		as "Pareigybė2",
     "Trukmė"*24 			as "Dirbtas darbo laikas"
from {{ref ('ENW_GoldTours_data') }}  
Where "_vairuotojas"=1

union all

select "Tour No_",
	 "Kroviko_tab_nr" 	as "Darbuotojo ID",
     "Kroviko_vardas" 	as "Darbuotojas",
     'Krovikas1' 		as "Pareigybė",
     'Krovikas' 		as "Pareigybė2",
     "Trukmė"*24 			as "Dirbtas darbo laikas"
from {{ref ('ENW_GoldTours_data') }} 
Where "_krovikas"=1

union all 

select "Tour No_",
	 "Kroviko2_tab_nr" 	as "Darbuotojo ID",
     "Kroviko2_vardas" 	as "Darbuotojas",
     'Krovikas2' 		as "Pareigybė",
     'Krovikas' 		as "Pareigybė2",
     "Trukmė"*24 			as "Dirbtas darbo laikas"
from {{ref ('ENW_GoldTours_data') }} 
Where "_krovikas2"=1

