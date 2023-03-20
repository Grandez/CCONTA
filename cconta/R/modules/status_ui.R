modStatusInput <- function(id, title) {
    ns <- NS(id)
    left = tagList(
        h4("Previstos"),   switchInput( inputId=ns("swExpected"), onLabel = "Unico", offLabel = "Agrupado"
                                      ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)
       ,h4("Provisiones"),   switchInput( inputId=ns("swProvision"), onLabel = "Unico", offLabel = "Agrupado"
                                      ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)

      
       ,guiButton(ns("btnOK"),  label="Insertar",    type="success")
       ,guiButton(ns("btnKO"),  label="Limpiar",     type="danger")       
   )    
    main = ui_status(id)
    list(left=left, main=main, right=NULL)
}