-- Tabla de Gastos
-- TODO mirar indices por queries
DROP TABLE  IF EXISTS EXPENSES CASCADE;
CREATE TABLE  EXPENSES  (
    ID         BIGINT       NOT NULL -- Unique ID II + timestamp
   ,CDATE      DATE         NOT NULL -- Fecha del gasto
   ,IDMETHOD   BIGINT       NOT NULL -- Fuente del gasto
   ,IDGROUP    BIGINT       NOT NULL -- Grupo
   ,IDCATEGORY BIGINT       NOT NULL -- Fuente del gasto   
   ,AMOUNT     DECIMAL(7,3) NOT NULL -- Importe
   ,NOTE       VARCHAR(255)          -- Comentarios
   ,TYPE       TINYINT      DEFAULT 0 -- Previsto, real, credito, amortizacion,etc 
   ,ACTIVE     TINYINT      DEFAULT 1   
   ,SYNC       TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.      
   -- Partimos la fecha en Y/M/D para las queries
   ,DATEY      SMALLINT     NOT NULL
   ,DATEM      SMALLINT     NOT NULL   
   ,DATED      SMALLINT     NOT NULL
   ,PRIMARY KEY (ID)                 -- Primary key
   ,INDEX       (DATEY, DATEM, DATED, IDGROUP, IDCATEGORY)    -- Alternate Key
--   ,INDEX       (ACCOUNT, TYPE)      -- Alternate Key   
   ,INDEX       (SYNC)               -- For synch
);
