ALTER SESSION SET CONTAINER = FREEPDB1;

-- Cambiar al schema de GESTOCK
ALTER SESSION SET CURRENT_SCHEMA = GESTOCK;
--------------------------------------------------------
--  DDL for Procedure CARGA_RFID_MASIVA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "GESTOCK"."CARGA_RFID_MASIVA" (
  -- Lote (siempre viene)
  p_rfid_code       IN VARCHAR2,
  p_batch_desc      IN VARCHAR2,

  -- Producto (si no existe, se crea)
  p_product_id      IN NUMBER,        -- puede ser NULL
  p_product_code    IN VARCHAR2,      -- puede ser NULL (útil para buscar)
  p_product_name    IN VARCHAR2,      -- usado al crear
  p_unit_price      IN NUMBER,        -- usado al crear
  p_product_desc    IN VARCHAR2 DEFAULT NULL,
  p_category_id     IN NUMBER   DEFAULT NULL,
  p_measurement_id  IN NUMBER   DEFAULT NULL,
  p_state_id        IN NUMBER   DEFAULT NULL,

  -- Inventario / Movimiento
  p_quantity        IN NUMBER,
  p_reference       IN VARCHAR2,
  p_user_id         IN NUMBER,
  p_movement_reason IN VARCHAR2
) IS
  v_now        TIMESTAMP := CAST(SYSTIMESTAMP AT TIME ZONE 'America/Bogota' AS TIMESTAMP);
  v_lot_id     NUMBER;
  v_product_id NUMBER := p_product_id;
BEGIN
  -- =========================================================
  -- VALIDACIONES
  -- =========================================================
  IF p_quantity IS NULL OR p_quantity <= 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'La cantidad debe ser > 0.');
  END IF;

  -- =========================================================
  -- 1) LOTE: SIEMPRE crear (cada lectura RFID = un lote único)
  -- =========================================================
  INSERT INTO BATCHES (DESCRIPTION, ENTRY_DATE, RFID_CODE)
  VALUES (NVL(p_batch_desc, 'Lote RFID'), v_now, p_rfid_code)
  RETURNING LOT_ID INTO v_lot_id;

  -- =========================================================
  -- 2) PRODUCTO: buscar por ID o por CODE; si no existe, CREAR
  -- =========================================================
  
  -- 2.1) Buscar por ID si viene
  IF v_product_id IS NOT NULL THEN
    BEGIN
      SELECT product_id INTO v_product_id
      FROM products
      WHERE product_id = v_product_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_product_id := NULL;
    END;
  END IF;

  -- 2.2) Si no se encontró por ID, buscar por CODE
  IF v_product_id IS NULL AND p_product_code IS NOT NULL THEN
    BEGIN
      SELECT product_id INTO v_product_id
      FROM products
      WHERE product_code = p_product_code;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_product_id := NULL;
    END;
  END IF;

  -- 2.3) Si no existe, CREAR producto
  IF v_product_id IS NULL THEN
    INSERT INTO products (
      category_id, 
      measurement_id, 
      product_code, 
      product_description,
      product_name, 
      state_id, 
      unit_price
    ) VALUES (
      p_category_id, 
      p_measurement_id, 
      p_product_code, 
      p_product_desc,
      p_product_name, 
      p_state_id, 
      p_unit_price
    )
    RETURNING product_id INTO v_product_id;
  END IF;

  -- =========================================================
  -- 3) INVENTORY: acumular por PRODUCTO y actualizar LOT_ID al más reciente
  --    -> una sola fila por PRODUCT_ID, LOT_ID = último lote ingresado
  -- =========================================================
  MERGE INTO inventory inv
  USING (
    SELECT v_product_id AS product_id,
           v_lot_id     AS lot_id,
           p_quantity   AS qty,
           v_now        AS ts
    FROM dual
  ) src
  ON (inv.product_id = src.product_id)
  WHEN MATCHED THEN
    UPDATE SET 
      inv.actual_stock = inv.actual_stock + src.qty,
      inv.lot_id       = src.lot_id,
      inv.updated_at   = src.ts
  WHEN NOT MATCHED THEN
    INSERT (product_id, lot_id, actual_stock, minimum_stock, created_at, updated_at)
    VALUES (src.product_id, src.lot_id, src.qty, 0, src.ts, src.ts);

  -- =========================================================
  -- 4) MOVIMIENTO: cada entrada ligada a su LOT_ID para trazabilidad
  -- =========================================================
  INSERT INTO inventory_movements (
    lot_id, 
    movement_date, 
    movement_type, 
    movement_reason,
    product_id, 
    quantity, 
    reference, 
    user_id
  ) VALUES (
    v_lot_id, 
    v_now, 
    'ENTRADA', 
    p_movement_reason,
    v_product_id, 
    p_quantity, 
    p_reference, 
    p_user_id
  );

  -- =========================================================
  -- 5) COMMIT
  -- =========================================================
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END CARGA_RFID_MASIVA;

