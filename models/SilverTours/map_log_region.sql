/*
MAPPING LOAD "PADALINIO KODAS",
    "LOG Regionas"
    
FROM [lib://Qlik DATA (in_migle.purzelyte)/XLS/LOG PNL.xlsx]
(ooxml, embedded labels, table is [LOG Regionai sanaudos])
Where len(trim("LOG Regionas"))>0
*/
    
SELECT
    "PADALINIO KODAS",
    "LOG Regionas"
FROM (
    SELECT
        "PADALINIO KODAS" as "PADALINIO KODAS",
        "LOG Regionas" as "LOG Regionas",
        ROW_NUMBER() OVER (PARTITION BY "PADALINIO KODAS" ORDER BY "LOG Regionas" ASC) AS row_num
    FROM {{ source("FF", "LOG Regionai sanaudos") }} 
    Where len(trim("LOG Regionas"))>0)
WHERE row_num = 1
    