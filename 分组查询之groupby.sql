#分组查询进阶
/*
语法：
	select 分组函数，列（要求出现在group by 的后面）
	from 表
	【where筛选条件】
	group by 分组的列表
	【order by 子句】
注意：
	查询列表必须特殊，要求分组函数和group by后出现的字段
	
特点：
	1.分组查询中的筛选条件分为两类
			数据源				位置			关键字	
	分组前筛选	原始表			group by子句的前面前		where
	分组后筛选	分组后的结果集		group by子句的后面		having
	
	1.分组函数做条件肯定放在having子句中
	2.能用分组前 筛选的【优先考虑使用】
	
	3.group by子句支持单个字段分组，多个字段分组，（之间用逗号隔开，没有顺序要求），表达式或函数（相对较少）
	4.也可以添加添加 排序（排序放在整个分组查询的最后）
*/

#查询么个工种的最高工资
SELECT MAX(salary),job_id
FROM employees
GROUP BY  job_id;
#查询每个位置上的部门个数 

SELECT COUNT(*),location_id
FROM departments
GROUP BY location_id;

#添加筛选条件
#添加分组前的筛选条件
#查询邮箱中包含a字符的，每个部门的平均工资
SELECT AVG(salary),department_id
FROM employees
WHERE email LIKE '%a%'
GROUP BY department_id 

#查询有奖金的每个领导收下员工的最高工资
SELECT MAX(salary),manager_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY manager_id;

#添加筛选条件
#添加分组后的条件
#查询那个部门的员工个数>2

#1.查询每个部门的员工个数
SELECT COUNT(*),department_id 
FROM employees
GROUP BY department_id;
#2.根据1的结果进行筛选，查询那个部门的员工个数

SELECT COUNT(*),department_id 
FROM employees
GROUP BY department_id
HAVING COUNT(*)>2;

#查询每个工种有奖金的工种的最高工资大于12000的工种编号和其最高工资
SELECT MAX(salary),job_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING MAX(salary)>12000;


#查询领导编号>102的每个领导收下的最低工资>5000的领导编号，以及其最低工资
SELECT MIN(salary), manager_id
FROM employees
WHERE manager_id>102
GROUP BY manager_id
HAVING MIN(salary)>5000;

#按表达式分组或函数分组

#案例： 按员工姓名的长度分组，查询每一组的员工个数，筛选员工个数>5的有哪些
SELECT COUNT(*) ,LENGTH(last_name) 名字长度
FROM employees
GROUP BY LENGTH(last_name)
HAVING COUNT(*)>5;

#安多个字段进行分组

#查询每个部门每个工种的员工的平均工资

SELECT AVG(salary) ,department_id ,job_id
FROM employees
GROUP BY department_id,job_id;

#添加排序

#查询每个部门每个工种的员工的平均工资，并且平均工资的高低排序
SELECT AVG(salary) ,department_id ,job_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id,job_id
HAVING AVG(salary)>10000
ORDER BY AVG(salary) ASC;

#练习
#查询各job_id的员工工资的最大值，最小值，平均值，总和，并按照job_id升序
SELECT MAX(salary),MIN(salary),AVG(salary),SUM(salary)
FROM employees
GROUP BY job_id
ORDER BY job_id ASC;


