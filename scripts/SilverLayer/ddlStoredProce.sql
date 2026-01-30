create or alter procedure silver.load_silver as
begin
	declare @start_time datetime,@end_time datetime,@batch_start_time datetime,@batch_end_time datetime;
	
	set @batch_start_time = getdate();
		print'===================================================';
		print'Loading Silver Layer';
		print'===================================================';
		print'===================================================';
		print'Loading CRM TABLES';
		print'===================================================';
		set @start_time = getdate();
		print'>>Truncating table --silver.crm_cust_info'
		truncate table silver.crm_cust_info;
		print'>>Inserting data in table --silver.crm_cust_info'
		insert into silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)
		select
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case
			when trim(upper(cst_marital_status)) = 'M' then 'Married'
			when trim(upper(cst_marital_status)) = 'S' then 'Single'
			when cst_marital_status is null then 'n\a'
		end cst_marital_status,
		case
			when trim(upper(cst_gndr)) = 'M' then 'Male'
			when trim(upper(cst_gndr)) = 'F' then 'Female'
			when cst_gndr is null then 'n\a'
		end cst_gndr,
		cst_create_date
		from (
		select
		*,
		row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info)t
		where flag_last = 1 and cst_id is not null
		set @end_time = getdate();
		print'>>Load Duration>>' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds'
		print'>>-------------------------'
		--Loading silver.crm_prd_info
		set @start_time = getdate();
		print'>>Truncating table --silver.crm_prd_info'
		truncate table silver.crm_prd_info;
		print'>>Inserting data in table --silver.crm_prd_info'
		insert into  silver.crm_prd_info
		(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		select
		prd_id,
		replace(substring(prd_key,1,5),'-','_') as cat_id,
		substring(prd_key,7,len(prd_key)) as prd_key,
		prd_nm,
		prd_cost,
		case 
			when trim(upper(prd_line)) = 'M' then 'Mountain'
			when trim(upper(prd_line)) = 'R' then 'Road'
			when trim(upper(prd_line)) = 'S' then 'other sales'
			when trim(upper(prd_line)) = 'T' then 'Touring'
			else 'n\a'
		end as prd_line,
		cast(prd_start_dt as date) prd_start_dt,
		cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
		from bronze.crm_prd_info
		set @end_time = getdate();
		print'>>Load Duration>>' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds'
		print'>>-------------------------'
		--Loading silver.crm_sales_details
		set @start_time = getdate();
		print'>>Truncating table --silver.crm_sales_details'
		truncate table silver.crm_sales_details;
		print'>>Inserting data in table --silver.crm_sales_details'
		insert into  silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)
		select
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case
			when sls_order_dt <=0 or len(sls_order_dt) != 8 then null
			else cast(cast(sls_order_dt as varchar) as date)
		end sls_order_dt,
		case
			when sls_ship_dt <=0 or len(sls_ship_dt) != 8 then null
			else cast(cast(sls_ship_dt as varchar) as date)
		end sls_ship_dt,
		case
			when sls_due_dt <=0 or len(sls_due_dt) != 8 then null
			else cast(cast(sls_due_dt as varchar) as date)
		end sls_due_dt,
		case 
			when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price) then sls_quantity * abs(sls_price)
			else sls_sales
		end sls_sales,
		sls_quantity,
		case
			when sls_price <= 0 or sls_price is null  then sls_sales / nullif(sls_quantity,0)
			else sls_price
		end sls_price
		from bronze.crm_sales_details
		set @end_time = getdate();
		print'>>Load Duration>>' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds'
		print'>>-------------------------'
		--Loading silver.erp_cust_az12
		set @start_time = getdate();
		print'===================================================';
		print'Loading ERP TABLES';
		print'===================================================';
		--Loading silver.erp_cust_az12
		set @start_time = getdate();
		print'>>Truncating table --silver.erp_cust_az12'
		truncate table silver.erp_cust_az12;
		print'>>Inserting data in table --silver.erp_cust_az12'
		insert into silver.erp_cust_az12(
		cid,
		bdate,
		gen
		)

		select
		case
			when cid like 'NAS%' then substring(cid,4,len(cid))
			else cid
		end cid,
		case
			when bdate > getdate() then null
			else bdate
		end bdate,
		case
			when upper(gen) in ('F','FEMALE') then  'Female'
			when upper(gen) in ('M','MALE') then  'Male'
			else 'n/a'
		end gen
		from bronze.erp_cust_az12
		set @end_time = getdate();
		print'>>Load Duration>>' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds'
		print'>>-------------------------'
		--Loading silver.erp_loc_a101
		set @start_time = getdate();
		print'>>Truncating table --silver.erp_loc_a101'
		truncate table silver.erp_loc_a101;
		print'>>Inserting data in table --silver.erp_loc_a101'
		insert into silver.erp_loc_a101(
		cid,
		cntry
		)
		select 
		replace(trim(cid),'-','') cid,
		case
			when trim(cntry) = 'DE' then 'Germany'
			when trim(cntry) in ('US','USA') then 'United States'
			when cntry is null or cntry = '' then 'n/a'
			else cntry
		end cntry
		from bronze.erp_loc_a101
		print'>>Truncating table --silver.erp_px_cat_g1v2'
		truncate table silver.erp_px_cat_g1v2;
		print'>>Inserting data in table --silver.erp_px_cat_g1v2'
		insert into silver.erp_px_cat_g1v2(
		id,
		cat,
		subcate,
		maintenance
		)
		select 
		id,
		cat,
		subcate,
		maintenance
		from bronze.erp_px_cat_g1v2
		set @end_time = getdate();
		print'>>Load Duration>>' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'seconds'
		print'>>-------------------------'
	set @batch_end_time = getdate();
	print'>>Batch Load Duration>>' + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar) + 'seconds'
end
exec silver.load_silver
