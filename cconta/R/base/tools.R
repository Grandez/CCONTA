.monthLong  = c( "Enero", "Febrero", "Marzo",      "Abril",   "Mayo",      "Junio"
                   ,"Julio", "Agosto",  "Septiembre", "Octubre", "Noviembre", "Diciembre")   
.monthShort = c( "Ene.", "Feb.", "Mar.",      "Abr.",   "May.",      "Jun."
                   ,"Jul.", "Ago.",  "Sep.", "Oct.", "Nov.", "Dic.")   
month_long  = function (nMonth) { .monthLong [nMonth] }
month_short = function (nMonth) { .monthShort[nMonth] }