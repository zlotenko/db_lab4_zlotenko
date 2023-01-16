DROP TABLE IF EXISTS countries_audit;
DROP TRIGGER IF EXISTS countries_update_details ON countries;
DROP FUNCTION IF EXISTS table_countries_audit() CASCADE;

CREATE TABLE countries_audit(
	id SERIAL PRIMARY KEY,
	updated TIMESTAMP,
	user_name varchar(50) NOT NULL,
	deleted_country varchar (50) NOT NULL
);

CREATE OR REPLACE FUNCTION table_countries_audit() RETURNS trigger 
LANGUAGE 'plpgsql'
AS $$
BEGIN
 	INSERT INTO countries_audit(updated, user_name, deleted_country)
		VALUES(NOW(), user, OLD.country_name);
	RETURN NULL;
END;
$$ ;

CREATE TRIGGER countries_update_details 
AFTER DELETE ON countries
FOR EACH ROW EXECUTE FUNCTION table_countries_audit();


DELETE FROM countries WHERE country_name = 'the Soviet Union';
SELECT * FROM countries_audit