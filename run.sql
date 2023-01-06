-- FUNCTION

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
	
SELECT * FROM country_count('the Soviet Union');


-- PROCEDURE
CREATE OR REPLACE PROCEDURE losses_by_type(entered_type text)
LANGUAGE plpgsql AS
$$
	DECLARE
		loss_rec record;
	BEGIN
		FOR loss_rec IN
			SELECT losses.losses_total
			FROM losses
			JOIN equip ON losses.equip_id = equip.equip_id
  			JOIN equip_type ON equip.equip_type_id = equip_type.equip_type_id
			WHERE equip_type.type = entered_type
		LOOP
			RAISE INFO 'Losses: %', loss_rec.losses_total;
		END LOOP;
	END;
$$;

CALL losses_by_type('Tanks');

-- TRIGGER
CREATE OR REPLACE FUNCTION lower_equip_type() RETURNS trigger AS
$$
     BEGIN
          UPDATE equip_type 
          SET type = lower(type) WHERE equip_type.equip_type_id = NEW.equip_type_id; 
      RETURN NULL; -- result is ignored since this is an AFTER trigger
     END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER equip_type_insert 
AFTER INSERT ON equip_type
FOR EACH ROW EXECUTE FUNCTION lower_equip_type();

INSERT INTO equip_type(equip_type_id, type) VALUES (7, 'Heavy Mortars')