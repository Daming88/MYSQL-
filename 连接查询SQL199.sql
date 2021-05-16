#二。SQL99语法
/*

语法：
	selelct 查询列表 
	from 表1 别名1 【连接类型】
	join 表2 别名2 
	on 连接条件
	【where 筛选条件】
	【group by 分组】
	【having 筛选条件】
	【order by 排序列表】

内连接（*）：inner
外连接
	左外连接：left【outer】
	右外连接：right【outer】
	全外连接：full【outer】
交叉连接：cross join
*/


#一。内连接
/*
语法：

select 查询列表
from 表名1 别名
inner join 表名2 别名
on 连接条件；


分类
等值连接
非等值连接
自连接

特点：
1.添加排序，分组，筛选
2.inner可以省略
3.筛选条件放在where后面，连接条件放在on后面，提高分离性，便于阅读
4.inner join连接和92语法中的等值连接效果是一样的，都是查询多表的交集部分
*/

#1.等值连接

#案例1.查询员工名，部门名（调换位置）

SELECT last_name,department_name
FROM employees e
INNER JOIN departments d
ON e.`department_id`=d.`department_id`;
#调换位置
SELECT last_name,department_name
FROM departments d
INNER JOIN employees e
ON e.`department_id`=d.`department_id`;

#案例2.查询名字中包含e的员工名和工种名（筛选）

SELECT last_name,job_title
FROM employees e
INNER JOIN jobs j
ON e.`job_id`=j.`job_id`
WHERE e.`last_name` LIKE '%e%';

#案例3.查询部门个数>3的城市名和部门个数

SELECT COUNT(*) 个数,d.department_name,l.city
FROM departments d
INNER JOIN locations l
ON d.`location_id`=l.`location_id`
GROUP BY l.`city`
HAVING COUNT(*)>3;

#案例4.查询那个部门的部门员工个数>3的部门名和员工个数，并按个数降序（添加排序）

SELECT department_name,COUNT(*)
FROM departments d
INNER JOIN employees e
ON d.`department_id`=e.`department_id`
GROUP BY d.`department_name`
HAVING COUNT(*)>3
ORDER BY COUNT(*) DESC;

#查询员工名，部门名，工种名，并按部门名降序（）

SELECT last_name,department_name,job_title
FROM employees e
INNER JOIN departments d
ON e.`department_id`=d.`department_id`
INNER JOIN jobs j
ON e.`job_id`=j.`job_id`
ORDER BY d.`department_name` DESC;

#二.非等值连接

#查询员工的工资级别

SELECT salary,grade_level
FROM employees e
INNER JOIN job_grades g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`;

#查询每个工资级别的个数

SELECT COUNT(*),grade_level
FROM employees e
INNER JOIN job_grades g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`
GROUP BY grade_level
ORDER BY grade_level ASC;

#查询工资级别的个数>20的个数，并且按工资级别降序

SELECT COUNT(*),grade_level
FROM employees e
INNER JOIN job_grades g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`
GROUP  BY g.`grade_level`
HAVING COUNT(*)>20
ORDER BY g.`grade_level` DESC;

#三.自连接

#查询员工的名字包含字符k和他上级的名字

SELECT e.`last_name`,m.`last_name`
FROM employees e
INNER JOIN employees m
ON e.`manager_id`=m.`employee_id`
WHERE e.`last_name` LIKE '%k%';

#<二> 外连接
/*
应用场景：用于查询一个表中有的，另一个表中没有的记录

特点：
1.外连接的查询结果为主表中的所有记录
	如果从表中有和主表匹配的则显示匹配的值
	如果没有匹配的，则显示null
	则相当与
	外连接查询结果=内连接查询结果+主表中有而从表中没有的记录
2.左外连接中：left左边的是主表
  右外连接：right游标的是主表
  也就是说：左外和右外交换两个表的顺序，可以实现同样的效果
  
3.全外连接=内连接的结果+表1中有但表2中没有的+表2中有表1中没有的
*/

#查询男朋友不在男神表的女神名
USE `girls`
#左外
SELECT g.name,b.*
FROM beauty g
LEFT OUTER JOIN boys b
ON g.`boyfriend_id`=b.`id`
WHERE b.id IS NULL;

#右外
SELECT g.`name`,b.*
FROM boys b
RIGHT OUTER JOIN beauty g
ON g.`boyfriend_id`=b.`id`
WHERE b.`id` IS NULL;

USE `myemployees`;
#查询哪个部门没有员工

SELECT department_name,e.*
FROM departments d
LEFT OUTER JOIN employees e
ON  d.`department_id`=e.`department_id`
WHERE e.`employee_id` IS NULL;

#全外连接

USE girls;

SELECT g.*,b.*
FROM beauty g
FULL OUTER JOIN boys b
ON g.`boyfriend_id`=b.id;

#交叉连接

SELECT * FROM beauty;

SELECT g.*,b.*
FROM beauty g
CROSS JOIN boys b;


#SQL192和SQL199、
/*
功能：SQL99 支持的较多
可读性：SQL99 实现连接条件和筛选条件的分离，可读性
*/

#练习

#1.查询编号>3的女神的男朋友信息，如果有则列出，如果没有，用null填充

USE girls;

SELECT g.`name`,b.*
FROM beauty g
LEFT OUTER JOIN boys b
ON g.`boyfriend_id`=b.`id`
WHERE g.`id`>3;

#2.查询哪个城市没有部门
USE myemployees;

SELECT city,d.`department_name`
FROM locations l
LEFT OUTER JOIN departments d
ON l.`location_id`=d.`department_id`
WHERE d.`department_id` IS NULL ;

#3.查询部门名为sal和IT的员工信息

SELECT e.*,d.`department_name`
FROM departments d
LEFT OUTER JOIN employees e
ON e.`department_id`=d.`department_id`
WHERE d.`department_name`='SAL' OR d.`department_name`='IT';