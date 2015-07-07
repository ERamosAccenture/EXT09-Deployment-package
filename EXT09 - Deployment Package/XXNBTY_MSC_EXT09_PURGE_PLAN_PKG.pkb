CREATE OR REPLACE PACKAGE BODY XXNBTY_MSCEXT09_PURGE_PLAN_PKG
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
                             x_retcode              OUT VARCHAR2)
  IS
 
 
    v_req_id    NUMBER := fnd_global.conc_request_id;
    v_lookup_name   VARCHAR2(100);
	v_step			NUMBER;
	v_mess			varchar2(1000);
	v_request_status  BOOLEAN;
	c_interval			NUMBER :=15;
	v_phase 			VARCHAR2 (2000);
	v_wait_status 		VARCHAR2 (2000);
	v_dev_status 		VARCHAR2 (2000);
	v_dev_phase 		VARCHAR2 (2000);
	v_message 			VARCHAR2 (2000);
	
	CURSOR c_purge_plan
	IS
	SELECT b.plan_name, b.plan_run_id
	FROM fnd_lookup_values a, msc_plan_runs b
	WHERE a.lookup_type = 'XXNBTY_MSC_ARCHIVE_PLAN_PERIOD'
	AND a.lookup_code  = b.plan_name
	AND b.archive_flag = 1
	AND (TRUNC(SYSDATE) - TRUNC(b.creation_date)) > a.tag;
	
	
BEGIN
	
	v_step := 1;
	FOR i IN c_purge_plan
	LOOP
			v_req_id := FND_REQUEST.SUBMIT_REQUEST( application 	=> 'MSC'
												,program 		=> 'MSCHUBP'
												,start_time   	=> TO_CHAR(SYSDATE,'DD-MON-YYYY HH:MI:SS')
												,sub_request  	=> FALSE
												,argument1   	=> i.plan_name
												,argument2		=> i.plan_run_id
											);			
			FND_CONCURRENT.AF_COMMIT;	
	v_step := 2;
			v_request_status:=fnd_concurrent.wait_for_request(request_id => v_req_id,
													INTERVAL => c_interval,
													max_wait => '',
													phase => v_phase,
													status => v_wait_status,
													dev_phase => v_dev_phase,
													dev_status => v_dev_status,
													MESSAGE => v_message);
			FND_CONCURRENT.AF_COMMIT;	
	v_step := 3;		
	END LOOP;
	v_step := 4;
	
EXCEPTION
    WHEN OTHERS THEN
  		v_mess := 'At step ['||v_step||'] for purge_archive_plan procedure - SQLCODE [' ||SQLCODE|| '] - ' ||substr(SQLERRM,1,100);
		x_errbuf := v_mess;
		x_retcode := 2;
		FND_FILE.PUT_LINE(FND_FILE.LOG,'Error message : ' || x_errbuf);	
 
END purge_archive_plan;

END XXNBTY_MSCEXT09_PURGE_PLAN_PKG;

/
show errors;