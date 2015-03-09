BEGIN   
	SYS.DBMS_STATS.GATHER_DATABASE_STATS ( 
		Estimate_Percent   => DBMS_STATS.AUTO_SAMPLE_SIZE, 
		GRANULARITY        => 'AUTO', 
		Cascade            => TRUE,
		DEGREE             => 16
		--,OPTIONS            => 'GATHER AUTO'
	); 
END;
/