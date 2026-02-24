/*
MAPPING LOAD
    "Padalinio kodas",
    LVRP
 FROM [lib://Qlik DATA (in_migle.purzelyte)/XLS/LVRS LVRP.xlsx]
(ooxml, embedded labels, header is 1 lines, table is [Pagal padalinį]);



*/
    
SELECT
    "Padalinio kodas",
    "LVRP"
FROM (
    SELECT
        "Padalinio kodas" as "Padalinio kodas",
        "LVRP" as "LVRP",
        ROW_NUMBER() OVER (PARTITION BY "Padalinio kodas" ORDER BY "LVRP" ASC) AS row_num
    FROM {{ source("FF", "Pagal padalinį") }} )
WHERE row_num = 1