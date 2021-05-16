#视图
/*
含义：虚拟表，和普通表一样使用
mysql5.1版本出现的新特性，是通过表动态生成的数据，只保存了SQL逻辑，不保存查询结果

重用SQL语句
简化复杂的SQL操作，不必知道它的查询细节
保护数据，提高安全性

		创建语法的关键字		是否存储数据		使用
视图		create view			只是保存了SQL逻辑	增删改查，一般不用于增删改
表		create table			保存了数据		增删改查

*/

#案例：查询姓张的学生名和专业名`students`
SELECT stuname,marjorname
FROM  stuinfo s
INNER JOIN major m 
ON s.`majorid`=m.`id`
WHERE s.stuname LIKE '张%';

#使用视图
CREATE VIEW v1
AS
SELECT stuname,marjorName
FROM  stuinfo s
INNER JOIN major m 
ON s.`majorid`=m.`id`;

SELECT * FROM v1 WHERE stuname LIKE '张%';


#一.创建视图
USE myemployees;
/*
语法：
create view 视图名
as
查询语句

*/

#1.查询有邮箱中包含a字符的员工名，部门名和工种信息
#创建
CREATE VIEW myv1
AS
SELECT last_name,department_name,job_title
FROM employees e
INNER JOIN departments d
ON e.`department_id`=d.`department_id`
INNER JOIN jobs j
ON e.`job_id`=j.`job_id`;
#使用
SELECT * FROM myv1 WHERE last_name LIKE '%a%';

#2.查询各部门的平均工资级别

#创建视图，查看每个部门的平均工资
CREATE VIEW myv2
AS
SELECT AVG(salary) ag ,department_id
FROM employees
GROUP BY department_id;

#使用
SELECT myv2.`ag`,g.`grade_level`
FROM myv2
INNER JOIN job_grades g
ON myv2.`ag` BETWEEN g.`lowest_sal` AND g.`highest_sal`;


#3.查询平均工资最低的部门信息
SELECT * FROM myv2 ORDER BY ag LIMIT 1;

#4.查询平均工资最低的部门名和工资

CREATE VIEW myv3
AS 
SELECT * FROM myv2 ORDER BY ag LIMIT 1;

SELECT d.`department_name`,m.`ag`
FROM myv3 m
INNER JOIN departments d
ON  m.`department_id`=d.`department_id`;

#二.视图的修改
#方式一：
/*
create or replace view 视图名
as
查询语句;
*/
#例如
SELECT * FROM myv3;

CREATE OR REPLACE VIEW	myv3
AS
SELECT AVG(salary),job_id
FROM employees
GROUP BY job_id;

#方式二：
/*
语法
alter view 视图名
as
查询语句
*/

ALTER VIEW myv3
AS 
SELECT * FROM employees;

#三.删除视图
/*
语法:
drop view 视图名，视图名....;
*/
DROP VIEW myv1,myv2,myv3;

#四.查看视图
/*
语法：desc 视图名
或者
show create view 视图名
*/
DESC myv3;

#五.视图的更新
CREATE OR REPLACE VIEW myl
AS
SELECT last_name,email
FROM employees;

SELECT * FROM myl;
#1.插入
INSERT INTO myl VALUES('张飞','zf@qq.com');

SELECT * FROM myl WHERE last_name='张飞';
SELECT * FROM employees WHERE last_name='张飞';

#2.修改
UPDATE myl SET last_name='张无忌' WHERE last_name='张飞';

SELECT * FROM myl WHERE last_name='张无忌';
SELECT * FROM employees WHERE last_name='张无忌';

#删除
DELETE FROM	myl WHERE last_name='张无忌';

#具备以下特点的视图不允许更新的

#1.包含以下关键字的SQL语句：分组函数，distinct，group by，having，union或者union all
CREATE OR REPLACE VIEW myv1
AS 
SELECT MAX(salary) m,department_id
FROM employees 
GROUP BY department_id;

SELECT * FROM myv1;

UPDATE myv1 SET m=9000 WHERE department_id=10;

#2.常量视图 
CREATE OR REPLACE VIEW myv2
AS 
SELECT 'John' NAME;
SELECT * FROM myv2;
UPDATE myv2 SET NAME='Lucy';

#3.select 中包含子查询
CREATE OR REPLACE VIEW myv3
AS
SELECT (SELECT MAX(salary) FROM employees) 最高工资;
UPDATE myv3 SET 最高工资=100000;

#4.join 
CREATE OR REPLACE VIEW myv4
AS
SELECT last_name,department_name
FROM employees e
INNER JOIN departments d
ON e.department_id=d.department_id;

SELECT * FROM myv4;

UPDATE myv4 SET last_name='张飞' WHERE last_name='Whalen';
INSERT INTO myv4 VALUES('陈','xxx');


#5.from一个不能更新的视图

CREATE OR REPLACE VIEW myv5
AS
SELECT * FROM myv3;
SELECT * FROM myv5;

#6.where 子句的子查询引用from子句中的表
CREATE OR REPLACE VIEW myv6
AS
SELECT last_name,email,salary
FROM employees 
WHERE employee_id IN(
	SELECT manager_id
	FROM employees
	WHERE manager_id IS NOT NULL
);

SELECT * FROM myv6;
UPDATE myv6 SET salary=1000 WHERE last_name='K_ing';



