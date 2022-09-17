DROP TABLE  IF EXISTS CATEGORIES CASCADE;
CREATE TABLE CATEGORIES  (
    IDGROUP   UNSIGNED INT  NOT NULL   -- ID Grupo
   ,ID        UNSIGNED INT  NOT NULL   -- ID Cuenta Cuenta: IInnnmmm - II Origen / nnn grupo / mmm Cuenta    
   ,NAME      VARCHAR(255)  NOT NULL   -- Nombre de la cuenta
   ,DESCR     TEXT   
   ,ACTIVE    TINYINT       DEFAULT 1   
   ,SYNC      TINYINT       DEFAULT 0  -- Indica si se ha sincronizado, editado, etc.   
   ,PRIMARY KEY (IDGROUP, ID)         -- Primary key
   ,UNIQUE      (IDGROUP, ID, NAME)   -- Avoid duplicate names
);
