
-- Grupo 00 - PC
-- Claves son: mmgggaaa: mm - fuente, ggg - grupo, aaa - cuenta

-- Bancos
INSERT INTO ACCOUNTS  (ID, NAME)            VALUES (1, 'CASH');
INSERT INTO METHODS  (IDACCOUNT, ID, INCOME, EXPENSE, NAME)  VALUES (1, 1, 1, 1, 'Cash');

INSERT INTO ACCOUNTS  (ID, NAME)            VALUES (2, 'Nickel');
INSERT INTO METHODS  (IDACCOUNT, ID, INCOME, EXPENSE, NAME)  VALUES (2, 2, 0, 1, 'Tarjeta Nickel');

INSERT INTO ACCOUNTS  (ID, NAME)            VALUES (3, 'Correos');
INSERT INTO METHODS  (IDACCOUNT, ID, INCOME, EXPENSE, NAME)  VALUES (3, 3, 0, 1, 'Tarjeta Correos');

INSERT INTO ACCOUNTS  (ID, NAME)            VALUES (3, 'Maite');
INSERT INTO METHODS  (IDACCOUNT, ID, INCOME, EXPENSE, NAME)  VALUES (3, 4, 1, 1,'Personal');

-- Ingresos
INSERT INTO GROUPS      (ID, INCOME, EXPENSE, NAME)                  VALUES ( 101,          1,  0, 'Trabajo'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES ( 101, 101001,  1,  0, 'Nomina'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES ( 101, 101002,  1,  0, 'Dietas'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES ( 101, 101003,  1,  0, 'Bonos'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES ( 101, 101998,  1,  0, 'Otros'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES ( 101, 101999,  1,  0, 'Imprevistos'       );
                                                                     
INSERT INTO GROUPS      (ID, INCOME, EXPENSE, NAME)                  VALUES ( 102,          1,  1, 'Bancos'            ); 
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES ( 102, 102001,  1,  1, 'Intereses'         );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES ( 102, 102998,  1,  1, 'Otros'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES ( 102, 102999,  1,  1, 'Imprevistos'       );
                                                                     
-- Gastos                                                            
INSERT INTO GROUPS      (ID, INCOME, EXPENSE, NAME)                  VALUES (  1,           0,  1, 'Personal'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  1,    1001,  0,  1, 'Tabaco'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  1,    1998,  0,  1, 'Otros'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  1,    1999,  0,  1, 'Imprevistos'       );
                                                                                                 
INSERT INTO GROUPS      (ID, INCOME, EXPENSE, NAME)                  VALUES (  2,           0,  1, 'Hogar'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  2,    2001,  0,  1, 'Alquiler'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  2,    2002,  0,  1, 'Gastos'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  2,    2003,  0,  1, 'Comida'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  2,    2004,  0,  1, 'Limpieza'          );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME, DESCR)  VALUES (  2,    2005,  0,  1, 'Alcohol'          , 'Cervezas, vinos, etc.');
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME, DESCR)  VALUES (  2,    2006,  0,  1, 'Ocio'             , 'Gastos de fiestas y cosas asi');
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  2,    2007,  0,  1, 'Restaurantes'      );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  2,    2998,  0,  1, 'Otros'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  2,    2999,  0,  1, 'Imprevistos'       );
                                                                                           
INSERT INTO GROUPS      (ID, INCOME, EXPENSE, NAME)                  VALUES (  3,           0,  1, 'Transporte'        );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  3,    3001,  0,  1, 'Carburante'        );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  3,    3002,  0,  1, 'Seguro'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  3,    3003,  0,  1, 'Mantenimiento'     );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  3,    3004,  0,  1, 'Taxis'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  3,    3005,  0,  1, 'Publico'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  3,    3998,  0,  1, 'Otros'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  3,    3999,  0,  1, 'Imprevistos'       );
                                                                                           
INSERT INTO GROUPS      (ID, INCOME, EXPENSE, NAME)                  VALUES (  4,           0,  1, 'Ocio'              );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  4,    4001,  0,  1, 'Copas'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  4,    4002,  0,  1, 'Comidas'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  4,    4003,  0,  1, 'Espectaculos'      );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  4,    4998,  0,  1, 'Otros'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  4,    4999,  0,  1, 'Imprevistos'       );
                                                                                           
INSERT INTO GROUPS      (ID, INCOME, EXPENSE, NAME)                  VALUES (  5,           0,  1, 'Salud'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  5,    5001,  0,  1, 'Medicinas'         );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  5,    5002,  0,  1, 'Seguros'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  5,    5003,  0,  1, 'Medicos'           );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  5,    5998,  0,  1, 'Otros'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  5,    5999,  0,  1, 'Imprevistos'       );
                                                                                           
INSERT INTO GROUPS      (ID, INCOME, EXPENSE, NAME)                  VALUES (  6,           0,  1, 'Formacion'         );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  6,    6001,  0,  1, 'Matriculas'        );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  6,    6002,  0,  1, 'Libros'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  6,    6003,  0,  1, 'Cursos'            );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  6,    6998,  0,  1, 'Otros'             );
INSERT INTO CATEGORIES  (IDGROUP, ID, INCOME, EXPENSE, NAME)         VALUES (  6,    6999,  0,  1, 'Imprevistos'       );
