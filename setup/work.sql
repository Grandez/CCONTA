DROP TABLE  IF EXISTS ITEMIZEDS CASCADE;
CREATE TABLE  ITEMIZEDS  (
    ID         INT UNSIGNED   NOT NULL -- Unique ID I + timestamp
   ,DATEOPER   DATE           NOT NULL           COMMENT 'Fecha de operacion'
   ,DATEVAL    DATE           NOT NULL           COMMENT 'Fecha de valor'   
   ,IDMETHOD   INT UNSIGNED   DEFAULT 0          COMMENT 'Metodo de pago'
   ,IDGROUP    INT            NOT NULL           COMMENT 'Grupo de gastos'
   ,IDCATEGORY INT UNSIGNED   NOT NULL           COMMENT 'Categoria del gasto'
   ,AMOUNT     DECIMAL(7,3)   NOT NULL           COMMENT 'Importe el gasto'
   ,NOTE       VARCHAR(255)          -- Comentarios
   ,EXPENSE    TINYINT        DEFAULT 1          COMMENT 'Es un gasto (1) o in ingreso'
   ,TYPE       TINYINT        DEFAULT 1          COMMENT 'Tipo de gasto segun codigo'
   ,PARENT     INT  UNSIGNED                     COMMENT 'Si es un gasto desglosado, id del padre'   
   ,ACTIVE     TINYINT        DEFAULT 1   
   ,SYNC       TINYINT        DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.      
   ,PRIMARY KEY (ID)                 -- Primary key
   ,INDEX       (DATEOPER, IDGROUP, IDCATEGORY)    -- Alternate Key
   ,INDEX       (DATEVAL, IDGROUP, IDCATEGORY)    -- Alternate Key
   ,INDEX       (SYNC)               -- For synch
   ,INDEX       (TYPE)
);
