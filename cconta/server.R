function(input, output, session) {
   observeEvent(input$mainMenu,{
      message("entra en server")
      mod = paste0( "mod_",str_to_lower(input$mainMenu),"_server")
      eval(parse(text=paste0( mod, "(input$mainMenu, session)")))
   })   
}