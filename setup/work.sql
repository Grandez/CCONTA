DROP TABLE  IF EXISTS BUDGET CASCADE;
CREATE TABLE BUDGET    (
    ID         INT UNSIGNED   NOT NULL             COMMENT 'ID Unico prefijado'
   ,IDGROUP    INT            NOT NULL             COMMENT 'ID del grupo'
   ,IDCATEGORY INT UNSIGNED   NOT NULL             COMMENT 'ID de la categoria'
   ,IDMETHOD   INT UNSIGNED                        COMMENT 'ID del metodo de pago'
   ,DATEOPE    DATE           NOT NULL             COMMENT 'Fecha de operacion'
   ,DATEVAL    DATE           NOT NULL             COMMENT 'Fecha de valor'
   ,FRECUENCY  TINYINT        NOT NULL DEFAULT 1   COMMENT 'Frecuencia del gasto en dias (0=puntual, mensual, bimensual, etc)'
   ,AMOUNT     DECIMAL(7,3)   NOT NULL -- Importe
   ,DESCR      TEXT   
   ,ACTIVE    TINYINT         DEFAULT 1      
   ,SYNC       TINYINT        DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID, DATEVAL)         -- Primary key
);
