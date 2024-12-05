{{ config(materialized='table') }}

with bowling_combined as 
(
select 
season_nm,season_rank,player_nm,group_nm,team_nm,
matches,innings,CAST(overs as STRING) as overs,runs,wickets,bbf,maidens,dots,economy,avg,strike_rate,hat_trick,four_wk_haul,five_wk_haul,
wides,noballs
 from `zen-cricket-club.bronze.bowling_2024_spring_1` 
 UNION ALL
select 
season_nm,season_rank,player_nm,group_nm,team_nm,
matches,innings,CAST(overs as STRING) as overs,runs,wickets,bbf,maidens,dots,economy,avg,strike_rate,hat_trick,four_wk_haul,five_wk_haul,
wides,noballs
 from `zen-cricket-club.bronze.bowling_2024_spring_2` 
UNION ALL
select 
season_nm,season_rank,player_nm,group_nm,team_nm,
matches,innings,CAST(overs as STRING) as overs,runs,wickets,bbf,maidens,dots,economy,avg,strike_rate,hat_trick,four_wk_haul,five_wk_haul,
wides,noballs
 from `zen-cricket-club.bronze.bowling_2024_spring_3` 
UNION ALL
select 
season_nm,season_rank,player_nm,group_nm,team_nm,
matches,innings,CAST(overs as STRING) as overs,runs,wickets,bbf,maidens,dots,economy,avg,strike_rate,hat_trick,four_wk_haul,five_wk_haul,
wides,noballs
 from `zen-cricket-club.bronze.bowling_2024_summer_1` 
 UNION ALL
select 
season_nm,season_rank,player_nm,group_nm,team_nm,
matches,innings,CAST(overs as STRING) as overs,runs,wickets,bbf,maidens,dots,economy,avg,strike_rate,hat_trick,four_wk_haul,five_wk_haul,
wides,noballs
 from `zen-cricket-club.bronze.bowling_2024_summer_2`
UNION ALL
select 
season_nm,season_rank,player_nm,group_nm,team_nm,
matches,innings,CAST(overs as STRING) as overs,runs,wickets,bbf,maidens,dots,economy,avg,strike_rate,hat_trick,four_wk_haul,five_wk_haul,
wides,noballs
 from `zen-cricket-club.bronze.bowling_2024_summer_3`  
)
,
bowling_stg as (
select season_nm,season_rank,p.player_id,p.player_nm,group_nm,team_nm,
matches as bowl_match_cnt,innings as bowl_innings_cnt,CAST(overs as numeric) as overs_cnt, runs as conceded_runs_cnt,
wickets as wicket_cnt, maidens as maiden_cnt, dots as dot_ball_cnt, round(CAST(economy as numeric),2) as economy_rate,
round(CAST(avg as numeric),2) as bowling_avg,round(CAST(strike_rate as numeric),2) as bowl_strike_rate, hat_trick as hat_trick_cnt,
four_wk_haul as four_wkt_haul_cnt, five_wk_haul as five_wkt_haul_cnt, wides as wide_cnt, noballs as no_ball_cnt,
 CASE WHEN STRPOS(overs,'.') > 0 THEN (CAST(LEFT(overs,STRPOS(overs,'.')-1) AS INT64) * 6)  + CAST(RIGHT(overs,1) AS INT64)
ELSE CAST(overs as INT64) * 6
END as ball_cnt,
 floor(CAST(((CASE WHEN STRPOS(overs,'.') > 0 THEN CAST(LEFT(overs,STRPOS(overs,'.')-1) AS INT64)  + 1
ELSE CAST(overs as INT64)
END)/innings) as NUMERIC)) as min_overs_bowled_cnt,
round(CAST((1/strike_rate) * wickets as numeric),2) as bowl_attack_rate,
trim(bbf) as best_bowling_figure
from bowling_combined bc
 LEFT JOIN 
 (select 
 distinct player_id, player_nm 
 from {{ref("players")}}) p
 on lower(bc.player_nm) = lower(p.player_nm)
 where p.player_id is not null
)

select bs.*
,current_timestamp() as created_utc,'dbt_svc_acct_user' as created_by,
current_timestamp() as updated_utc,'dbt_svc_acct_user' as updated_by,'cric_clubs' as source_nm
from bowling_stg bs
order by bs.player_id
