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
    ID        INT UNSIGNED NOT NULL 
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT   
   ,EXPENSE   TINYINT      DEFAULT 1          COMMENT "Gastos"  
   ,INCOME    TINYINT      DEFAULT 1          COMMENT "Ingresos"
   ,SINCE     DATE         DEFAULT CURDATE()  COMMENT "Fecha de alta"
   ,UNTIL     DATE                            COMMENT "Fecha de baja"
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                -- Primary key
   ,UNIQUE      (TYPE, NAME)         -- Avoid duplicate names
   ,INDEX       (TYPE)
);

-- Tabla de Categorias de gasto
DROP TABLE  IF EXISTS CATEGORIES CASCADE;
CREATE TABLE CATEGORIES  (
    IDGROUP   INT UNSIGNED  NOT NULL   -- ID Grupo
   ,ID        INT UNSIGNED  NOT NULL   -- ID Cuenta Cuenta: IInnnmmm - II Origen / nnn grupo / mmm Cuenta    
   ,NAME      VARCHAR(255)  NOT NULL   -- Nombre de la cuenta
   ,DESCR     TEXT   
   ,EXPENSE   TINYINT       DEFAULT  1  COMMENT "Gastos"  
   ,INCOME    TINYINT       DEFAULT  1  COMMENT "Ingresos"   
   ,CATEGORIA TINYINT       DEFAULT 20  COMMENT "Categoria de mov. fijo 10 / variable 20 / Aperiodico 30"   
   ,SINCE     DATE         DEFAULT CURDATE()  COMMENT "Fecha de alta"
   ,UNTIL     DATE                            COMMENT "Fecha de baja"
   ,SYNC      TINYINT       DEFAULT 0  -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (IDGROUP, ID)         -- Primary key
   ,UNIQUE      (IDGROUP, ID, NAME)   -- Avoid duplicate names
);


-- Tabla de Presupuestos
DROP TABLE  IF EXISTS BUDGET CASCADE;
CREATE TABLE BUDGET    (
    IDGROUP     INT UNSIGNED   NOT NULL           COMMENT 'ID del grupo'
   ,IDCATEGORY  INT UNSIGNED   NOT NULL           COMMENT 'ID de la categoria'
   ,BYEAR       SMALLINT       NOT NULL           COMMENT 'Numero del mes'   
   ,BMONTH      TINYINT        NOT NULL           COMMENT 'Numero del mes'
   ,EXPENSE     TINYINT        DEFAULT -1         COMMENT "Gastos"  
   ,B00         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto mensual'
   ,B01         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B02         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B03         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B04         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B05         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B06         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B07         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B08         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B09         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B10         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B11         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B12         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B13         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B14         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B15         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B16         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B17         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B18         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B19         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B20         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B21         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B22         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B23         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'   
   ,B24         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B25         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B26         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B27         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B28         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B29         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'      
   ,B30         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'
   ,B31         DECIMAL(10,3)   DEFAULT 0.0        COMMENT 'Presupuesto del dia'         
   ,SYNC       TINYINT        DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (BYEAR, BMONTH, IDGROUP, IDCATEGORY, EXPENSE)
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
   ,AMOUNT     DECIMAL(10,3)   NOT NULL           COMMENT 'Importe el gasto'
   ,NOTE       VARCHAR(255)          -- Comentarios
   ,EXPENSE    TINYINT        DEFAULT -1         COMMENT 'Es un gasto (-1) o un ingreso (1)'
   ,TYPE       TINYINT        DEFAULT  1         COMMENT 'Tipo de gasto segun codigo'
   ,VARIABLE   TINYINT        DEFAULT -1         COMMENT 'Flag gasto fijo o variable'
   ,PARENT     INT  UNSIGNED                     COMMENT 'Si es un gasto desglosado, id del padre'   
   ,ACTIVE     TINYINT        DEFAULT 1   
   ,SYNC       TINYINT        DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.      
   ,PRIMARY KEY (ID)                 -- Primary key
   ,INDEX       (DATEVAL, IDGROUP, IDCATEGORY)    -- Alternate Key
   ,INDEX       (SYNC)               -- For synch
   ,INDEX       (TYPE)
);
-- ------------------------------------------------
-- Tabla de cierre contable
-- El Mes 0 es el saldo de inicio para ese agno
-- ------------------------------------------------
DROP TABLE  IF EXISTS CLOSED CASCADE;
CREATE TABLE  CLOSED  (
    YEAR_CLOSE  SMALLINT    UNSIGNED NOT NULL           COMMENT 'Agno'
   ,MONTH_CLOSE SMALLINT    UNSIGNED NOT NULL           COMMENT 'Mes'
   ,IDGROUP    INT          UNSIGNED NOT NULL           COMMENT 'Grupo de gastos'
   ,IDCATEGORY INT          UNSIGNED NOT NULL           COMMENT 'Categoria del gasto'
   ,AMOUNT     DECIMAL(10,3)          NOT NULL           COMMENT 'Importe el gasto'
   ,SYNC       TINYINT                         DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.      
   ,PRIMARY KEY (YEAR_CLOSE, MONTH_CLOSE, IDGROUP, IDCATEGORY)                 -- Primary key
   ,INDEX       (SYNC)               -- For synch
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
   ,AMOUNT     DECIMAL(10,3)   NOT NULL           COMMENT 'Importe el gasto'
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
   ,AMOUNT     DECIMAL(10,3)   NOT NULL COMMENT 'Importe de la transferencia'   
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
   ,AMOUNT     DECIMAL(10,3)   NOT NULL COMMENT 'Importe de la transferencia'   
   ,NOTE       VARCHAR(255)            COMMENT 'Comentarios'   
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                 -- Primary key
   ,INDEX       (ORIGIN, DATEOPER)  
   ,INDEX       (TARGET, DATEVAL)
);
