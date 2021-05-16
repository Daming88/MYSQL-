#子查询

/*
含义
出现在其他语句中的select语句，称作为子查询或内查询
外部的查询语句，称作为主查询或外查询

分类
按子查询出现的位置
	select 后面
		标量子查询（仅仅一行一列的）
	from 后面
		表 子查询
	where或having后面
		标量子查询
		列子查询
		行子查询（较少）
	exists后面（相关子查询）
		表子查询
按结果集的行列数不同
	标量子查询（结果集只有一行一列）
	列子查询（结果集只有一列多行）
	行子查询（结果集有一行多列）
	表子查询（结果集一般为多行多列）
*/

#1.where或having后面

/*
1.标量子查询
2.列子查询
3.行子查询

特点
1.子查询放在小括号内
2.子查询一般放在条件的右侧
3.标量子查询，一般搭配着单行操作符
	例如> < >= <= <> =
  列子查询，一般搭配着多行操作符使用
	例如：in，any/some,all
4.子查询的执行优先于主查询执行的，主查询的条件用到了子查询的结果
*/

#标量子查询
#谁的工资比Abel高
#1.查询Abel的工资
SELECT salary 
FROM employees
WHERE last_name='Abel';
#2.查询员工的信息，满足salary>1的结果
SELECT * 
FROM employees
WHERE salary>(
	SELECT salary 
        FROM employees
        WHERE last_name='Abel'
);

#返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
#1.查询143号员工的工资
SELECT salary 
FROM employees
WHERE employee_id=143;
#2.查142号员工相同的员工的job_id
SELECT job_id
FROM employees
WHERE employee_id=142 ;
#3.查询与相同的job_id的员工
SELECT last_name
FROM employees
WHERE job_id=(
	SELECT job_id
	FROM employees
	WHERE employee_id=142 
);
#4.通过3得出的结果和1得出的结果查询，salary比143号员工多的员工姓名
SELECT last_name,job_id,salary
FROM employees
WHERE job_id=(
	SELECT job_id
	FROM employees
	WHERE employee_id=142 
)
AND salary>(
	SELECT salary 
	FROM employees
	WHERE employee_id=143
);

#案例三：返回公司工资最少的员工的last_name，job_id和salary
#查询最低的工资
SELECT MIN(salary)
FROM employees;
#2.
SELECT last_name,job_id,salary
FROM employees
WHERE salary=(
	SELECT MIN(salary)
	FROM employees
);

#案例四：查询最低工资大于50号部门最低工资的部门id和其最低工资

#1.查询50号部门的员工的最低工资
SELECT MIN(salary)
FROM employees
WHERE department_id=50;
#查询工资比50 号部门最低工资高的部门信息
SELECT department_id
FROM employees
WHERE salary>(
	SELECT MIN(salary)
	FROM employees
	WHERE department_id=50
);
#4.
SELECT department_id,MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary)>(
	SELECT MIN(salary)
	FROM employees
	WHERE department_id=50
);

#非法使用标量子查询
SELECT department_id,MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary)>(
	SELECT salary
	FROM employees
	WHERE department_id=250
);

#2.列子查询（对行子查询（一列多行））

#案例一：返回location_id 是1400或1700的部门中的所有员工姓名
#1.先差查询location_id是1400或1700 的部门编号
SELECT DISTINCT department_id
FROM departments l
WHERE l.`location_id` IN (1400,1700);

#查询员工名，要求部门号是1列表中的某一个

SELECT last_name
FROM employees 
WHERE department_id IN (
	SELECT DISTINCT department_id
	FROM departments l
	WHERE l.`location_id` IN (1400,1700)
);


#返回其他哦工种中比job_id为‘IT_PROG’工种任一工资低的员工的员工号，姓名，job_id以及salary

#查询job_id为‘IT_PROG’部门的所有工资

SELECT DISTINCT salary
FROM employees 
WHERE job_id='IT_PROG';
#查询其他部门员工比1列表的任一工资都要低的员工
SELECT  employee_id,last_name,job_id,salary
FROM employees
WHERE job_id !='IT_PROG'
AND salary < ANY(
SELECT DISTINCT salary
FROM employees 
WHERE job_id='IT_PROG'
);

#3.行子查询（结果集是一行多列，或多行多列）

#查询员工编号最小并且工资最高的员工信息
#以前的做法
#查询最小的员工编号
SELECT MIN(employee_id)
FROM employees;
#查询最高工资
SELECT MAX(salary)
FROM employees;
#查询员工信息
SELECT * 
FROM employees
WHERE employee_id=(
	SELECT MIN(employee_id)
	FROM employees
)AND salary=(
	SELECT MAX(salary)
	FROM employees
);
#行子查询做法
SELECT *
FROM employees
WHERE (employee_id,salary)=(
	SELECT MIN(employee_id),MAX(salary)
	FROM employees
);

