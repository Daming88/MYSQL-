#二.分组函数
/*
功能：用作统计使用，又称为聚合函数或者统计函数或者组函数

分类
sum 求和， avg平均值， max最大值 min最小值 count计算个数
特点
1. sum，avg一般适用于数值类型
   max，min，count合一处理任何类型
2.是否忽略null值
	以上的分组函数都忽略null值

3.可以和distinct搭配使用

4.count单独介绍
一般count（*）用作统计函数

5.补充
和分组函数一同查询的字段要求是group by 后的字段
*/

#简单使用
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT COUNT(salary) FROM employees;

#2.参数支持哪些类型 

SELECT SUM(last_name), AVG(last_name) FROM employees;

#3.是否忽略null值
SELECT SUM(commission_pct),AVG(commission_pct) FROM employees;

#4.和distinct搭配

SELECT SUM(DISTINCT salary) ,SUM(salary) FROM employees;

SELECT COUNT(DISTINCT salary),COUNT(salary) FROM employees;

#5count函数的详细介绍

SELECT COUNT(salary) FROM employees;

SELECT COUNT(*) FROM employees;

SELECT COUNT(1) FROM employees;

效率：
MYISAM存储引擎下， count（*）的效率最高（因为里面有一个单独的计数器）
INNODB存储引擎下， COUNT （*）和count（1）的效率差不多，比count（字段）要高一些

#6 和分组函数一同查询的字段有限制

SELECT AVG(salary),employee_id FROM employees;