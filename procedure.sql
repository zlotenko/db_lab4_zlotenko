-- Відображає загальні втрати для вказаного типу техніки

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