OBJTools = R6::R6Class("CONTA.OBJ.TOOLS"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
      initialize = function() {
      }
# Genera un identificador unico
# DEBE GENERAR UN NUMERO DE 9 POSICIONES      
# El EPOCH UNix da los segundos (rounded) desde 1970-01-01
# Quitamos Desde una fecha dada
# Quitamos el digito mas significativo
# el añadimos dos digitos y un contador estatico
# ESto nos dice que, dentro de un segundo: 166653 podemos tener 100 identificadores
# 16665300 - 16665399
# Si en el mismo segundo generamos 101 id
# 16665400 (El 3 pasa a 4) pero ese numero no se puede repetir por que en el siguiente
# segundo el id daria 102, con lo que seria 16665501
# Estos ID se pueen guardar en un int de 4 bytes sin signo:  	2147483647/4294967295
    ,getID = function(block = 0) {
        epoch = as.integer(Sys.time()) - 1577836860 # Restamos el epoch desde 2020-01-01
        epoch = (epoch %% 10000000)                 # Quitamos el digito significativo (7 digitos)
        epoch = epoch * 10                          # Le damos 1 digito mas (8 digitos)
        private$.cnt = (private$.cnt + 1) %% 10     # Contador estatico (10 op/seg)
        (block * 10^9) + epoch + .cnt               # prefijo, total 9 digitos (unsigned int)
    }
   )
   ,private = list(
       .cnt         = 0 # Contador para id
   )
)

