USE [BusinessData]
GO
/****** Object:  StoredProcedure [bronze].[load_bronze]    Script Date: 1/31/2026 9:03:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   procedure [bronze].[load_bronze] as 
begin
declare @start_time datetime,@end_time datetime,@batch_start_time datetime,@batch_end_time datetime;

print'============================================================================================================================';
print'Loading Bronze Layer...';
print'============================================================================================================================';

print'----------------------------------------------------------------------------------------------------------------------------';
print'Loading CRM Tables...';
print'----------------------------------------------------------------------------------------------------------------------------';
-- Inserting data to bronze layer from crm source
set @batch_start_time = getdate();
set @start_time = getdate();
print'>>Truncating Data from bronze.crm_cust_info';
truncate table bronze.crm_cust_info;
print'>>Inserting Data to bronze.crm_cust_info';
bulk insert bronze.crm_cust_info
from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
with
(
  firstrow = 2,
  fieldterminator = ',',
  tablock
);
set @end_time = getdate();
print'>>Loading Duretion>>' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
set @start_time = getdate();
print'>>Truncating Data from bronze.crm_prd_info';
truncate table bronze.crm_prd_info;
print'>>Inserting Data to bronze.crm_prd_info';
bulk insert bronze.crm_prd_info
from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
with
(
  firstrow = 2,
  fieldterminator = ',',
  tablock
);
set @end_time = getdate();
print'>>Loading Duretion>>' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
set @start_time = getdate();
print'>>Truncating Data from bronze.crm_sales_details';
truncate table bronze.crm_sales_details;
print'>>Inserting Data to bronze.crm_sales_details';
bulk insert bronze.crm_sales_details
from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
with
(
  firstrow = 2,
  fieldterminator = ',',
  tablock
);
set @end_time = getdate();
print'>>Loading Duretion>>' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';

-- Inserting data to bronze layer from erp source
set @start_time = getdate();
print'----------------------------------------------------------------------------------------------------------------------------';
print'Loading ERP Tables...';
print'----------------------------------------------------------------------------------------------------------------------------';
print'>>Truncating Data from bronze.erp_cust_az12';
truncate table bronze.erp_cust_az12;
print'>>Inserting Data tobronze.erp_cust_az12';
bulk insert bronze.erp_cust_az12
from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
with
(
  firstrow = 2,
  fieldterminator = ',',
  tablock
);
set @end_time = getdate();
print'>>Loading Duretion>>' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
set @start_time = getdate();
print'>>Truncating Data from bronze.erp_loc_a101';
truncate table bronze.erp_loc_a101;
print'>>Inserting Data to bronze.erp_loc_a101';
bulk insert bronze.erp_loc_a101
from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
with
(
  firstrow = 2,
  fieldterminator = ',',
  tablock
);
set @end_time = getdate();
print'>>Loading Duretion>>' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
set @start_time = getdate();
print'>>Truncating Data from bronze.erp_px_cat_g1v2';
truncate table bronze.erp_px_cat_g1v2;
print'>>Inserting Data to bronze.erp_px_cat_g1v2';
bulk insert bronze.erp_px_cat_g1v2
from 'C:\All data for prectice\New folder\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
with
(
  firstrow = 2,
  fieldterminator = ',',
  tablock
);
set @end_time = getdate();
print'>>Loading Duretion>>' + cast(datediff(second,@end_time,@start_time) as nvarchar) + 'seconds';
set @batch_end_time = getdate();
print'>>Batch Loading Duretion>>' + cast(datediff(second,@batch_end_time,@batch_start_time) as nvarchar) + 'seconds';
end
exec bronze.load_bronze
