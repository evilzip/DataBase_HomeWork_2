create table customer_20240101 (
    customer_id int4
    ,first_name varchar(50)
    ,last_name varchar(50)
    ,gender varchar (30)
    ,dob varchar (50)
    ,job_title varchar(50)
    ,job_industry_category varchar(50)
    ,wealth_segment varchar(50)
    ,deceased_indicator varchar(50)
    ,owns_car varchar(30)
    ,address varchar(50)
    ,postcode varchar(30)
    ,state varchar(30)
    ,country varchar(30)
    ,property_valuation int4
    );
   
    
create table transaction_20240101 (
    transaction_id int4
    ,product_id int4
    ,customer_id int4
    ,transaction_date varchar(30)
    ,online_order varchar(30)
    ,order_status varchar(30)
    ,brand varchar(30)
    ,product_line varchar(30)
    ,product_class varchar(30)
    ,product_size varchar(30)
    ,list_price float4
    ,standard_cost float4
    );
    
   -- 1.(1 балл) Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов. 
select 
   	distinct brand
from
	transaction_20240101 t
where
	standard_cost > 1500;
   
  --2. (1 балл) Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.
select
	transaction_id
	,order_status
	,transaction_date 
from
	transaction_20240101 t 
where
	order_status = 'Approved'
	and
	transaction_date :: date between '2017-04-01' and '2017-04-09'
  ;
 
 -- 3. (1 балл) Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
 select 
 	distinct job_title 
 from
     customer_20240101 c 
 where
 	job_title like 'Senior%'
 	and (
		job_industry_category = 'IT'
		or 
    	job_industry_category = 'Financial Services'
    	);
    
 
-- 4. (1 балл) Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
--------Если не считать пустое поле брэнда как его название, то так:    
 select 
 	distinct brand
 from
     transaction_20240101 t  
 where
 	brand != ''
 	and
 	customer_id in (
 		select
 			customer_id
 		from
 			customer_20240101 c
 		where
 			job_industry_category = 'Financial Services'
 		);
 	
 -------Если пустое поле Брэнда тоже считать брэндом, то вот так:
 select 
 	distinct brand
 from
     transaction_20240101 t  
 where
 	customer_id in (
 		select
 			customer_id
 		from
 			customer_20240101 c
 		where
 			job_industry_category = 'Financial Services'
 		);	
 
 
-- 5. (1 балл) Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
 select 
 	customer_id  
 from
     customer_20240101 c2  
 where
 	customer_id in (
 		select
 			customer_id
 		from
 			transaction_20240101 t 
 		where
 			online_order = 'True'
 			and 
 			brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
 			)
  limit 10;
 	
 
 
-- 6. (1 балл) Вывести всех клиентов, у которых нет транзакций.
 select 
 	c.customer_id  
 from
	transaction_20240101 t 
 right join customer_20240101 c
 	on t.customer_id = c.customer_id
 where 
 	t.customer_id is null 
  ; 
 
 
-- 7. (2 балла) Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
 select 
 	c.customer_id
 from
	transaction_20240101 t 
 inner join customer_20240101 c on
 	t.customer_id = c.customer_id
 where
 	c.job_industry_category = 'IT'
 		and
 	t.standard_cost = (
 		select
 			max(standard_cost)
 		from transaction_20240101 t2
 		) 
  ;  
 
 
-- 8. (2 балла) Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
  select 
 	distinct c.customer_id  
 from
	transaction_20240101 t 
 inner join customer_20240101 c
 	on t.customer_id = c.customer_id 
 where
 	(c.job_industry_category = 'IT'
 		or
 	c.job_industry_category = 'Health')
 		and 
 	t.order_status = 'Approved'
 		and 
 	t.transaction_date :: date between '2017-07-07' and '2017-07-17'
 	;
  
  