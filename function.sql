 -- Функція рахує кількість записів, де виробник втраченої техніки - вказана країна
	
CREATE OR REPLACE FUNCTION country_count(country text) RETURNS int AS
    $$
        DECLARE
            res integer;
        BEGIN
            SELECT COUNT(*) INTO res
            FROM losses
      JOIN equip ON losses.equip_id = equip.equip_id
      JOIN countries ON equip.country_id = countries.country_id
            WHERE countries.country_name = country;
            RETURN res;
        END;
    $$ LANGUAGE 'plpgsql';
  
SELECT * FROM country_count('the Soviet Union')