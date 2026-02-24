/*
 data:
  LOAD No_							as [Tour No_],
      ApplyMap('map_status', Status) as Status,
      Description,
      "Description 2",
      ApplyMap('map_doctype', "Document Type") as "Document Type",
       ApplyMap('map_doctype', "Document Type") as "DocumentType",
      "Tour Plan No_",
      "Post ID"						as Dispečerė,
      if("Task Date"<0, '', date(floor("Task Date")))		as [Task Date],
      if("Task Date">0 AND "Task Date"<date(Today()-3), 'Vėluojantys', 'Nevėluojantys/būsimi') as [Vėluojanti registracija],
      if("Task Date">0 AND "Task Date"<date(Today()-3), 1, 0) as veluojantys,
      "Site Code",
      ApplyMap('map_lrs', [Site Code], 'neaprašyta')							as [LRS regionas],
      ApplyMap('map_lvrs', [Site Code], 'neaprašyta')							as [LVRS],
      ApplyMap('map_lvrp', "Fuel Shortcut Dimension 1 Code", 'neaprašyta')	as [LVRP],
      if("Completion Date"<0, '', date(ConvertToLocalTime("Completion Date",'Vilnius'), 'YYYY-MM-DD hh:mm')) as [Completion Date],
      "Transport Group Code",
      "Vehicle No_",
      ApplyMap('map_emisijos_klase', [Vehicle No_], '')	as [Emisijos klasė],
      if(len(trim("Vehicle No_"))>0, 1,0)					as _automobiliai,
      "Driver No_",
      ApplyMap('map_vardas',"Driver No_",'' ) 		as Vairuotojo_vardas,
      ApplyMap('map_tabelis',"Driver No_",'' ) 		as Vairuotojo_tab_nr,
      if(len(trim("Driver No_"))>0, 1,0)  			as _vairuotojas,
      "Co-Driver No_",
      ApplyMap('map_vardas',"Co-Driver No_",'' ) 		as Kroviko_vardas,
      ApplyMap('map_tabelis',"Co-Driver No_",'' )		as Kroviko_tab_nr,
      if(len(trim("Co-Driver No_"))>0, 1,0)  			as _krovikas,
      "Co-Driver 2 No_",
      ApplyMap('map_vardas',"Co-Driver 2 No_",'' ) 	as Kroviko2_vardas,
      ApplyMap('map_tabelis',"Co-Driver 2 No_",'' ) 	as Kroviko2_tab_nr,   
      if(len(trim("Co-Driver 2 No_"))>0, 1,0)  		as _krovikas2,
       Distance,
      "GPS Fuel"						as [GPS kuras], 
      time("Starting Time"-date(floor([Starting Time])), 'hh:mm')					as [Pradžios laikas],
      time("Finishing Time"-date(floor([Finishing Time])), 'hh:mm')				as [Pabaigos laikas],
      "Finishing Time"-"Starting Time" as Trukmė,
      "Starting Fuel Balance"			as [Kuro likutis pradžioje],
      "Finishing Fuel Balance"		as [Kuro likutis pabaigoje],
      "Starting Moto Hours"			as [Motovalandų pradžioje],
      "Finishing Moto Hours"			as [Motovalandų pabaigoje],
      "Starting Speedometer Mileage"	as [Spidometras pradžioje],
      "Finishing Speedometer Mileage"	as [Spidometras pabaigoje], 
      "GPS Distance"					as [GPS rida], 
      "Qty_ Fuel Acquisition"			as [Įsigytas kuro kiekis],
      "Qty_ Fuel Consumption"			as [Sunaudotas kuro kiekis],
      "Target Fuel Consumption"		as [Planinis kuro sunaudojimas],
      "Fuel Shortcut Dimension 1 Code" as [Sutrumpinta kuro dimensija 1],
      "Fuel Shortcut Dimension 2 Code" as [Sutrumpinta kuro dimensija 2],
      ApplyMap('map_log_region', "Fuel Shortcut Dimension 1 Code", 
          ApplyMap('map_log_region2', "Fuel Shortcut Dimension 1 Code" & '|' & "Fuel Shortcut Dimension 2 Code", '')) as "LOG regionas"
  FROM [lib://Qlik DATA (in_migle.purzelyte)/ENWIS/Tour.qvd]
  (qvd)
  ;
*/

