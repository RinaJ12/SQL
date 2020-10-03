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


Placements

with temp as (
select f.*,p1.salary my_sal,p2.salary as frn_sal
from Friends f 
join Packages p1 on f.id=p1.id
join Packages p2 on f.Friend_ID=p2.id
where p1.salary<p2.salary)
select name from Students s join temp p on s.id=p.id
order by p.frn_sal


Symmetric Pairs


with temp as(
select f1.*
from Functions f1 join Functions f2 
on f1.x=f2.y and f1.y=f2.x
)
,temp2 as ( select *,count(*) as cnt from temp where x<=y
 group by x,y)
select x,y from temp2
where (x=y and cnt>1) or (x!=y)
 order by x 
 
 Leet Code -  Get the Second Most Recent Activity
  with temp as 
 (select *,row_number() over (partition by username order by startDate desc) rn
 from UserActivity)
 , temp2 as
 (
 select username from UserActivity group by username having count(*)=1
 )
 ,temp3(
  select ua.* from UserActivity ua join temp2 on ua.username=t2.username union select * from temp  where rn=2)
  
 
 Report-Contiguous-Dates
  
 with temp_success(
select success_date,day(success_date)-dense_rank over (order by success_date) as diff
where success_date between '2019-01-01' to '2019-12-31'),

with temp_fail(
select fail_date,day(fail_date)-dense_rank over (order by fail_date) as diff
where fail_date between '2019-01-01' to '2019-12-31'),

select "succeeded" as period_state,min(success_date) as start_date ,max(success_date) as end_date from temp_success
group by diff 
union
select "failed" as period_state,min(fail_date) as start_date ,max(fail_date) as end_date from temp_success
group by diff
order by start_date


Market Analysis II

with orders_temp as (
select tbl.seller_id from (
select seller_id,row_number() over (partition by seller_id order by order_date) as rn from orders
) tbl
where rn=2
)
,items_users as (
select u.user_id,i.item_id from users u join items i on u.favorite_brand=i.item_brand
)
select ot.user_id ,
case when ot.favorite_brand =sold_brand then yes
else no end as 2nd_item_fav_brand
from items_users iu left join orders_temp ot on iu.user_id=ot.seller_id  


Find-Cumulative-Salary-of-an-Employee
with temp1 as (
select * from(
select * ,row_number() over (partition by id order by month desc)as rn from salary
)where rn>1 or id in (select id from input group by id having count(*)=1)
)
,temp2 as (select t1.*,sum(coalesce(t2.salary,0)) as sal2 temp1 t1 left join temp1  t2 on t1.id=t2.id and t1.month>t2.motnth
group by t1.* )

select temp2.id,temp2.month,temp2.salary+temp2.sal2 as salary from temp2
order by id ,month desc



Average-Salary:-Departments-VS-Company
with com_avg as (
select substr(pay_date,0,7) as pay_month,avg(amount) as c_avg from salary group by substr(pay_date,0,7)
)
,dept_emp as (
select 
substr(pay_date,0,7) as pay_month,d.department_id,avg(salary) as avg_dept group by (concat(month(pay_date),'-',day(pay_date)),department_id)
from 
salary s, join employee e on s.employee_id=e.employee_id
)
select pay_month,department_id,
case when avg_dept > c_avg
case when avg_dept < c_avg
else same
from dept_emp de join com_avg ca
on de.pay_month=ca.pay_month


Students-Report-By-Geography
select 
coalesce(America,'')
coalesce(Europe,'')
coalesce(Asia,'')
from
(
select row_number() over (partition by continent order by name)rn ,name, continent from student 
)
src_tbl
pivot(
min(name) for continent in (America,Europe,Asia) 
)
pv_tbl
order by rn