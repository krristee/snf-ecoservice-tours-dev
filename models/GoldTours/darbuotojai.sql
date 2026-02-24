

select *, 'ENWIS' as "system" from {{ ref('ENW_darbuotojai') }}

UNION ALL

select *, 'ASML' as "system" from {{ ref('AS_darbuotojai') }}