{{ config(alias='ENW_data') }}

Select Tour."No_"							                                as "Tour No_",
      MAP_STATUS."b"                                                        as "Status",
      Tour."Description",
      Tour."Description 2",
      MAP_DOCTYPE."b"                                                       as "Document Type",
      MAP_DOCTYPE."b"                                                       as "DocumentType",
      Tour."Tour Plan No_",
      Tour."Post ID"						                                as "Dispečerė",
      case when "Task Date"< '2000-01-01' then null else date("Task Date") end		as "Task Date",
      case when "Task Date"> '2000-01-01' AND "Task Date"<dateadd(day,-3, Getdate()) then 'Vėluojantys' else 'Nevėluojantys/būsimi' end     as "Vėluojanti registracija",
      case when "Task Date"> '2000-01-01' AND "Task Date"<dateadd(day,-3, Getdate()) then 1 else 0 end      as "veluojantys",
      Tour."Site Code",
      ifnull(MAP_LRS."LRS_Regionas", 'neaprašyta')							as "LRS regionas",
      ifnull(MAP_LVRS.LVRS, 'neaprašyta')							        as "LVRS",
      ifnull(MAP_LVRP.LVRP, 'neaprašyta')	                                as "LVRP",
      case when "Completion Date"< '2000-01-01' then null else "Completion Date" end 
                                                                            as "Completion Date",
      Tour."Transport Group Code",
      Tour."Vehicle No_",
      ifnull(MAP_EMISIJOS_KLASE."Emisijos klasė", '')	                    as "Emisijos klasė",
      case when len(trim("Vehicle No_"))>0 then 1 else 0 end				as "_automobiliai",
      Tour."Driver No_",
      ifnull(MAP_VARDAS."Name",'' ) 		                                as "Vairuotojo_vardas",
      ifnull(MAP_TABELIS."Employee No_",'' ) 		                        as "Vairuotojo_tab_nr",
      case when len(trim("Driver No_"))>0 then 1 else 0 end  			    as "_vairuotojas",
      Tour."Co-Driver No_",
      ifnull(MAP_VARDAS2."Name",'' ) 		                                as "Kroviko_vardas",
      ifnull(MAP_TABELIS2."Employee No_",'' )		                        as "Kroviko_tab_nr",
      case when len(trim("Co-Driver No_"))>0 then 1 else 0 end  			as "_krovikas",
      Tour."Co-Driver 2 No_",
      ifnull(MAP_VARDAS3."Name",'' ) 	                                    as "Kroviko2_vardas",
      ifnull(MAP_TABELIS3."Employee No_",'' ) 	                            as "Kroviko2_tab_nr",     
      case when len(trim("Co-Driver 2 No_"))>0 then 1 else 0 end  		    as "_krovikas2",
      Tour."Distance",
      Tour."GPS Fuel"						                                as "GPS kuras", 
      TIME(Tour."Starting Time")   				                            as "Pradžios laikas",
      TIME(Tour."Finishing Time") 				                            as "Pabaigos laikas",
      DATEDIFF('seconds',Tour."Starting Time","Finishing Time")/ 3600       as "Trukmė",
      Tour."Starting Fuel Balance"			                                as "Kuro likutis pradžioje",
      Tour."Finishing Fuel Balance"		                                    as "Kuro likutis pabaigoje",
      Tour."Starting Moto Hours"			                                as "Motovalandų pradžioje",
      Tour."Finishing Moto Hours"			                                as "Motovalandų pabaigoje",
      Tour."Starting Speedometer Mileage"	                                as "Spidometras pradžioje",
      Tour."Finishing Speedometer Mileage"	                                as "Spidometras pabaigoje", 
      Tour."GPS Distance"					                                as "GPS rida", 
      Tour."Qty_ Fuel Acquisition"			                                as "Įsigytas kuro kiekis",
      Tour."Qty_ Fuel Consumption"			                                as "Sunaudotas kuro kiekis",
      Tour."Target Fuel Consumption"		                                as "Planinis kuro sunaudojimas",
      Tour."Fuel Shortcut Dimension 1 Code"                                 as "Sutrumpinta kuro dimensija 1",
      Tour."Fuel Shortcut Dimension 2 Code"                                 as "Sutrumpinta kuro dimensija 2",
      ifnull(MAP_LOG_REGION."LOG Regionas", ifnull (MAP_LOG_REGION2."LOG Regionas", '')) as "LOG regionas",
      NULL                                                   as "StaffId",
      NULL                                                   AS "StartingDate"
  FROM {{ source("ENWIS", "Tour") }}             as Tour
  left join {{ref ('SilverTours_map_status') }}  as MAP_STATUS on EQUAL_NULL(MAP_STATUS."a",Tour."Status")
  left join {{ref ('map_doctype') }}             as MAP_DOCTYPE on EQUAL_NULL(MAP_DOCTYPE."a",Tour."Document Type")
  left join {{ref ('map_lrs') }}                 as MAP_LRS on EQUAL_NULL(MAP_LRS."Site code",Tour."Site Code")
  left join {{ref ('map_lvrs') }}                as MAP_LVRS on EQUAL_NULL(MAP_LVRS."Site Code",Tour."Site Code")
  left join {{ref ('map_lvrp') }}                as MAP_LVRP on EQUAL_NULL(MAP_LVRP."Padalinio kodas",Tour."Fuel Shortcut Dimension 1 Code")
  left join {{ref ('map_emisijos_klase') }}      as MAP_EMISIJOS_KLASE on EQUAL_NULL(MAP_EMISIJOS_KLASE."Automobilio nr",Tour."Vehicle No_")
  left join {{ref ('map_vardas') }}              as MAP_VARDAS on EQUAL_NULL(MAP_VARDAS."No_",Tour."Driver No_")
  left join {{ref ('map_vardas') }}              as MAP_VARDAS2 on EQUAL_NULL(MAP_VARDAS2."No_",Tour."Co-Driver No_")
  left join {{ref ('map_vardas') }}              as MAP_VARDAS3 on EQUAL_NULL(MAP_VARDAS3."No_",Tour."Co-Driver 2 No_")
  left join {{ref ('map_tabelis') }}             as MAP_TABELIS on EQUAL_NULL(MAP_TABELIS."No_",Tour."Driver No_")
  left join {{ref ('map_tabelis') }}             as MAP_TABELIS2 on EQUAL_NULL(MAP_TABELIS2."No_",Tour."Co-Driver No_")
  left join {{ref ('map_tabelis') }}             as MAP_TABELIS3 on EQUAL_NULL(MAP_TABELIS3."No_",Tour."Co-Driver 2 No_")
  left join {{ref ('map_log_region') }}          as MAP_LOG_REGION on EQUAL_NULL(MAP_LOG_REGION."PADALINIO KODAS",Tour."Fuel Shortcut Dimension 1 Code")
  left join {{ref ('map_log_region2') }}         as MAP_LOG_REGION2 on EQUAL_NULL(MAP_LOG_REGION2."Padalinio kodas | Projekto kodas",concat(Tour."Fuel Shortcut Dimension 1 Code",' | ',"Fuel Shortcut Dimension 2 Code"))

  where "Task Date" > '2019-12-31' and "Task Date" <= '2025-05-31'


    