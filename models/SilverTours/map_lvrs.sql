/*
MAPPING LOAD
    "Site Code",
    LVRS
FROM [lib://Qlik DATA (in_migle.purzelyte)/XLS/LVRS LVRP.xlsx]
(ooxml, embedded labels, header is 1 lines, table is [Pagal site]);



*/
    
SELECT
    "Site Code",
    "LVRS"
FROM (
    SELECT
        "Site Code" as "Site Code",
        "LVRS" as "LVRS",
        ROW_NUMBER() OVER (PARTITION BY "Site Code" ORDER BY "LVRS" ASC) AS row_num
    FROM {{ source("FF", "Pagal site") }} )
WHERE row_num = 1