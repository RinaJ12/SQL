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

Total-Sales-Amount-by-Year
with years as 
(
select distinct year(period_start) as yr from Sales
union distinct year(period_end) as yr from Sales
)
with sales_temp(
from sales s
left join years y
on period_end=>year and period_start<=year
)
select p.product_id,p.product_name,st.yr
(datediff(day,
case when year(period_start)=yr then period_start
else concat(yr,'-01-01') as new_start_dt,
case when year(period_end)=yr then period_end 
else concat(yr,'-12-31') as new_end_dt)+1)*total_amount
from sales_temp st join products p 
on p.product_id=st.product_id

Find-the-Quiet-Students-in-All-Exams

with exam_high_low as 
(
select *,min(score) over (partition by exam_id) as min_score,max(score) over (partition by exam_id) as max_score
)
select student.* from exam_high_low
join student on student.student_id=exam_high_low.student_id
where student_id not in (select student_id from exam_high_low where score in (max_score,min_score))


Game-Play-Analysis-III

select a1.player_id,a1.event_date,sum(a2.games_played_so_far)
from Activity a1 
join Activity a2 on 
a1.player_id=c2.player_id and 
a1.event_date>=a2.event_date
group by player_id,event_date


Game-Play-Analysis-IV

select player_id,
round(sum((case when dateadd(day,event_date,1) = lead(event_date,1) over (partition by player_id,order by event_date) 1 else 0)/(select count(distinct player_id))),2)
from Activity


Managers with at Least 5 Direct Reports
select Name from Employee where id in (
select managerId from employee  group by managerId
having coun(*)>4) tbl


Winning-Candidate
select Name from Candidate where candidate_id = (
select candidate_id from vote group by candidate_id
order by count(*) desc limit 1
)


LeetCode: Friend Requests II: Who Has the Most Friends
with req_temp as (
select requester_id as user_id ,count(*) as frnd from request_accepted  group by requester_id
union all
select accepter_id as user_id ,count(*) as frnd from request_accepted  group by accepter_id 
)
select user_id ,sum(frnd) from req_temp group by user_id
order by sum(frnd) limit 1


LeetCode: Tree Node
select distinct id ,
case when p_id is null then 'Root'
when p_id is not null and t2.p_id is not null then 'Inner'
when p_id is not null and t2.p_id is null then 'Leaf'
from tree t1 left join tree t2
on t1.id=t2.p_id


Shortest-Distance-in-a-Plane
select 
min(
round(sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y)),2))
from point_2d p1 join point_2d p2 
p1.x!=p2.x or p1.y!=p2.y

Second-Degree-Follower
select f1.follower,count(f2.follower)
from follow f1
join follow f2
on f1.follower=f2.follow
where f2.follower is not null
group by f1.follower

Customers-Who-Bought-All-Products
select customer_id
From customer
where product_key in (select product_key from product) 
group by customer_id
having count(*)=2

Product-Sales-Analysis-III
with temp as (select product_id,year as first_year,quantity,price ,row_number() as rank over (partition by product_id order by year) 
from sales)
select product_id,year as first_year,quantity,price from temp where rank=1

Unpopular Books 
select book_id,name from books where book_id not in (select book_id from orders group by book_id having sum(quantity)<10) and 
available_from<'2019-05-23'


Date Window of 7 days

with temp as (
select '2019-01-01' date1
union
select '2019-01-02' date1
union
select '2019-01-03' date1
union
select '2019-01-04' date1
union
select '2019-01-05' date1
union
select '2019-01-06'  date1
union
select '2019-01-07' date1
union
select '2019-01-08' date1
union
select '2019-01-09' date1
union
select '2019-01-10' date1
)
,temp2 as(
select t2.date1 t2_date,t1.date1 t1_date,count(t1.date1) over (partition by t2.date1) as diff from temp t1 join temp t2 on
t1.date1<=t2.date1 and datediff(day,t1.date1,t2.date1) between 0 and 6)
select * from temp2  where diff=7


With temp1 as (
select  distinct id , date1,
case when datediff(day,date1,Lead(date1,1) over (partition by id order by date1))=1 OR 
datediff(day,Lag(date1,1) over (partition by id order by date1),date1)=1 then 1 end as new_col from Logins)
select id from temp1
group by id having sum(new_col)>4