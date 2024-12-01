{{ config(materialized='table') }}

with cte as 
(
select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
,current_timestamp() as created_utc,'dbt_svc_acct_user' as created_by,
current_timestamp() as updated_utc,'dbt_svc_acct_user' as updated_by,'cric_clubs' as source_nm
 from `zen-cricket-club.bronze.batting_2024_spring_1`
 union ALL
 select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
,current_timestamp() as created_utc,'dbt_svc_acct_user' as created_by,
current_timestamp() as updated_utc,'dbt_svc_acct_user' as updated_by,'cric_clubs' as source_nm
 from `zen-cricket-club.bronze.batting_2024_spring_2` 
 
 union ALL
 select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
,current_timestamp() as created_utc,'dbt_svc_acct_user' as created_by,
current_timestamp() as updated_utc,'dbt_svc_acct_user' as updated_by,'cric_clubs' as source_nm
 from `zen-cricket-club.bronze.batting_2024_spring_3` 

)
select 
season_nm,season_rank,player_nm,group_nm,
team_nm,matches as match_cnt,innings as innings_cnt,notout as notout_cnt,
runs as run_cnt,fours as four_cnt,sixes as six_cnt,fifties as fifty_cnt,hundreds as hundred_cnt,
high_score,strike_rate,bat_avg as batting_avg, round(cast(strike_rate* bat_avg as numeric),2) as bat_attack_rate,
created_utc,created_by,updated_utc,updated_by,source_nm
 from cte