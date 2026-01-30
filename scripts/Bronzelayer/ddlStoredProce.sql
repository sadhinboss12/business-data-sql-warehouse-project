USE [PracticeDataWareHouse]
GO
/****** Object:  StoredProcedure [bronze].[load_bronze]    Script Date: 1/30/2026 12:05:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   procedure [bronze].[load_bronze] as 
begin
	-- CRM TABLES DATA INSERTING
	truncate table bronze.crm_cust_info;

	bulk insert bronze.crm_cust_info
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);


	truncate table bronze.crm_prd_info;

	bulk insert bronze.crm_prd_info
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);

	truncate table bronze.crm_sales_details;

	bulk insert bronze.crm_sales_details
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
    );
	-- ERP TABLES DATA INSERTING
	truncate table bronze.erp_cust_az12;
	bulk insert bronze.erp_cust_az12
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);

	truncate table bronze.erp_cust_loce_info;

	bulk insert bronze.erp_cust_loce_info
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);

	truncate table bronze.erp_px_cat_az12;

	bulk insert bronze.erp_px_cat_az12
	from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	with(
		firstrow = 2,
		fieldterminator = ',',
		tablock
	);
end
