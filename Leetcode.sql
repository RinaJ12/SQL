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

                                                                                        
/* 177 Nth Highest Salary */
                                                                                        
CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
    
        select distinct salary from(
        select salary,dense_rank() over(order by salary desc) as getNthHighestSalary from Employee)tbl where  getNthHighestSalary=@N
     
        /* Write your T-SQL query statement below. */
        
    );
END