/
--------------------------------------------------------
--  DDL for Procedure GENERAR_CIERRE_MENSUAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "GESTOCK"."GENERAR_CIERRE_MENSUAL" (p_user_email VARCHAR2) AS
    v_user_id NUMBER;
    v_header_id NUMBER;
    v_mes NUMBER := EXTRACT(MONTH FROM SYSDATE);
    v_anio NUMBER := EXTRACT(YEAR FROM SYSDATE);
    v_existe NUMBER;
BEGIN
    -- Obtener usuario
    SELECT USER_ID INTO v_user_id
    FROM USERS WHERE EMAIL = p_user_email;

    -- Verificar si ya existe un cierre en el mismo mes/año
    SELECT COUNT(*) INTO v_existe
    FROM CLOSURE_HEADER
    WHERE CLOSURE_MONTH = v_mes AND CLOSURE_YEAR = v_anio;

    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ya existe un cierre para este mes.');
    END IF;

    -- Crear el encabezado del cierre
    INSERT INTO CLOSURE_HEADER (CLOSURE_MONTH, CLOSURE_YEAR, USER_ID)
    VALUES (v_mes, v_anio, v_user_id)
    RETURNING HEADER_ID INTO v_header_id;

    -- Insertar el snapshot del inventario actual
    INSERT INTO INVENTORY_CLOSURE (HEADER_ID, CLOSURE_DATE, PRODUCT_ID, LOT_ID, FINAL_STOCK, USER_ID)
    SELECT v_header_id, SYSDATE, PRODUCT_ID, LOT_ID, ACTUAL_STOCK, v_user_id
    FROM INVENTORY;

    COMMIT;
END;

/
--------------------------------------------------------
--  DDL for Package PKG_CENTRAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GESTOCK"."PKG_CENTRAL" AS
  -- Tipo de cursor REF para estadísticas
  TYPE T_CURSOR IS REF CURSOR;

  -- Procedimiento para cargue de inventario
  PROCEDURE CARGAR_INVENTARIO(
    p_product_id     IN NUMBER,
    p_lot_id         IN NUMBER,
    p_quantity       IN NUMBER,
    p_reference      IN VARCHAR2,
    p_user_id        IN NUMBER,
    p_movement_reason IN VARCHAR2
  );

  -- Procedimiento para descargue de inventario
  PROCEDURE DESCARGAR_INVENTARIO(
    p_product_id     IN NUMBER,
    p_lot_id         IN NUMBER,
    p_quantity       IN NUMBER,
    p_reference      IN VARCHAR2,
    p_user_id        IN NUMBER,
    p_movement_reason IN VARCHAR2
  );

  -- Procedimiento para cierre mensual
  PROCEDURE CIERRE_MENSUAL(
    p_closure_date IN DATE,
    p_user_email   IN VARCHAR2
  );

  -- Procedimiento para estadísticas de movimientos
  PROCEDURE ESTADISTICAS_MOVIMIENTOS(
    p_start_date IN DATE,
    p_end_date   IN DATE
  );
END PKG_CENTRAL;

