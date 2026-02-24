/*
kiekiai:
  LOAD "Tour No_" 					as [Tour No_],
       No_, 
       [Location Code],
       "Document No_",
       "Document No_"				as  "_Document No_",
       [Int_ Material Catalog]		as [Waste Material Code],
       Count(timestamp) 				as [Order Line Qty],
       sum([Planned Qty_ to Handle]) 	as [Planinis konteinerių kiekis],
       sum([Qty_ to Handle]) 			as [Konteinerių kiekis],
       sum(Quantity)					as Quantity,
       sum("Gross Weight")			as "Gross Weight",
       sum("Net Weight")				as "Net Weight",
       sum(if("Qty_ to Dispose Mandatory"=0,  "Qty_ to Dispose", 0)) as TotalWeight
  FROM [lib://Qlik DATA (in_migle.purzelyte)/ENWIS/Waste Management Line_202*.qvd]
  (qvd)
  Where Exists("Tour No_")
  Group by "Tour No_", No_,  [Location Code], [Int_ Material Catalog], "Document No_"
  ;

*/

select "Tour No_" 					            as "Tour No_",
       "No_", 
       "Location Code",
       "Document No_",
       "Document No_"				            as  "_Document No_",
       "Int_ Material Catalog"		            as "Waste Material Code",
       Count("timestamp") 				        as "Order Line Qty",
       sum("Planned Qty_ to Handle") 	        as "Planinis konteinerių kiekis",
       sum("Qty_ to Handle") 			        as "Konteinerių kiekis",
       Case when "Document No_" like 'SO%' then sum("Quantity") 
            end                                 as "Served",
       sum("Quantity")					        as "Quantity",
       sum("Gross Weight")			            as "Gross Weight",
       sum("Net Weight")				        as "Net Weight",
       sum(case when "Qty_ to Dispose Mandatory"=0 then "Qty_ to Dispose" else 0 end) 
                                                as "TotalWeight"
  FROM {{ source("ENWIS", "Waste Management Line") }}
  where "Task Date" > '2019-12-31' and "Task Date" <= '2025-05-31'--last_day(getdate()) 
  and "Tour No_" in (select distinct "Tour No_" from {{ref ('ENW_GoldTours_data') }}  )
  
  group by "Tour No_", "No_",  "Location Code", "Int_ Material Catalog", "Document No_"