`myemployees`#进阶：连接查询
/*
含义：又称多表查询，当查询的字段来自于多个表时，就会用到连接查询

笛卡尔乘积现在：表1 有m行，表2有n行，结果=m*n行

发生原因：没有有效的链接条件
如何避免：添加有效的链接条件

分类
	按年代分类
	SQL192：仅仅支持内连接
	SQL199【推荐】：支持内连接+外连接（左外和右外）+交叉连接
	按照功能分类
	内连接：
		等值链接
		非等值链接
		自连接
	外连接：
		左外连接
		右外连接
		全外连接
	交叉连接：
*/

SELECT NAME, boyName FROM boys,beauty 
WHERE beauty.boyfriend_id=boys.id;


#一 等值链接
/*
1.多表等值连接的结果为多表的交集部分
2.n表连接，至少需要n-1个连接条件
3.多表的瞬息没有要求
4.一般需要为表起别名
5.可以搭配 前面介绍的所有子句使用，比如排序，分组，筛选
*/
#查询女神名和对应的男神名
SELECT NAME, boyName 
FROM boys,beauty 
WHERE beauty.boyfriend_id=boys.id;

`myemployees`
#查询员工名和对应的部门名
SELECT last_name,department_name
FROM employees,departments
WHERE employees.`department_id`=departments.`department_id`;

#2.为表取别名
/*
1.提高语句的简洁度
2.区分多重名的字段

注意：如果为表去了别名，则查询的字段就不能用原来的表名去限定
*/
#查询工种号和工种名

SELECT last_name,e.job_id,job_title
FROM employees e,jobs j
WHERE e.`job_id`=e.`job_id`;

#可以加筛选

#查询有奖金的员工名，部门名
SELECT last_name,department_name,commission_pct
FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`
AND e.`commission_pct` IS NOT NULL;

#查询城市名中第二个字符为o的部门名和城市名

SELECT department_name,city
FROM departments d, locations l
WHERE d.`location_id`=l.`location_id`
AND city LIKE '_o%';

#加分组

#查询每个城市的部门个数

SELECT COUNT(*) 部门个数,l.`city`
FROM departments d, locations l
WHERE d.`location_id`=l.`location_id`
GROUP BY l.`city`;

#查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资

SELECT d.`department_name`,d.`manager_id`,MIN(salary)
FROM departments d,employees e
WHERE commission_pct IS NOT NULL AND d.`department_id`=e.`department_id`
GROUP BY d.`department_id` , d.`manager_id`;

#可以家排序

#查询每个工种的工种名和员工的个数，并且按照员工个数 降序

SELECT j.job_title ,COUNT(*)
FROM employees e,jobs j
WHERE e.`job_id`=j.`job_id`
GROUP BY j.`job_title` 
ORDER BY COUNT(*) DESC;

#可以实现三表连接

#查询员工名，部门名，和所在的城市 

SELECT last_name,department_name,city
FROM employees e,departments d, locations l
WHERE e.`department_id`=d.`department_id` AND d.`location_id`=l.`location_id`;


#二。非等值连接

#查询员工的工资和工资级别 
SELECT salary,last_name,grade_level
FROM employees e,job_grades g
WHERE salary BETWEEN g.`lowest_sal` AND g.`highest_sal`;



#3.自连接

#查询员工名和上级的名称

SELECT e.last_name,e.employee_id,m.last_name,m.employee_id
FROM employees e,employees m
WHERE e.`manager_id`=m.`employee_id`;


#练习 显示所有员工的姓名，部门号和部门名称
SELECT last_name,d.department_id,d.department_name
FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`;

#查询90号部门员工的job_id和90号部门能的location_id
SELECT job_id,location_id
FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`
AND e.`department_id`=90;

#选择所有有奖金的员工

SELECT last_name,department_name,l.location_id,city
FROM employees e,departments d,locations l
WHERE d.`department_id`=e.`department_id`AND d.`location_id`=l.`location_id`
AND e.`commission_pct` IS NOT NULL;

#选着city在Toronto工作的员工
SELECT last_name,city,e.job_id,d.department_id,department_name
FROM employees e,departments d,locations l
WHERE e.`department_id`=d.`department_id`
AND d.`location_id`=l.`location_id`
AND city='Toronto';

#查询每个工种，每个部门的部门名，工种名和最低工资

SELECT department_name,j.job_title,MIN(salary)
FROM departments d,employees e,jobs j
WHERE e.`department_id`=d.`department_id`
AND e.`job_id`=j.`job_id`
GROUP BY department_name,job_title
HAVING MIN(salary);

#查询每个国家下的部门个数大于2 的国家编号
SELECT country_id,COUNT(*) 部门个数
FROM departments d, locations l
WHERE d.`location_id`=l.`location_id`
GROUP BY country_id
HAVING COUNT(*)>=2;

#指定员工信息的姓名，员工号，以及他的管理者的姓名和员工号

SELECT e.last_name 员工名,e.`employee_id` 员工id,m.`last_name` 管理者名,m.`employee_id` 管理者id
FROM employees e,employees m
WHERE e.`manager_id`=m.`employee_id`
AND e.`last_name`='kochhar';