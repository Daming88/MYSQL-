#进阶：排序查询

/*
语法
	select 查询列表
	from 表
	[where 筛选条件]
	order 排序的列表 【desc|asc】
	
	asc:升序（默认）
	desc降序
	支持单个字段，多个字符段，表达式，函数，别名
	一般放在查询语句的最后，limit子句除外
*/

#查询员工信息，要求工资从高到低
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY salary ASC;

#查询部门编号>=90的员工信息，按入职时间的先后进行排序
SELECT *
FROM employees
WHERE `department_id`>=90
ORDER BY hiredate ASC;

#按表达式排序 按照年薪的高低显示员工的信息和年薪
SELECT *,salary*12*(1+IFNULL(commission_pct,0)) 年薪
FROM employees
ORDER BY  salary*12*(1+IFNULL(commission_pct,0)) DESC;

#按照年薪的高低显示员工的信息和年薪【按照别名排序】
SELECT *,salary*12*(1+IFNULL(commission_pct,0)) 年薪
FROM employees
ORDER BY  年薪 DESC;

#按照姓名的长度显示姓名和工资【按照函数排序】

SELECT LENGTH(last_name) 字节长度,last_name,salary*12*(1+IFNULL(commission_pct,0)) 年薪
FROM employees
ORDER BY LENGTH(last_name) DESC;

#查询员工信息，要求先按照工资排序，在按照员工编号排序[安多个字段排序]
SELECT * 
FROM employees
ORDER BY salary ASC,employee_id DESC;


