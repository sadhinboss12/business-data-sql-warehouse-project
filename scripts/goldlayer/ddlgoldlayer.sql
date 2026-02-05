/*
This ddl for renaming coulmn name and some cleanig data and joining tables and creating view .
*/
----------- ddl for joining tables and creating gold.dim_customers view.---------------------------------------------
create view gold.dim_customers as
select
row_number() over (order by cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as firstname,
ci.cst_lastname as lastname,
la.cntry as country,
ci.cst_marital_status as marital_status,
case
	when ci.cst_gndr != 'n\a' then ci.cst_gndr
	else ca.gen
end gender,
ca.bdate as birth_date,
ci.cst_create_date as create_date,
ci.dwh_create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid


select * from gold.dim_customers



select top 2 * from silver.crm_prd_info 
select top 2 * from silver.erp_px_cat_g1v2
----------- ddl for joining tables and creating gold.dim_products view.---------------------------------------------
create view gold.dim_products as
select
row_number() over (order by pn.prd_id ) as product_key,
pn.prd_id as product_id,
pn.cat_id as category_id,
pn.prd_key as product_number,
pc.cat as category,
pc.subcate as subcate,
pc.maintenance,
pn.prd_nm as product_name,
pn.prd_line as product_line,
pn.prd_cost as product_cost,
pn.prd_start_dt,
pn.dwh_create_date
from silver.crm_prd_info as pn
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id

select  * from gold.dim_products

select  * from silver.crm_sales_details 

select  * from gold.dim_customers
select   * from gold.dim_products

----------- ddl for joining tables and creating gold.fact_sales view.---------------------------------------------
create view gold.fact_sales as
select 
sd.sls_ord_num,
sd.sls_prd_key,
dp.product_id,
dc.customer_key,
sd.sls_cust_id,
sd.sls_order_dt,
sd.sls_ship_dt,
sd.sls_due_dt,
sd.sls_sales,
sd.sls_quantity,
sd.sls_price,
sd.dwh_create_date
from silver.crm_sales_details sd
left join gold.dim_customers dc
on sd.sls_cust_id = dc.customer_id
left join gold.dim_products dp
on sd.sls_prd_key = dp.product_number

select * from gold.fact_sales
