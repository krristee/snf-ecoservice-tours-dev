/*
MAPPING LOAD
    No_,
    Name
FROM [lib://Qlik DATA (in_migle.purzelyte)/ENWIS/Waste Mgt_ Employee.qvd]
(qvd);


*/
    
SELECT
    "No_",
    "Name"
FROM (
    SELECT
        "No_" as "No_",
        "Name" as "Name",
        ROW_NUMBER() OVER (PARTITION BY "No_" ORDER BY "Name" ASC) AS row_num
    FROM {{ source("ENWIS", "Waste Mgt_ Employee") }})
WHERE row_num = 1