{{ config(materialized='table') }}

select 
distinct p.season_nm,p.division_nm,p.team_nm,match_cnt
,current_timestamp() as created_utc,'dbt_svc_acct_user' as created_by,
current_timestamp() as updated_utc,'dbt_svc_acct_user' as updated_by,'cric_clubs' as source_nm
from {{ref("players")}} p
LEFT JOIN
(
select season_nm,team_nm,max(bat_match_cnt) as match_cnt
from {{ref("batting")}}
group by 1,2
) b on p.season_nm = b.season_nm and p.team_nm = b.team_nm