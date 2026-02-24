 {{ config(alias='data') }}

 
select *, 'ENWIS' as "system" from {{ ref('ENW_GoldTours_data') }}

UNION ALL

select *, 'ASML' as "system" from {{ ref('AS_GoldTours_data') }}