DROP TABLE  IF EXISTS BUDGET CASCADE;
CREATE TABLE BUDGET    (
    IDGROUP    INT UNSIGNED   NOT NULL             COMMENT 'ID del grupo'
   ,IDCATEGORY INT UNSIGNED   NOT NULL             COMMENT 'ID de la categoria'
   ,NYEAR      SMALLINT       NOT NULL             COMMENT 'Numero del mes'   
   ,NMONTH     TINYINT        NOT NULL             COMMENT 'Numero del mes'
   ,AMOUNT     DECIMAL(7,3)   DEFAULT 0.0          COMMENT 'Importe'
   ,DESCR      TEXT   
   ,ACTIVE     TINYINT        DEFAULT 1      
   ,SYNC       TINYINT        DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (IDGROUP, IDCATEGORY, NYEAR, NMONTH)   -- Avoid duplicate names   
);
