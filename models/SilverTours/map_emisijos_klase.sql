/*
MAPPING LOAD  
        No_                                                                                                             as [Automobilio nr],   
    if("Emission Class"=0, '', 'EURO ' & ("Emission Class"-1))  as [Emisijos klasė]
FROM [lib://Qlik DATA (in_migle.purzelyte)/ENWIS/Vehicle.qvd]
(qvd)
;

*/
    
SELECT
    "Automobilio nr",
    "Emisijos klasė"
FROM (
    SELECT
        "No_" as "Automobilio nr",
        case when "Emission Class"=0 then '' else concat('EURO ', ("Emission Class"-1)) end  as "Emisijos klasė",
        ROW_NUMBER() OVER (PARTITION BY "No_" ORDER BY "Emission Class" ASC) AS row_num
    FROM {{ source("ENWIS", "Vehicle") }} )
WHERE row_num = 1