/
--------------------------------------------------------
--  DDL for Package Body PKG_CENTRAL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GESTOCK"."PKG_CENTRAL" AS

  -- Procedimiento para cargar inventario
  PROCEDURE CARGAR_INVENTARIO(
    p_product_id      IN NUMBER,
    p_lot_id          IN NUMBER,
    p_quantity        IN NUMBER,
    p_reference       IN VARCHAR2,
    p_user_id         IN NUMBER,
    p_movement_reason IN VARCHAR2
  ) IS
  BEGIN
    UPDATE INVENTORY
    SET ACTUAL_STOCK = ACTUAL_STOCK + p_quantity,
        UPDATED_AT   = CAST((SYSTIMESTAMP AT TIME ZONE 'America/Bogota') AS TIMESTAMP)
    WHERE PRODUCT_ID = p_product_id;

    COMMIT;

    INSERT INTO INVENTORY_MOVEMENTS (
      LOT_ID, MOVEMENT_DATE, MOVEMENT_TYPE, MOVEMENT_REASON,
      PRODUCT_ID, QUANTITY, REFERENCE, USER_ID
    ) VALUES (
      p_lot_id,
      CAST((SYSTIMESTAMP AT TIME ZONE 'America/Bogota') AS TIMESTAMP),
      'ENTRADA',
      p_movement_reason,
      p_product_id,
      p_quantity,
      p_reference,
      p_user_id
    );

    COMMIT;
  END CARGAR_INVENTARIO;

  -- Procedimiento para descargar inventario
  PROCEDURE DESCARGAR_INVENTARIO(
    p_product_id      IN NUMBER,
    p_lot_id          IN NUMBER,
    p_quantity        IN NUMBER,
    p_reference       IN VARCHAR2,
    p_user_id         IN NUMBER,
    p_movement_reason IN VARCHAR2
  ) IS
    v_current_stock NUMBER;
  BEGIN
    SELECT ACTUAL_STOCK
    INTO v_current_stock
    FROM INVENTORY
    WHERE PRODUCT_ID = p_product_id;

    IF v_current_stock < p_quantity THEN
      RAISE_APPLICATION_ERROR(-20001, 'Stock insuficiente para realizar la operación.');
    END IF;

    UPDATE INVENTORY
    SET ACTUAL_STOCK = ACTUAL_STOCK - p_quantity,
        UPDATED_AT   = CAST((SYSTIMESTAMP AT TIME ZONE 'America/Bogota') AS TIMESTAMP)
    WHERE PRODUCT_ID = p_product_id;

    INSERT INTO INVENTORY_MOVEMENTS (
      LOT_ID, MOVEMENT_DATE, MOVEMENT_TYPE, MOVEMENT_REASON,
      PRODUCT_ID, QUANTITY, REFERENCE, USER_ID
    ) VALUES (
      p_lot_id,
      CAST((SYSTIMESTAMP AT TIME ZONE 'America/Bogota') AS TIMESTAMP),
      'SALIDA',
      p_movement_reason,
      p_product_id,
      p_quantity,
      p_reference,
      p_user_id
    );

    COMMIT;
  END DESCARGAR_INVENTARIO;

  -- Procedimiento para cierre mensual
  PROCEDURE CIERRE_MENSUAL(
    p_closure_date IN DATE,
    p_user_email   IN VARCHAR2
  ) IS
    v_user_id NUMBER;
  BEGIN
    SELECT USER_ID
    INTO v_user_id
    FROM USERS
    WHERE EMAIL = p_user_email;

    INSERT INTO INVENTORY_CLOSURE (
      CLOSURE_DATE, PRODUCT_ID, LOT_ID, FINAL_STOCK, USER_ID
    )
    SELECT
      CAST((CAST(p_closure_date AS TIMESTAMP) AT TIME ZONE 'America/Bogota') AS TIMESTAMP),
      i.PRODUCT_ID,
      i.LOT_ID,
      i.ACTUAL_STOCK,
      v_user_id
    FROM INVENTORY i;

    COMMIT;
  END CIERRE_MENSUAL;

  -- Procedimiento para generar estadísticas de movimientos
  PROCEDURE ESTADISTICAS_MOVIMIENTOS(
    p_start_date IN DATE,
    p_end_date   IN DATE
  ) IS
    v_max_mov_product_id NUMBER;
    v_max_mov_count      NUMBER;
    v_min_mov_product_id NUMBER;
    v_min_mov_count      NUMBER;
  BEGIN
    -- Producto con más movimientos
    SELECT PRODUCT_ID, COUNT(*)
    INTO v_max_mov_product_id, v_max_mov_count
    FROM INVENTORY_MOVEMENTS
    WHERE MOVEMENT_DATE BETWEEN
      CAST((CAST(p_start_date AS TIMESTAMP) AT TIME ZONE 'America/Bogota') AS TIMESTAMP)
      AND CAST((CAST(p_end_date AS TIMESTAMP) AT TIME ZONE 'America/Bogota') AS TIMESTAMP)
    GROUP BY PRODUCT_ID
    ORDER BY COUNT(*) DESC
    FETCH FIRST 1 ROWS ONLY;

    -- Producto con menos movimientos
    SELECT PRODUCT_ID, COUNT(*)
    INTO v_min_mov_product_id, v_min_mov_count
    FROM INVENTORY_MOVEMENTS
    WHERE MOVEMENT_DATE BETWEEN
      CAST((CAST(p_start_date AS TIMESTAMP) AT TIME ZONE 'America/Bogota') AS TIMESTAMP)
      AND CAST((CAST(p_end_date AS TIMESTAMP) AT TIME ZONE 'America/Bogota') AS TIMESTAMP)
    GROUP BY PRODUCT_ID
    ORDER BY COUNT(*) ASC
    FETCH FIRST 1 ROWS ONLY;

    DBMS_OUTPUT.PUT_LINE('Producto con más movimientos: ' || v_max_mov_product_id || ' (' || v_max_mov_count || ' movimientos)');
    DBMS_OUTPUT.PUT_LINE('Producto con menos movimientos: ' || v_min_mov_product_id || ' (' || v_min_mov_count || ' movimientos)');
  END ESTADISTICAS_MOVIMIENTOS;

END PKG_CENTRAL;

/