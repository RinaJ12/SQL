/* Write your T-SQL query statement below 
leetcode-sql-262-trips-and-users
*/
select a.request_at as "Day", cast((cast(a.a1 as float)/cast(b.b1 as float)) as decimal(16,2)) as "Cancellation Rate" from
(select request_at ,SUM(case when Status like '%cancelled%' then 1 else 0 end)  as a1 from Trips t
join (select users_id from Users where banned='No') u on (t.client_id=u.users_id)  
where  t.request_at BETWEEN '2013-10-01' AND '2013-10-03'  group by t.request_at
 ) a
 join 
 (select request_at,COUNT(id) as b1 from trips join users on users.users_id=trips.client_id where users.banned='No' and request_at BETWEEN '2013-10-01' AND '2013-10-03' group by request_at) b
 on a.request_at=b.request_at

 
 /* Write your T-SQL query statement below
601. Human Traffic of Stadium
 */
select id,visit_date,people from(
select id,visit_date,people,count(*) over (partition by row_num) as cnt from
(
select *,abs(id-row_number() over(order by id)) as row_num
from stadium
where people>=100)
tbl
)tbl2
where cnt >=3


Runtime: 838 ms, faster than 52.21% of MS SQL Server online submissions for Human Traffic of Stadium.

/*626. Exchange Seats*/
select id,coalesce(exchanged_seat,student) as student from(
select 
id,student,
case when id%2=1 then lead(student,1) over(order by id) else 
lag (student,1) over(order by id)
end as exchanged_seat
from seat )tbl

/*Runtime: 638 ms, faster than 83.99% of MS SQL Server online submissions for Exchange Seats.*/

Hackerrank
15 Days of Learning SQL

with temp as( 
select hacker_id,dense_rank() over(partition by hacker_id order by submission_date) as dr,submission_date as s_day
from submissions )
,temp1 as (
select s_day, count(distinct hacker_id) as s_day_count from temp
 where dr=day(s_day)
group by s_day
),temp2 as (
select s_day,hacker_id, count(*) as h_count from temp
group by s_day,hacker_id
)
,temp4 as (select temp2.*,temp1.s_day_count,row_number() over (partition by temp2.s_day order by temp2.h_count desc,temp2.hacker_id) as final_rank from temp1 join temp2 on temp1.s_day=temp2.s_day)
select temp4.s_day,temp4.s_day_count,temp4.hacker_id,h.name from temp4 join hackers
on temp4.hacker_id=hackers.hacker_id
where final_rank=1


Interviews
with tot_sub as(
    select challenge_id,sum(total_submissions) sums_total_submissions,sum(total_accepted_submissions) sums_total_accepted_submissions from Submission_Stats group by challenge_id
    having sum(total_submissions)+sum(total_accepted_submissions)>0
),
tot_views as(
     select challenge_id,sum(total_views) sum_total_views,sum(total_unique_views) sumtotal_unique_views from View_Stats group by challenge_id
 having sum(total_views)+sum(total_unique_views)>0
)
select h.contest_id, h.hacker_id, h.name, sum(ts.sums_total_submissions), sum(ts.sums_total_accepted_submissions), sum(tv.sum_total_views),sum(tv.sumtotal_unique_views)
from Contests h join Colleges cl on cl.contest_id=h.contest_id 
join challenges c on c.college_id=cl.college_id
left join tot_sub ts on c.challenge_id=ts.challenge_id
left join tot_views tv on c.challenge_id=tv.challenge_id
group by h.contest_id, h.hacker_id, h.name
order by h.contest_id
 

SQL Project Planning

with temp as(
select task_id,start_date,end_date,row_number() over(order by start_date)-day(start_date) as diff
from
Projects)
select min(start_date),max(end_date)from temp group by diff
order by (max(day(end_date))-min(day(start_date))),min(start_date)