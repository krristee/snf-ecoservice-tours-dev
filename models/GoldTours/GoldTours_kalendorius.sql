 {{ config(alias='kalendorius') }}

 
select *, 'ENWIS' as "system" from {{ ref('ENW_GoldTours_kalendorius') }}

UNION ALL

select *, 'ASML' as "system" from {{ ref('AS_GoldTours_kalendorius') }}