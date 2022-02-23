DO $$
DECLARE
	randomFirstName text;
	randomMiddleName text;
	randomLastName text;
	accountIdsToUpdate text[];
	current_acc_id text;
BEGIN
	-- get accountIds to update
	accountIdsToUpdate := ARRAY(
    	SELECT account_id FROM profile WHERE first_name= 'testname'
	);
	-- update part
	foreach current_acc_id in array accountIdsToUpdate 
	loop
		-- random part
		WITH firstNames AS (
			SELECT '{Adam,Bill,Bob,Calvin,Donald,Dwight,Frank,Fred,George,Howard,
			James,John,Jacob,Jack,Martin,Matthew,Max,Michael,
			Paul,Peter,Phil,Roland,Ronald,Samuel,Steve,Theo,Warren,William,
			Abigail,Alice,Allison,Amanda,Anne,Barbara,Betty,Carol,Cleo,Donna,
			Jane,Jennifer,Julie,Martha,Mary,Melissa,Patty,Sarah,Simone,Susan}'::text[] fn
		)
		SELECT fn[1 + floor((random() * array_length(fn, 1)))::int] into randomFirstName FROM firstNames;

		WITH middleNames AS (
			SELECT '{Adam,Bill,Bob,Calvin,Donald,Dwight,Frank,Fred,George,Howard,
			James,John,Jacob,Jack,Martin,Matthew,Max,Michael,
			Paul,Peter,Phil,Roland,Ronald,Samuel,Steve,Theo,Warren,William,
			Abigail,Alice,Allison,Amanda,Anne,Barbara,Betty,Carol,Cleo,Donna,
			Jane,Jennifer,Julie,Martha,Mary,Melissa,Patty,Sarah,Simone,Susan,
			Matthews,Smith,Jones,Davis,Jacobson,Williams,Donaldson,Maxwell,Peterson,Stevens,
			Franklin,Washington,Jefferson,Adams,Jackson,Johnson,Lincoln,Grant,Fillmore,Harding,Taft,
			Truman,Nixon,Ford,Carter,Reagan,Bush,Clinton,Hancock,J.,M.}'::text[] mn
		)
		SELECT mn[1 + floor((random() * array_length(mn, 1)))::int] into randomMiddleName FROM middleNames;

		WITH lastNames AS (
			SELECT '{Matthews,Smith,Jones,Davis,Jacobson,Williams,Donaldson,Maxwell,Peterson,Stevens,
			Franklin,Washington,Jefferson,Adams,Jackson,Johnson,Lincoln,Grant,Fillmore,Harding,Taft,
			Truman,Nixon,Ford,Carter,Reagan,Bush,Clinton,Hancock,J.,M.}'::text[] lan
		)
		SELECT lan[1 + floor((random() * array_length(lan, 1)))::int] into randomLastName FROM lastNames;
		-- update part
		UPDATE profile 
		SET first_name = randomFirstName, middle_name = randomMiddleName, last_name = randomLastName
		WHERE account_id = current_acc_id;
  	end loop;
END $$;