CREATE OR REPLACE PACKAGE XXNBTY_MSCEXT09_PURGE_PLAN_PKG
AS
----------------------------------------------------------------------------------------------
/*
Package Name: XXNBTY_MSCEXT09_PURGE_PLAN_PKG
Author's Name: Erwin Ramos
Date written: 02-Jul-2015
RICEFW Object: N/A
Description: Purging of archive plan based on the predefined retention period. 
Program Style: 

Maintenance History: 

Date			Issue#		Name					Remarks	
-----------		------		-----------				------------------------------------------------
02-Jul-2015				 	Erwin Ramos				Initial Development


*/
--------------------------------------------------------------------------------------------

PROCEDURE purge_archive_plan (x_errbuf             OUT VARCHAR2,
                             x_retcode              OUT VARCHAR2);

END XXNBTY_MSCEXT09_PURGE_PLAN_PKG;
/
show errors;