#二。select后面
/*
仅仅支持标量子查询
*/
#查询每个部门的员工个数

SELECT d.*,(
	SELECT COUNT(*)
	FROM employees e
	WHERE e.department_id=d.`department_id`
) 个数
FROM departments d;

#案例二.查询员工号=102的部门名

SELECT (
	SELECT department_name
	FROM departments d
	INNER JOIN employees e
	ON d.department_id=e.department_id
	WHERE e.employee_id=102
)  部门名;

#三.from后面
/*
将子查询结果充当一张表，要求必须起别名
*/
#案例：查询每个部门的平均工资的工资等级

#查询每个部门的平均工资

SELECT AVG(salary),department_id
FROM employees e
GROUP BY e.department_id;

#连接1的结果集和job_grades表，筛选条件平均工资between lowest_sal and highest_sal
#方法一，使用内连接
SELECT AVG(salary),department_id,g.`grade_level`
FROM employees e
INNER JOIN job_grades g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`
GROUP BY e.`department_id`;
#方法二：使用子查询
SELECT ag_dep.*,g.`grade_level`
FROM (
	SELECT AVG(salary) ag,department_id
	FROM employees
	GROUP BY department_id
) ag_dep
INNER JOIN job_grades g
ON ag_dep.ag BETWEEN g.`lowest_sal` AND g.`highest_sal`;

#四.exists后面（相关子查询）
/*
语法
exists（完整的查询语句）
结果：
1或者0
*/
SELECT EXISTS(SELECT employee_id FROM employees WHERE salary=9000000);

#案例1：查询有员工的部门名

SELECT department_name
FROM departments d
WHERE EXISTS(
	SELECT * 
	FROM employees e
	WHERE d.`department_id`=e.`department_id`
);

#in
SELECT department_name
FROM departments d
WHERE d.`department_id` IN(
	SELECT DISTINCT department_id
	FROM employees e
);

#案例二：查询没有女朋友的男神信息`boys`

#in
SELECT bo.*
FROM boys bo
WHERE bo.`id` NOT IN (
	SELECT boyfriend_id
	FROM beauty
);

#exists
SELECT bo.*
FROM boys bo
WHERE NOT EXISTS(
	SELECT g.`boyfriend_id`
	FROM beauty g
	WHERE bo.`id`=g.`boyfriend_id`
);

#练习
#1.查询和Zlotkey相同部门的员工姓名和工资

SELECT e.`last_name`,e.`salary`,e.`department_id`
FROM employees e
WHERE e.`department_id`=(
	SELECT department_id
	FROM employees 
	WHERE last_name='Zlotkey'
);

#2.查询工资比公司平均工资高的员工的员工号，姓名和工资
#查询公司的平均工资
SELECT AVG(salary)
FROM employees;

SELECT e.`employee_id`,e.`last_name`,e.`salary`
FROM employees e
WHERE e.`salary`>(
	SELECT AVG(salary)
	FROM employees
);

#3.查询个部门中工资比本部门平均工资高的员工号，姓名，工资

#查询各部门的平均工资
SELECT AVG(salary),department_id
FROM employees e
GROUP BY department_id;

SELECT e.`last_name`,e.`employee_id`,e.`salary`,e.`department_id`,ag_dep.ag
FROM (
	SELECT AVG(salary) ag,department_id
	FROM employees e
	GROUP BY department_id
) ag_dep
INNER JOIN employees e
ON e.`department_id`=ag_dep.department_id
WHERE e.`salary`>ag_dep.ag;

#4.查询和姓名中字母包含u的员工在相同部门的员工的员工号和姓名

#查询姓名中包含u字母的员工所在的部门
SELECT DISTINCT department_id
FROM employees 
WHERE last_name LIKE '%u%';

SELECT e.`last_name`,e.`employee_id`
FROM employees e
WHERE e.`department_id` =ANY(
	SELECT DISTINCT department_id
	FROM employees 
	WHERE last_name LIKE '%u%'
);

#5:查询在部门的location_id为1700的部门工作的员工的员工号

SELECT department_id
FROM departments 
WHERE `location_id`=1700;

SELECT e.`employee_id`
FROM employees e
WHERE e.`department_id` =ANY(
	SELECT department_id
	FROM departments 
	WHERE `location_id`=1700
);

