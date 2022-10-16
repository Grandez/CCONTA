-- use CCONTA;

DROP TABLE  IF EXISTS PARAMETERS CASCADE;
CREATE TABLE PARAMETERS  (
    GRUPO    INTEGER     NOT NULL -- Grupo, no usamos GROUP para evitar problemas de nombres
   ,SUBGROUP INTEGER     NOT NULL -- Parametro
   ,BLOCK    INTEGER     DEFAULT 0
   ,ID       INTEGER     NOT NULL -- Parametro
   ,TYPE     TINYINT     NOT NULL -- Tipo de parametro
   ,NAME     VARCHAR(32) NOT NULL
   ,VALUE    VARCHAR(64) NOT NULL
   ,PRIMARY KEY ( GRUPO, SUBGROUP, BLOCK, ID ) USING BTREE
);

-- Tabla de Bancos y cuentas
DROP TABLE  IF EXISTS ACCOUNTS CASCADE;
CREATE TABLE ACCOUNTS  (
    ID        INT UNSIGNED       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                 -- Primary key
   ,UNIQUE      (NAME)              -- Avoid duplicate names
);

-- Tabla de metodos de realizacion de la operacion
DROP TABLE  IF EXISTS METHODS CASCADE;
CREATE TABLE METHODS  (
    IDACCOUNT INT UNSIGNED       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,ID        INT UNSIGNED       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT   
   ,EXPENSE   TINYINT      DEFAULT 1  COMMENT "Acepta gastos"  
   ,INCOME    TINYINT      DEFAULT 1  COMMENT "Acepta Ingresos"
   ,CLOSE     TINYINT      DEFAULT 0  COMMENT "Dia de cierre. Si 0 es debito"
   ,CHARGE    TINYINT      DEFAULT 0  COMMENT "Dia de cargo para tarjetas de credito"
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                 -- Primary key
   ,UNIQUE      (IDACCOUNT, NAME)       -- Avoid duplicate names
);

-- Tabla de Grupos de gastos
DROP TABLE  IF EXISTS GROUPS CASCADE;
CREATE TABLE GROUPS  (
    ID        INT          NOT NULL 
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT   
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,EXPENSE   TINYINT      DEFAULT 1  COMMENT "Gastos"  
   ,INCOME    TINYINT      DEFAULT 1  COMMENT "Ingresos"
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                -- Primary key
   ,UNIQUE      (TYPE, NAME)         -- Avoid duplicate names
   ,INDEX       (TYPE)
);

-- Tabla de Categorias de gasto
DROP TABLE  IF EXISTS CATEGORIES CASCADE;
CREATE TABLE CATEGORIES  (
    IDGROUP   INT           NOT NULL   -- ID Grupo
   ,ID        INT UNSIGNED  NOT NULL   -- ID Cuenta Cuenta: IInnnmmm - II Origen / nnn grupo / mmm Cuenta    
   ,NAME      VARCHAR(255)  NOT NULL   -- Nombre de la cuenta
   ,DESCR     TEXT   
   ,EXPENSE   TINYINT       DEFAULT 1  COMMENT "Gastos"  
   ,INCOME    TINYINT       DEFAULT 1  COMMENT "Ingresos"   
   ,ACTIVE    TINYINT       DEFAULT 1   
   ,SYNC      TINYINT       DEFAULT 0  -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (IDGROUP, ID)         -- Primary key
   ,UNIQUE      (IDGROUP, ID, NAME)   -- Avoid duplicate names
);

-- Tabla de Presupuestos
DROP TABLE  IF EXISTS BUDGET CASCADE;
CREATE TABLE BUDGET    (
    ID         INT UNSIGNED   NOT NULL             COMMENT 'ID Unico prefijado'
   ,IDGROUP    INT            NOT NULL             COMMENT 'ID del grupo'
   ,IDCATEGORY INT UNSIGNED   NOT NULL             COMMENT 'ID de la categoria'
   ,IDMETHOD   INT UNSIGNED                        COMMENT 'ID del metodo de pago'
   ,DATEY      SMALLINT       NOT NULL             COMMENT 'Year del presupuesto'
   ,DATEM      SMALLINT       NOT NULL             COMMENT 'Mes de inicio'
   ,DATED      SMALLINT       NOT NULL DEFAULT 0   COMMENT 'Si no es cero es pago unico'
   ,FRECUENCY  TINYINT        NOT NULL DEFAULT 1   COMMENT 'Frecuencia del gasto (mensual, bimensual, etc)'
   ,AMOUNT     DECIMAL(7,3)   NOT NULL -- Importe
   ,DESCR      TEXT   
   ,SYNC       TINYINT        DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)         -- Primary key
);

-- Tabla de Gastos
-- TODO mirar indices por queries
-- Tipo de movimiento:
-- Negativos gastos, Positivos ingresos
--    0 - No asignado
--    1 - Real. Se ha ejecutado
--    2 - Previsto
--    3 - Provision
--    4 - Amortizacion
--   1n - Previsto
--   2n - Adeudados/Aplazados
--
DROP TABLE  IF EXISTS MOVEMENTS CASCADE;
CREATE TABLE  MOVEMENTS  (
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
-- Same as movements
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

-- Tabla de Tags
-- Fuera del gasto para no tener limite
DROP TABLE  IF EXISTS TAGS CASCADE;
CREATE TABLE TAGS  (
    ID        INT UNSIGNED       NOT NULL -- ID del gasto
   ,SEQ       INT          NOT NULL  COMMENT 'Recuperar por orden los tags'
   ,TAG       VARCHAR(255) NOT NULL -- Tag
   ,PRIMARY KEY (ID, SEQ, TAG)         -- Primary key
);

-- Tabla de Transferencias
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

-- aMORTIZACIONES
DROP TABLE  IF EXISTS REDEMPTIONS CASCADE;
CREATE TABLE REDEMPTIONS  (
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
