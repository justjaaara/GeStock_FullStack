ALTER SESSION SET CONTAINER = FREEPDB1;

-- Cambiar al schema de GESTOCK
ALTER SESSION SET CURRENT_SCHEMA = GESTOCK;
--------------------------------------------------------
--  DDL for Trigger TRG_BLOCK_MOVEMENTS_AFTER_CLOSURE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "GESTOCK"."TRG_BLOCK_MOVEMENTS_AFTER_CLOSURE" 
BEFORE INSERT OR UPDATE ON "INVENTORY_MOVEMENTS_NOT_PART"
FOR EACH ROW
DECLARE
    v_last_closure DATE;
BEGIN
    SELECT MAX(CLOSURE_DATE)
    INTO v_last_closure
    FROM CLOSURE_HEADER;

    IF v_last_closure IS NOT NULL AND :NEW.MOVEMENT_DATE < v_last_closure THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se pueden registrar movimientos con fecha anterior al último cierre.');
    END IF;
END;

/
ALTER TRIGGER "GESTOCK"."TRG_BLOCK_MOVEMENTS_AFTER_CLOSURE" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_BLOCK_MOVEMENTS_AFTER_CLOSURE_PART
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "GESTOCK"."TRG_BLOCK_MOVEMENTS_AFTER_CLOSURE_PART" 
BEFORE INSERT OR UPDATE ON GESTOCK.INVENTORY_MOVEMENTS
FOR EACH ROW
DECLARE
    v_last_closure DATE;
BEGIN
    SELECT MAX(CLOSURE_DATE)
    INTO v_last_closure
    FROM CLOSURE_HEADER;

    IF v_last_closure IS NOT NULL AND :NEW.MOVEMENT_DATE < v_last_closure THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se pueden registrar movimientos con fecha anterior al último cierre.');
    END IF;
END;

/
ALTER TRIGGER "GESTOCK"."TRG_BLOCK_MOVEMENTS_AFTER_CLOSURE_PART" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_INVENTORY_UPDATED_AT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "GESTOCK"."TRG_INVENTORY_UPDATED_AT" 
  BEFORE UPDATE ON "GESTOCK"."INVENTORY"
  FOR EACH ROW
BEGIN
  :NEW.UPDATED_AT := CURRENT_TIMESTAMP;
END;

/
ALTER TRIGGER "GESTOCK"."TRG_INVENTORY_UPDATED_AT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_PRODUCTS_UPDATED_AT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "GESTOCK"."TRG_PRODUCTS_UPDATED_AT" 
  BEFORE UPDATE ON "GESTOCK"."PRODUCTS"
  FOR EACH ROW
BEGIN
  :NEW.UPDATED_AT := CURRENT_TIMESTAMP;
END;

/
ALTER TRIGGER "GESTOCK"."TRG_PRODUCTS_UPDATED_AT" ENABLE;