 {{ config(alias='map_status') }}
 
    select '0' as "a" , 'Executable' as "b"
    union all
	select '1', 'Completed'
    union all
	select '2', 'Archived'