DO $$
DECLARE
	random_id text;
BEGIN 
   FOR i IN 1..200 LOOP
   	  SELECT md5(random()::text || clock_timestamp()::text)::uuid into random_id;
      INSERT INTO profile
         (account_id, first_name,middle_name,last_name,created_by)  
		VALUES (random_id,'testname','testsecondname','testlastname','user_admin_3');
   END LOOP;
END $$;
