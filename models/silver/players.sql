{{ config(materialized='table') }}

with players_combined as
(
select player_id,player_nm,trim(left(season_nm,instr(season_nm,' ',1,2)-1)) as season_nm,
trim(right(season_nm,instr(season_nm,' ',1,2)-1)) as division_nm
,team_nm  from `zen-cricket-club.bronze.players_2024_spring_1`
union all
select player_id,player_nm,trim(left(season_nm,instr(season_nm,' ',1,2)-1)) as season_nm,
trim(right(season_nm,instr(season_nm,' ',1,2)-1)) as division_nm
,team_nm  from `zen-cricket-club.bronze.players_2024_spring_2`
union all
select player_id,player_nm,trim(left(season_nm,instr(season_nm,' ',1,2)-1)) as season_nm,
trim(right(season_nm,instr(season_nm,' ',1,2)-1)) as division_nm
,team_nm from `zen-cricket-club.bronze.players_2024_spring_3`
union all
select player_id,player_nm,trim(left(season_nm,instr(season_nm,' ',1,2)-1)) as season_nm,
trim(right(season_nm,instr(season_nm,' ',1,2)-1)) as division_nm
,team_nm from `zen-cricket-club.bronze.players_2024_summer_1`
union all
select player_id,player_nm,trim(left(season_nm,instr(season_nm,' ',1,2)-1)) as season_nm,
trim(right(season_nm,instr(season_nm,' ',1,2)-1)) as division_nm
,team_nm from `zen-cricket-club.bronze.players_2024_summer_2`
union all
select player_id,player_nm,trim(left(season_nm,instr(season_nm,' ',1,2)-1)) as season_nm,
trim(right(season_nm,instr(season_nm,' ',1,2)-1)) as division_nm
,team_nm from `zen-cricket-club.bronze.players_2024_summer_3`
),
agg_players as (
select player_id,player_nm,string_agg(distinct season_nm,"|") as season_nm_lst,
string_agg(distinct division_nm, "|") as division_nm_lst,
string_agg(distinct team_nm,"|") as team_nm_lst,
count(distinct team_nm) as team_cnt,
count(distinct season_nm) as season_cnt
from players_combined
group by 1,2 )

select 
pc.*,season_nm_lst,division_nm_lst,team_nm_lst,team_cnt,season_cnt
,current_timestamp() as created_utc,'dbt_svc_acct_user' as created_by,
current_timestamp() as updated_utc,'dbt_svc_acct_user' as updated_by,'cric_clubs' as source_nm
from players_combined pc LEFT JOIN
agg_players ap on pc.player_id = ap.player_id
order by player_id