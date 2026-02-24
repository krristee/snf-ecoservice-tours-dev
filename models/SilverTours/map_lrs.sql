/*
MMAPPING LOAD
    "Site code",
    LRS_Regionas
FROM [lib://Qlik DATA (in_migle.purzelyte)/XLS/LOG PNL.xlsx]
(ooxml, embedded labels, table is [LOG REGIONAI_SITE]);


*/
    
SELECT
    "Site code",
    "LRS_Regionas"
FROM (
    SELECT
        "Site code" as "Site code",
        "LRS_Regionas" as "LRS_Regionas",
        ROW_NUMBER() OVER (PARTITION BY "Site code" ORDER BY "LRS_Regionas" ASC) AS row_num
    FROM {{ source("FF", "LOG REGIONAI_SITE") }} )
WHERE row_num = 1