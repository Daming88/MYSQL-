#函数
/*
含义：一组预先编译好的SQL语句集合，理解成批处理语句
1.提高代码的重用性
2.简化操作
3.减少编译次数并且减少了和数据库服务器的连接次数，提高效率

和存储过程的区别：

存储过程：可以有0个返回，或者可以有多个返回
函数：有且仅有1个返回，适合做处理数据返回一个结果
*/

#一.创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
BEGIN
	函数体
END

/*
注意
参数列表包含两部分：
参数名 参数类型

函数体：肯定有return语句，如果没有会报错
如果return语句没有放在函数体的最后也不报错，但不建议

return 值；

3.函数体仅有一句SQL语句，则可以省略begin end
4.使用 delimiter语句作为设置结束标记

*/

#二.调用语法
SELECT 函数名(参数列表) 

#------------------------案例演示-------------
#1.无参又返回
#案例：返回公司的员工个数
#注意需要设置set global log_bin_trust_function_creators=1;
CREATE FUNCTION myf1() RETURNS INT
BEGIN
	DECLARE c INT DEFAULT 0;
	SELECT COUNT(*) INTO c
	FROM employees;
	RETURN c;
END $

SELECT  myf1()$

#2.有参数返回
#案例：根据员工名，返回他的工资
CREATE FUNCTION myf2(empName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	#declare salary double default 0;
	SET @sal=0;#定义用户变量
	SELECT employees.`salary` INTO @sal#赋值 
	FROM employees
	WHERE employees.`last_name`=empName;
	RETURN @sal;
END $

SELECT myf2('Kochhar') $

#案例2：根据部门号，返回 该部门的平均工资
CREATE FUNCTION myf3(deptName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	DECLARE avgsal DOUBLE DEFAULT 0;
	SELECT AVG(salary) INTO avgsal
	FROM employees e
	INNER JOIN departments d
	ON e.`department_id`=d.`department_id`
	WHERE d.`department_name`=deptName;
	RETURN avgsal;
END $

#三.查看函数
SHOW CREATE FUNCTION myf3;

#四.输出函数
DROP FUNCTION myf3;

#案例
#一.创建函数，实现传入两个float，返回二者之和
CREATE FUNCTION myf4(a FLOAT,b FLOAT) RETURNS FLOAT
BEGIN
	SET @sum=a+b;
	RETURN @sum;
END $

SELECT myf3(1,2) $
