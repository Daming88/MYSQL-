`myemployees`
#条件查询
/*
语法
	select 
		查询列表
	from
		表名
	where
		筛选条件;

分类：
	1.按条件表达式筛选
		条件运算符：> < = != <> >= <=
	2.按逻辑表达式
		逻辑运算符：&&     ||  ！
			    and    or   not
	3.模糊查询
		like
		between and
		in
		is null
	
*/
#一·按条件表达式筛选

#案例：查询工资>12000的员工

SELECT 
	*
FROM 
	`employees`
WHERE
	`salary`>12000;
#查询部门编号不等于90号的员工名和部门信息
SELECT 
	`last_name`,
	`department_id`
FROM
	`employees`
WHERE
	`department_id`!=90;
#按逻辑表达式，用于连接条件表达式的

#查询工资在10000到20000之间的
SELECT
	last_name,
	salary,
	commission_pct
FROM 
	employees
WHERE
	salary>=10000
AND
	salary<=20000;
#查询部门不是在90到110之间，或者工资高于15000的员工信息
SELECT 
	*
FROM
	employees
WHERE
	department_id<90 OR department_id>110 OR salary>15000;
#模糊查询
/*
like
特点：
1.一般和通配符搭配使用
通配符：
	%任意多个字符，包含0个字符
	_人以单个字符
	
between and
in
is null
is not null
*/
#1.like

#查询员工名中包含字符a的员工信息

SELECT
	*
FROM 
	employees
WHERE
	last_name LIKE '%a%';
#查询员工名中第三个字符为e，第五个字符为a的员工名和工资
SELECT 
	last_name,
	salary
FROM
	employees
WHERE
	last_name LIKE '__n_l%';

#查询员工名中第二个字符为_的员工名
SELECT 
	last_name,
	salary
FROM
	employees
WHERE
	last_name LIKE '_$_%' ESCAPE '$';
#2.between and
/*
1.使用between and 可以提高语句的简洁度
2.包含临界值
3.两个临界值不要调换顺序
*/

#查询员工编号在100到120之间的员工信息

SELECT
	*
FROM
	employees
WHERE 
	employee_id>=100 AND employee_id<=120;
	
SELECT
	*
FROM
	employees
WHERE 
	employee_id BETWEEN 100 AND 120;

#3.in
/*
	1.使用in提高语句简洁度
	2.in列表的值类型必须一致或兼容
*/

#查询员工的工种编号是 IT_PROG AD_VP AD_PRES中的一个员工名和工种编号

SELECT 
	last_name,
	job_id
FROM 
	employees
WHERE
	job_id IN ('IT_PROT' , 'AD_VP' ,'AD_PRES');

#4.is null
/*
	=或<>不能判断null值
*/
#案例：查询没有奖金的员工名和奖金率
SELECT 
	last_name,
	commission_pct
FROM
	employees
WHERE
	commission_pct IS NOT NULL;

#安全等于 <=> 也可以判断null

SELECT 
	last_name,
	commission_pct
FROM
	employees
WHERE
	commission_pct <=> NULL;
	
/*
is null 只可以判断null值
<=>     既可以判断null值，又可以判断普通的数值，可读性能较低
*/


