/*

MMAPPING LOAD
    No_,
    "Employee No_"
FROM [lib://Qlik DATA (in_migle.purzelyte)/ENWIS/Waste Mgt_ Employee.qvd]
(qvd);


*/
    
SELECT
    "No_",
    "Employee No_"
FROM (
    SELECT
        "No_" as "No_",
        "Employee No_" as "Employee No_",
        ROW_NUMBER() OVER (PARTITION BY "No_" ORDER BY "Employee No_" ASC) AS row_num
    FROM {{ source("ENWIS", "Waste Mgt_ Employee") }})
WHERE row_num = 1