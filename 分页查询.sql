#分页查询

/*
应用场景：当要显示的数据，一页显示不全，需要分页提交SQL请求
语法：
	select 查询列表
	from表
	【join type join 表2
	on 连接条件
	where 筛选条件
	group by 分组字段
	having 分组后的筛选
	order by 排序的字段】
	limit offset，size
	
	offset 要显示条目的起始索引（起始索引从0开始）
	size 要显示的条目个数
*/
#案例1：查询前五条员工信息

SELECT *
FROM employees
LIMIT 0,5;

#查询第11条到25条
SELECT *
FROM employees
LIMIT 10,15;
