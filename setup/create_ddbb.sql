DROP DATABASE IF EXISTS CCONTA;
CREATE DATABASE CCONTA CHARACTER SET utf8 COLLATE utf8_general_ci;

DROP DATABASE IF EXISTS CCONTA_TEST;
CREATE DATABASE CCONTA_TEST CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Usuarios
CREATE USER 'CCONTA'@'localhost' IDENTIFIED BY 'cconta';
GRANT ALL PRIVILEGES ON CCONTA.*          TO 'CCONTA'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON CCONTA_TEST.*     TO 'CCONTA'@'localhost' WITH GRANT OPTION;