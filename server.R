# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

# Dependencies(When hosting in Github,copy below from Dependencies.R)
#ShinyApp_R



# Define server logic 

shinyServer(function(input, output, session) {
  
    output$currentTime <- renderText({invalidateLater(1000, session)
    paste("Current time: ",Sys.time())})
  
    options(shiny.maxRequestSize=30*1024^2)
    
    ####Coverting uploaded data in to dataframe
    
    uploadedtext <- reactive({
      
      if (is.null(input$fileinput1)) {   # Finds 'fileinput1' from ui.R
        
        return('No Text exists') } else{
          Data1 <- readLines(input$fileinput1$datapath,encoding = "UTF-8")
          return(Data1)
        }
    })
    annotate <- reactive({
      
      if (is.null(input$fileinput2)) {   # locate 'udpipfl' from ui.R
        
        return(NULL) } else{
          
          udpipe_model <- udpipe_load_model(file = input$fileinput2$datapath)
          ud_text <- udpipe_annotate(udpipe_model, uploadedtext())
          ud_text <- as.data.frame(ud_text)
          return(ud_text)
        }
    })
    
    
   
    ##########Annotated Document Code
      
        output$Annotate <- renderDataTable(
        {
          out <- annotate()
          return(out)
        }
      )
      
      ##########cooccurance graph code for Xpos
      
      output$Cooccurance <- renderPlot(
        {
          model = udpipe_load_model(file = input$fileinput2$datapath)
          txt <- udpipe_annotate(model, uploadedtext())
          txt <- as.data.frame(txt)
          data_cooc <- udpipe::cooccurrence(x = subset(txt, xpos %in% input$checkgroup1), term = "lemma", 
                                            group = c("doc_id", "paragraph_id", "sentence_id")
                                            
          )
          
          wordnetwork <- data_cooc
          wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
          ggraph(wordnetwork, layout = "fr") + geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +
            geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
            theme_graph(base_family = "Arial Narrow") +
            theme(legend.position = "none")
        }
      )
      
      ##########Wordcloud
      output$plotNN = renderPlot({
        if('NN'  %in% input$checkgroup1)
        {
          all_nouns = annotate() %>% subset(., xpos %in% "NN") 
          top_nouns = txt_freq(all_nouns$lemma)
          wordcloud(words = top_nouns$key, 
                    freq = top_nouns$freq, 
                    min.freq = input$min_freq, 
                    max.words = input$max_freq,
                    random.order = FALSE, 
                    colors = brewer.pal(6, "Dark2"))
        } 
        else
        {return(NULL)}
      })
      
      output$plotVB = renderPlot({
        if('VB'  %in% input$checkgroup1)
        {
          all_verbs = annotate() %>% subset(., xpos %in% "VB") 
          top_verbs = txt_freq(all_verbs$lemma)
          wordcloud(words = top_verbs$key, 
                    freq = top_verbs$freq, 
                    min.freq = input$min_freq, 
                    max.words = input$max_freq,
                    random.order = FALSE, 
                    colors = brewer.pal(6, "Dark2"))
        } 
        else
        {return(NULL)}
        
      })
      
      
      output$plotRB = renderPlot({
        
        if('RB'  %in% input$checkgroup1)
        {
          all_adverbs = annotate() %>% subset(., xpos %in% "RB") 
          top_adverbs = txt_freq(all_adverbs$lemma)
          wordcloud(words = top_adverbs$key, 
                    freq = top_adverbs$freq, 
                    min.freq = input$min_freq, 
                    max.words = input$max_freq,
                    random.order = FALSE, 
                    colors = brewer.pal(6, "Dark2"))
        } 
        else
        {return(NULL)}
      })
      
      output$plotJJ = renderPlot({
        
        if('JJ'  %in% input$checkgroup1)
        {
          all_adjec = annotate() %>% subset(., xpos %in% "JJ") 
          top_adjec = txt_freq(all_adjec$lemma)
          wordcloud(words = top_adjec$key, 
                    freq = top_adjec$freq, 
                    min.freq = input$min_freq, 
                    max.words = input$max_freq,
                    random.order = FALSE, 
                    colors = brewer.pal(6, "Dark2"))
        } 
        else
        {return(NULL)}
        
        
      })
      
})






