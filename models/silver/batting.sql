{{ config(materialized='table') }}


with batting_combined as 
(
select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
 from `zen-cricket-club.bronze.batting_2024_spring_1`
 union ALL
 select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
 from `zen-cricket-club.bronze.batting_2024_spring_2` 
 
 union ALL
 select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
 from `zen-cricket-club.bronze.batting_2024_spring_3` 

 union ALL
 select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
 from `zen-cricket-club.bronze.batting_2024_summer_1`
 union ALL
 select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
 from `zen-cricket-club.bronze.batting_2024_summer_2`  
 union ALL
 select season_nm,season_rank,player_nm,group_nm,
team_nm,matches,innings,notout,runs,fours,sixes,fifties,hundreds,
high_score,CAST(strike_rate as numeric) as strike_rate, CASE WHEN CAST(avg as STRING) = '--' THEN NULL ELSE CAST(avg as numeric) END as bat_avg
 from `zen-cricket-club.bronze.batting_2024_summer_3` 

)
select 
season_nm,season_rank,p.player_id,p.player_nm,group_nm,
team_nm,matches as bat_match_cnt,innings as bat_innings_cnt,notout as notout_cnt,
runs as run_cnt,fours as four_cnt,sixes as six_cnt,fifties as fifty_cnt,hundreds as hundred_cnt,
high_score,round(strike_rate,2) as bat_strike_rate,round(bat_avg,2) as batting_avg, round(cast(strike_rate* bat_avg as numeric),2) as bat_attack_rate,
ROUND(CAST((innings/matches) * 100 as numeric),2) as bat_opportunity_rate
,current_timestamp() as created_utc,'dbt_svc_acct_user' as created_by,
current_timestamp() as updated_utc,'dbt_svc_acct_user' as updated_by,'cric_clubs' as source_nm
 from batting_combined bc
 LEFT JOIN 
 (select 
 distinct player_id, player_nm 
 from {{ref("players")}}) p
 on lower(bc.player_nm) = lower(p.player_nm)
 where p.player_id is not null
 order by p.player_id

 