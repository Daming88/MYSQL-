`jihcu``myemployees` 
SELECT 
  last_name 
FROM
  employees ;
  /*
1.查询表可以是：表中的字段，常量值，表达式，函数  
  2.查询的结果是一张虚拟表
  */
  #1.查询表中的单个字段
  SELECT `last_name` FROM `employees`;
  #查询多个字段
  SELECT `first_name`,`last_name`,`email` FROM `employees`;
  #查询所有可有用*，也可以用多个字段方法
  #4.查询常量值
  SELECT 100;
  #查询表达式
  SELECT 100%98;
  #查询函数
  SELECT VERSION();
  #起别名使用as或者空格
  SELECT 100%98 AS 结果;
  SELECT 100%98  结果;
  
  #案例：查询salary，显示结果为out put
  SELECT `salary` AS 'out put' FROM  `employees`;
  
  #去重
  
  #案例：查询员工表设计到的部门编号
  SELECT DISTINCT `department_id` FROM `employees`;
  
#+号的作用
/*
	java中的作用
	1.运算符：两个操作数都为数字类型
	2.连接符，只要有一个操作数是字符串
	mysql中+号的作用
	仅仅只有一个功能：运算符
	例如： 
	SELECT 100+98 AS 结果; 两个操作数为数值类型，则做加法运算
	SELECT ‘100’+98 AS 结果; 其中一方为字符类型，试图将字符类型转换成数值类型，如果转换成功就继续加法运算
	SELECT ‘100’+98 AS 结果;  如果转换失败，则把字符型类型数值转换成0
	select null+10； 只要其中一方为null，则结果肯定为null
		注意null和任何一个操作数使用结果都为null
		此时可以使用一个函数ifnull来判断
		select ifnull(`commission_pct`,0) as 奖金率 from `employees`;
*/
#查询员工名和性连接成一个字段，并显示为姓名
SELECT 
  `last_name` + `first_name` AS 姓名 
FROM
  `employees` ;#不成工
  
 SELECT 
	CONCAT(first_name,last_name) AS 姓名
FROM
       `employees`;
	
  


