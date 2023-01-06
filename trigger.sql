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