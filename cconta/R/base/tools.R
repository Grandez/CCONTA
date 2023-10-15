.monthLong  = c( "Enero", "Febrero", "Marzo",      "Abril",   "Mayo",      "Junio"
                   ,"Julio", "Agosto",  "Septiembre", "Octubre", "Noviembre", "Diciembre")   
.monthShort = c( "Ene.", "Feb.", "Mar.",      "Abr.",   "May.",      "Jun."
                   ,"Jul.", "Ago.",  "Sep.", "Oct.", "Nov.", "Dic.")   
month_long  = function (nMonth) { .monthLong [nMonth] }
month_short = function (nMonth) { .monthShort[nMonth] }
months_short = function () { .monthShort }
months_long  = function () { .monthLong }
months_as_combo = function (longNames = TRUE) {
   data = 1:12
   if ( longNames) names(data) = .monthLong
   if (!longNames) names(data) = .monthShort
   data
}