DROP TABLE  IF EXISTS TRANSFERS CASCADE;
CREATE TABLE TRANSFERS  (
    ID         INT UNSIGNED   NOT NULL COMMENT 'Unique ID'
   ,DATEOPER   DATE           NOT NULL COMMENT 'Fecha de operacion de la transferencia'
   ,DATEVAL    DATE           NOT NULL COMMENT 'Fecha de valor la transferencia'   
   ,ORIGIN     INT UNSIGNED   NOT NULL COMMENT 'Cuenta origen'   
   ,TARGET     INT UNSIGNED   NOT NULL COMMENT 'Cuenta destino'   
   ,AMOUNT     DECIMAL(7,3)   NOT NULL COMMENT 'Importe de la transferencia'   
   ,NOTE       VARCHAR(255)            COMMENT 'Comentarios'   
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                 -- Primary key
   ,INDEX       (ORIGIN, DATEOPER)  
   ,INDEX       (TARGET, DATEVAL)
);
