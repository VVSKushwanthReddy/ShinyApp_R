# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

# Dependencies(When hosting in Github,copy below from Dependencies.R)

if (!require(udpipe)){install.packages("udpipe")}
if (!require(stringr)){install.packages("stringr")}
if (!require(shiny)){install.packages("shiny")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(readtext)){install.packages("readtext")}


library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)

# Define ui function

shinyUI(
  
      fluidPage(h4(textOutput("currentTime")),#Adding Dateinput widget
         
              titlePanel("Shiny App around the UDPipe NLP workflow"),
        
                sidebarLayout( 
          
                  sidebarPanel(  
                    
                    #uploading any file
                    
                    fileInput('fileinput1', "Upload text file"),
                   
                  
                    #uploading udpipe model file
                  
                    fileInput('fileinput2', "Upload trained udpipe model for different languages",
                                  accept=c('text/csv',
                                     'text/comma-separated-values','text/plain', 
                                     '.csv')),
          
                    
                    #h4("Select Language for Part-of-speech-tags"),
                    
                    #selectInput("selectInput1", "Select Language", c("English", "Other_Languages")),
                    #conditionalPanel( condition = "output.nrows",
                    checkboxGroupInput('checkgroup1',"List of Part-of-speech-tags(XPOS)",
                                       choices=c("Adjective(JJ)" = "JJ",
                                                 "Noun(NN)" = "NN",
                                                 "Proper noun(NNP)" = "NNP",
                                                 "Adverb(RB)" = "RB",
                                                 "Verb(VB)"= "VB"),
                                       selected = c("JJ","NN","NNP")
                                       
                      ), #closing checkboxgroupinput
                    
                
                    sliderInput("min_freq", "Minimum frequency of words in wordcloud:", min = 0,  max = 30, value = 1),
                    sliderInput("max1", "Maximum frequency of words in wordcloud:", min = 1,  max = 200, value = 100),
                    
                    submitButton(text = "Apply Changes", icon("refresh"))
                   
                       ), #closing Side bar panel
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("APP Overview",
                             br(),
                             
                             p("This app helps to gain insights about data stored in different languages of Text files.",align="justify"),
                             p("Please refer to the link below for sample text file."),
                             a(href="https://github.com/VVSKushwanthReddy/ShinyApp_R/blob/master/LaLaLand.txt"
                               ,"Sample data input file"),   #change
                             br(),
                             h4('How to use this App'),
                             
                            h5('To use this app, Follow below steps'),
                            br(),
                            
                            p("1.Upload the Text file containing data"),
                            p("2.Upload the Trained Udpipe Model of corresponding language in Text file"),
                            p("Wait for few seconds till Model gives output as Co-Occurence plolt and Wordcloud"),
                            p("3.Use slider button to change frequency of words in wordcloud")
                             
                             
                              ), #end of 1st tab panel
                    
                      tabPanel("Annotated Document",dataTableOutput('Annotate')),
                      tabPanel("Co-Occurance Plot", 
                             h3("Ignore initial error display,Wait for approximately 10-20 seconds!!!"),
                             plotOutput("Cooccurance")
                             ),
                      tabPanel("wordclouds",
                                h3("Ignore initial error display,Wait for approximately 10-20 seconds!!!"),
                                h4("Adjectives"),
                                plotOutput('plotJJ'),
                                h4("Nouns"),
                                plotOutput('plotNN'),
                                h4("Verbs"),
                                plotOutput('plotVB'),
                                h4("Adverbs"),
                                plotOutput('plotRB')) 
                                   

        ) # end of tabsetPanel
      )# end of main panel
) # end of sidebarLayout
)  # end of fluidPage
) # end of UI
#
