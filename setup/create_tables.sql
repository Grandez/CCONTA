-- use CCONTA;

-- -------------------------------------------------------------------
-- La base de datos BASE contiene las tablas que son comunes 
-- Y la configuracion inicial
-- -------------------------------------------------------------------

-- Tabla de Bancos y cuentas
DROP TABLE  IF EXISTS ACCOUNTS CASCADE;
CREATE TABLE ACCOUNTS  (
    ID        BIGINT       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                 -- Primary key
   ,UNIQUE      (NAME)              -- Avoid duplicate names
);

-- Tabla de metodos de pago
DROP TABLE  IF EXISTS METHODS CASCADE;
CREATE TABLE METHODS  (
    IDACCOUNT BIGINT       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,ID        BIGINT       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT   
   ,CLOSE     TINYINT      DEFAULT 0  COMMENT "Dia de cierre. Si 0 es debito"           -- 0 -> DEBITO, si no cierre de cuenta
   ,CHARGE    TINYINT      DEFAULT 0  COMMENT "Dia de cargo para tarjetas de credito"   -- Dia de cargo si es debito
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                 -- Primary key
   ,UNIQUE      (IDBANK, NAME)       -- Avoid duplicate names
);

-- Tabla de Grupos de gastos
DROP TABLE  IF EXISTS GROUPS CASCADE;
CREATE TABLE GROUPS  (
    ID        BIGINT       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT   
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                -- Primary key
   ,UNIQUE      (NAME)              -- Avoid duplicate names
);

-- Tabla de Categorias de gasto
DROP TABLE  IF EXISTS CATEGORIES CASCADE;
CREATE TABLE CATEGORIES  (
    IDGROUP   BIGINT       NOT NULL   -- Grupo:  IInnn    - II Origen / nnn ID
   ,ID        BIGINT       NOT NULL   -- Cuenta: IInnnmmm - II Origen / nnn grupo / mmm Cuenta    
   ,NAME      VARCHAR(255) NOT NULL   -- Nombre de la cuenta
   ,DESCR     TEXT   
   ,ACTIVE    TINYINT      DEFAULT 1   
   ,SYNC      TINYINT      DEFAULT 0  -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (IDGROUP, ID)         -- Primary key
   ,UNIQUE      (IDGROUP, ID, NAME)   -- Avoid duplicate names
);

-- Tabla de Presupuestos
DROP TABLE  IF EXISTS BUDGET CASCADE;
CREATE TABLE BUDGET    (
    ID         BIGINT       NOT NULL -- Grupo:  IInnn    - II Origen / nnn ID
   ,IDGROUP    BIGINT       NOT NULL -- Grupo
   ,IDCATEGORY BIGINT       NOT NULL -- Fuente del gasto   
   ,DATEY      SMALLINT     NOT NULL
   ,DATEM      SMALLINT     NOT NULL       
   ,AMOUNT    DECIMAL(7,3) NOT NULL -- Importe
   ,DESCR     TEXT   
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)         -- Primary key
);

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
   ,INDEX       (IDGROUP, IDCATEGORY)    -- Alternate Key
--   ,INDEX       (ACCOUNT, TYPE)      -- Alternate Key   
   ,INDEX       (SYNC)               -- For synch
);

-- Tabla de Ingresos
DROP TABLE  IF EXISTS INCOMES CASCADE;
CREATE TABLE  INCOMES  (
    ID        BIGINT       NOT NULL   -- Unique ID II + timestamp
   ,IDBANK    BIGINT       NOT NULL   -- Grupo:  IInnn    - II Origen / nnn ID
   ,IDCARD    BIGINT       NOT NULL   -- Cuenta: IInnnmmm - II Origen / nnn grupo / mmm Cuenta    
   ,AMOUNT    DECIMAL(7,3) NOT NULL   -- Importe
   ,NOTE      VARCHAR(255)            -- Comentarios
   ,TYPE      TINYINT      DEFAULT 0  -- Previsto, real, credito, amortizacion,etc 
   ,ACTIVE    TINYINT      DEFAULT 1    
   ,SYNC      TINYINT      DEFAULT 0  -- Indica si se ha sincronizado, editado, etc.      
   ,PRIMARY KEY (ID)                  -- Primary key
   ,UNIQUE      (IDBANK, IDCARD, ID)  -- Alternate Key
   ,INDEX       (SYNC)                -- For synch
);

-- Tabla de Tags
-- Fuera del gasto para no tener limite
DROP TABLE  IF EXISTS TAGS CASCADE;
CREATE TABLE TAGS  (
    ID        BIGINT       NOT NULL -- ID del gasto
   ,TAG       VARCHAR(255) NOT NULL -- Tag
   ,PRIMARY KEY (ID, TAG)         -- Primary key
);
