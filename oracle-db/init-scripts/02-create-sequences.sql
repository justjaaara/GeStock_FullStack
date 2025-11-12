ALTER SESSION SET CONTAINER = FREEPDB1;

-- Cambiar al schema de GESTOCK
ALTER SESSION SET CURRENT_SCHEMA = GESTOCK;

-------------------------------------------------------
--  DDL for Sequence SEQ_CATEGORY_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_CATEGORY_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CLOSURE_HEADER_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_CLOSURE_HEADER_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CLOSURE_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_CLOSURE_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_INVENTORY_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_INVENTORY_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_LOT_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_LOT_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_MEASUREMENT_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_MEASUREMENT_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_MOVEMENT_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_MOVEMENT_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_PRODUCT_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_PRODUCT_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_ROLE_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_ROLE_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_SALE_DETAIL_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_SALE_DETAIL_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_SALE_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_SALE_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_SALE_STATE_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_SALE_STATE_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_STATE_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_STATE_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_USER_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_USER_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_USER_STATE_ID
--------------------------------------------------------

   CREATE SEQUENCE  "GESTOCK"."SEQ_USER_STATE_ID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL ;
--------------------------------------------------------
