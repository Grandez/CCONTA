-- use CCONTA;

-- -------------------------------------------------------------------
-- La base de datos BASE contiene las tablas que son comunes 
-- Y la configuracion inicial
-- -------------------------------------------------------------------

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

-- Tabla de metodos de pago
DROP TABLE  IF EXISTS METHODS CASCADE;
CREATE TABLE METHODS  (
    IDACCOUNT INT UNSIGNED       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,ID        INT UNSIGNED       NOT NULL -- Grupo: IInnn - II Origen / nnn ID
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT   
   ,CLOSE     TINYINT      DEFAULT 0  COMMENT "Dia de cierre. Si 0 es debito"           -- 0 -> DEBITO, si no cierre de cuenta
   ,CHARGE    TINYINT      DEFAULT 0  COMMENT "Dia de cargo para tarjetas de credito"   -- Dia de cargo si es debito
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,SYNC      TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)                 -- Primary key
   ,UNIQUE      (IDACCOUNT, NAME)       -- Avoid duplicate names
);

-- Tabla de Grupos de gastos
DROP TABLE  IF EXISTS GROUPS CASCADE;
CREATE TABLE GROUPS  (
    ID        INT          NOT NULL COMMENT 'Convencion: Neg = Ingreso / Pos = Gasto'
   ,NAME      VARCHAR(255) NOT NULL -- Nombre del grupo
   ,DESCR     TEXT   
   ,ACTIVE    TINYINT      DEFAULT 1      
   ,TYPE      TINYINT      DEFAULT 0  COMMENT '-1 Ingresos / 1 Gastos'
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
   ,ACTIVE    TINYINT       DEFAULT 1   
   ,SYNC      TINYINT       DEFAULT 0  -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (IDGROUP, ID)         -- Primary key
   ,UNIQUE      (IDGROUP, ID, NAME)   -- Avoid duplicate names
);

-- Tabla de Presupuestos
DROP TABLE  IF EXISTS BUDGET CASCADE;
CREATE TABLE BUDGET    (
    ID         INT UNSIGNED       NOT NULL           COMMENT "ID Unico prefijado"
   ,IDGROUP    INT UNSIGNED       NOT NULL           COMMENT "ID del grupo"
   ,IDCATEGORY INT UNSIGNED       NOT NULL           COMMENT "ID de la categoria"
   ,IDMETHOD   INT UNSIGNED                          COMMENT "ID del metodo de pago"
   ,DATEY      SMALLINT     NOT NULL           COMMENT "Year del presupuesto"
   ,DATEM      SMALLINT     NOT NULL           COMMENT "Mes de inicio"
   ,DATED      SMALLINT     NOT NULL DEFAULT 0 COMMENT "Si no es cero es pago unico"
   ,FRECUENCY  TINYINT      NOT NULL DEFAULT 1 COMMENT "Frecuencia del gasto (mensual, bimensual, etc)"
   ,AMOUNT     DECIMAL(7,3) NOT NULL -- Importe
   ,DESCR      TEXT   
   ,SYNC       TINYINT      DEFAULT 0 -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (ID)         -- Primary key
);

-- Tabla de Gastos
-- TODO mirar indices por queries

DROP TABLE  IF EXISTS MOVEMENTS CASCADE;
CREATE TABLE  MOVEMENTS  (
    ID         INT UNSIGNED       NOT NULL -- Unique ID I + timestamp
   ,CDATE      DATE         NOT NULL -- Fecha del gasto
   ,IDMETHOD   INT UNSIGNED DEFAULT 0 -- Fuente del gasto
   ,IDGROUP    INT UNSIGNED       NOT NULL -- Grupo
   ,IDCATEGORY INT UNSIGNED       NOT NULL -- Fuente del gasto   
   ,AMOUNT     DECIMAL(7,3) NOT NULL -- Importe
   ,NOTE       VARCHAR(255)          -- Comentarios
   ,TYPE       TINYINT      DEFAULT 0  COMMENT 'Gastos: Positivo, Ingresos: Negativo. Real, Previsto, credito, amortizacion,etc'
   ,MODE       TINYINT      DEFAULT 0  COMMENT 'Tipo de movimiento: Real, Previsto, credito, amortizacion,etc'
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
   ,INDEX       (TYPE)
);

-- Tabla de Tags
-- Fuera del gasto para no tener limite
DROP TABLE  IF EXISTS TAGS CASCADE;
CREATE TABLE TAGS  (
    ID        INT UNSIGNED       NOT NULL -- ID del gasto
   ,TAG       VARCHAR(255) NOT NULL -- Tag
   ,PRIMARY KEY (ID, TAG)         -- Primary key
);
