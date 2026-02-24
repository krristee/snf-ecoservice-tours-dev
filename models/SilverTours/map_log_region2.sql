/*
MAPPING LOAD 
    "Padalinio kodas" & '|'&  "Projekto kodas",
    "LOG Regionas"
FROM [lib://Qlik DATA (in_migle.purzelyte)/XLS/LOG PNL.xlsx]
(ooxml, embedded labels, table is [LOG Pajamos_EBITDA])
Where len(trim("LOG Regionas"))>0
;

*/
    
SELECT
    "Padalinio kodas | Projekto kodas",
    "LOG Regionas"
FROM (
    SELECT
        concat("Padalinio kodas",' | ',"Projekto kodas") as "Padalinio kodas | Projekto kodas",
        "LOG Regionas" as "LOG Regionas",
        ROW_NUMBER() OVER (PARTITION BY concat("Padalinio kodas",' | ',"Projekto kodas") ORDER BY "LOG Regionas" ASC) AS row_num
    FROM DEV.FF."LOG Pajamos_EBITDA" 
    Where len(trim("LOG Regionas"))>0)
WHERE row_num = 1