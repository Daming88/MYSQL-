#子查询练习

#1.查询工资最低的员工信息：last_name，salary

SELECT last_name,salary
FROM employees
WHERE salary=(
	SELECT MIN(salary)
	FROM employees
);

#2.查询平均工资最低的部门

#查询各个部门的平均工资
SELECT AVG(salary),department_id
FROM employees
GROUP BY department_id;
#查询1结果上的最低工资
SELECT MIN(ag)
FROM (
	SELECT AVG(salary) ag,department_id
	FROM employees
	GROUP BY department_id
) ag_dep
#3查询哪个部门编号的平均工资等于2
select avg(salary),department_id
from employees
group by department_id
having avg(salary)=(
	SELECT MIN(ag)
	FROM (
		SELECT AVG(salary) ag,department_id
		FROM employees
		GROUP BY department_id
	) ag_dep
);
#4.查询部门信息

select d.*
from departments d
where d.`department_id`=(
	SELECT department_id
	FROM employees
	GROUP BY department_id
	HAVING AVG(salary)=(
		SELECT MIN(ag)
		FROM (
			SELECT AVG(salary) ag,department_id
			FROM employees
			GROUP BY department_id
		) ag_dep
	)
);

#方式二
#查询各个部门的平均工资的部门编号
SELECT department_id
FROM employees
GROUP BY department_id
order by avg(salary) asc
limit 0,1;
#求出1结果的部门所有信息
select * 
from departments d
where d.`department_id`=(
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) ASC
LIMIT 0,1
);
