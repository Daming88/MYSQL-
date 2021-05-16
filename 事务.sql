#TCL
/*
Transaction Control Language 事务控制语言
事务：
一个或一组SQL语句，组成的一个执行单元，这个执行单元要么全部执行，要么全部不执行。

案例：转账
张三丰 1000
郭襄   1000

update 表 set 张三丰余额=500 where name =‘张三丰’
意外
update 表 set 郭襄的余额=1500 where name=‘郭襄’

事务的ACID属性
1.原子性
	原子性是指事务是一个不可分割的工作单位，事务的操作要么都发生，要么都不发生
2.一致性：
	事务必须使数据库从一个一致性状态变换到另外一个一致性状态
3.隔离性：
	事务的隔离性是指一个事务的执行不能被其他事务干扰，即一个事物内部的操作及使用的数据对并发的其他事务 是隔离的，并发执行的各个事物之间不能互相干扰
4.持久性：
	持久性是指一个事务一旦被提交，它对数据库中数据的改变就是永久性的，接下来的其他操作和数据库故障不应该对其有任何影响
	

事物的创建
隐式事务：事务没有明显的开启和结束的标记
比如：insert，update，delete语句

显示事务:事务具有明显的开启和结束的标记
前提必须设置自动调焦功能为禁用
set autocommit=0;

步骤1：开始事务
set autocommit=0;
start transaction；可选的
步骤2：编写事务中的SQL语句(select ，insert，update，delete)
语句1；
语句2；
...
步骤3：结束事务
commit ；提交事务
rollback；回滚事务

savepoint 节点名;设置保存点


注意：
对于同时运行的多个事务，当这些事务访问数据库中相同的数据时，如果没有采取必要的隔离机制，就会导致各种并发问题：
脏读：对于两个事物T1，T2，T1读取了已经被T2更新但还没被提交的字段
      之后，若T2回滚，T1读取的内容就是临时且无效的。（一般出现于更新）
不可重复度：对于两个事物T1,T2。T1读取了一个字段，然后T2更新了该字段之后，T1再去读取同一个字段，值就不同了。
幻读：对于两事务T1,T2。T1从一个表中读取了一个字段，然后T2在该表中插入了一些新的行之后，如果T1再次读取同一个表，就会多出几行	（一般出现于插入）

数据库事务的隔离性：数据库系统必须具有隔离并发运行各个事务的能力，使它们不会相互影响，避免各种并发问题

MySQL支持4种事务隔离级别。mysql默认的事务隔离级别是：REPEATABLE READ（可重复读）

事物的隔离级别
				脏读		不可重复度	 幻读
read uncommitted		出现 		出现		 出现
read committed			不出现		出现		 出现
repeatable read			不出现		不出现		 出现
serializable			不出现		不出现		 不出现
mysql中默认 第三个隔离级别repeatable read
Oracle中默认第二个read committed

select @@transaction_isolation；查看当前数据库的隔离级别
set session transaction isolation level 隔离级别;修改当前数据库的隔离级别

*/
#查看存储引擎
SHOW ENGINES;

SHOW VARIABLES LIKE 'autocommit';

#演示事务的使用步骤

SET autocommit=0;
START TRANSACTION;
UPDATE account SET balance=500 WHERE username='张无忌';
UPDATE account SET balance=1500 WHERE username='赵敏';
#commit;
ROLLBACK;

#2.delete和truncate在事务使用时的区别(delete支持事务的回滚，truncate不支持事务的回滚)

#演示delete
SET autocommit=0;
START TRANSACTION;
DELETE FROM account;
ROLLBACK;

#演示truncate 
SET autocommit=0;
START TRANSACTION ;
TRUNCATE TABLE account;
ROLLBACK;

#3.演示savepoint的使用
SET autocommit=0;
START TRANSACTION;
DELETE FROM account WHERE id=25;
SAVEPOINT a;#设置保存点
DELETE FROM account WHERE id=28;
ROLLBACK TO a;#回滚到保存点
SELECT * FROM account;