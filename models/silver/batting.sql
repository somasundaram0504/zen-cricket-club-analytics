{{ config(materialized='table') }}

with cte as 
(
select * from `zen-cricket-club`.raw.batting_2024_spring_1
)
select * from cte