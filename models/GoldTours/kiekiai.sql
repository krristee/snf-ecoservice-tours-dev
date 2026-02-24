
select *, 'ENWIS' as "system" from {{ ref('ENW_kiekiai') }}

UNION ALL

select *, 'ASML' as "system" from {{ ref('AS_kiekiai') }}