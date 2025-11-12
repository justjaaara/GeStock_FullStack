-- Script de finalización para marcar que todos los scripts se ejecutaron correctamente
ALTER SESSION SET CONTAINER = FREEPDB1;
ALTER SESSION SET CURRENT_SCHEMA = GESTOCK;

-- Crear una tabla de marcador para indicar que la inicialización está completa
CREATE TABLE GESTOCK.INIT_STATUS (
    STATUS VARCHAR2(20),
    COMPLETED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar el marcador de completado
INSERT INTO GESTOCK.INIT_STATUS (STATUS) VALUES ('COMPLETED');
COMMIT;

-- Mensaje de confirmación
SELECT 'Base de datos inicializada completamente' AS mensaje FROM DUAL;
