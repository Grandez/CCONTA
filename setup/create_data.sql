
-- Grupo 00 - PC
-- Claves son: mmgggaaa: mm - fuente, ggg - grupo, aaa - cuenta

-- Bancos
INSERT INTO ACCOUNTS  (ID, NAME)            VALUES (1, 'CASH');
INSERT INTO METHODS  (IDACCOUNT, ID, NAME)    VALUES (1, 1, 'CASH');

INSERT INTO ACCOUNTS  (ID, NAME)            VALUES (2, 'Nickel');
INSERT INTO METHODS  (IDACCOUNT, ID, NAME)    VALUES (2, 1, 'Tarjeta Nickel');

INSERT INTO ACCOUNTS  (ID, NAME)            VALUES (3, 'Correos');
INSERT INTO METHODS  (IDACCOUNT, ID, NAME)    VALUES (3, 1, 'Tarjeta Correos');

-- Grupos y cuentas de gastos
INSERT INTO GROUPS      (ID, NAME)             VALUES (1,       'Personal'      );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (1, 1001, 'Tabaco'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (1, 2998, 'Otros'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (1, 2999, 'Imprevistos'     );

INSERT INTO GROUPS      (ID, NAME)           VALUES (2,       'Hogar'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (2, 2001, 'Alquiler'        );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (2, 2002, 'Gastos'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (2, 2003, 'Comida'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (2, 2004, 'Limpieza'        );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (2, 2998, 'Otros'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (2, 2999, 'Imprevistos'     );

INSERT INTO GROUPS      (ID, NAME)           VALUES (3,       'Transporte'      );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (3, 3001, 'Carburante'      );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (3, 3002, 'Seguro'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (3, 3003, 'Mantenimiento'   );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (3, 3004, 'Taxis'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (3, 3005, 'Publico'         );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (3, 3998, 'Otros'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (3, 3999, 'Imprevistos'     );

INSERT INTO GROUPS      (ID, NAME)           VALUES (4,       'Ocio'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (4, 4001, 'Copas'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (4, 4002, 'Comidas'         );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (4, 4003, 'Espectaculos'    );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (4, 4998, 'Otros'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (4, 4999, 'Imprevistos'     );

INSERT INTO GROUPS      (ID, NAME)           VALUES (5,       'Salud'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (5, 5001, 'Medicinas'       );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (5, 5002, 'Seguros'         );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (5, 5003, 'Medicos'         );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (5, 5998, 'Otros'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (5, 5999, 'Imprevistos'     );

INSERT INTO GROUPS      (ID, NAME)           VALUES (6,       'Formacion'       );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (6, 6001, 'Matriculas'      );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (6, 6002, 'Libros'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (6, 6003, 'Cursos'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (6, 6998, 'Otros'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, NAME)  VALUES (6, 6999, 'Imprevistos'     );
