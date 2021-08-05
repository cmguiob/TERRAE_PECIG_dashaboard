library(tidyverse)
library(wesanderson)
library(showtext)
library(ggsn)
library(ggrepel)
library(sf)

#------------------------------ LOAD

temp <- tempfile() #Crear objetos temporales
tempd <- tempdir()

url <- "https://github.com/cmguiob/TERRAE_PECIG_dashaboard/blob/main/Dashboard/Dashboard_rds.zip?raw=true"

download.file(url,temp, mode="wb")
unzip(temp, exdir=tempd) #Descomprimir

files_names <- list.files(tempd, pattern = "*.rds") #Leer nombres de archivos
files_paths <- paste(file.path(tempd), files_names[], sep = "\\") #Crear rutas

UCS_centroids <- files_paths %>% .[str_detect(.,"centroids")] %>% read_rds()
deptos_RAO <- files_paths %>% .[str_detect(.,"RAO")] %>% read_rds()


#----------------------------- PREP

pal <- wes_palette("Zissou1", 100, type = "continuous")

# Obtener fuentes
font_add_google(name = "Roboto Condensed", family= "robotoc")
font_add_google(name = "Roboto", family= "roboto")


# Definir theme
theme_set(theme_minimal(base_family = "roboto"))

theme_update(panel.grid = element_blank(),
             axis.text = element_text(family = "robotoc",
                                      color = "#c3beb8",
                                      size = 16),
             axis.title = element_blank(),
             axis.ticks =  element_line(color = "#c3beb8", size = .7),
             legend.title = element_text(size = 20, 
                                         face = "bold", 
                                         color = "grey20", 
                                         family = "roboto"),
             legend.text = element_text(size = 16, 
                                        color = "#c3beb8", 
                                        family = "robotoc",
                                        face = "bold"),
             legend.key.size = unit(0.7, "cm"),
             strip.background = element_blank())

#-------------------------------- APP

library(shiny)

ui <- fluidPage(
  tags$head(
    # Note the wrapping of the string in HTML()
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css?family=Playfair+Display|Roboto');
      h1 {
        font-family: 'Playfair Display';
      }
      .selectize-input {
        height: 14px;
        font-size: 12pt;
        font-family: 'Roboto';
        padding-top: 5px;
        color: #c3beb8;
      }
      .shiny-input-container {
        color: #474747;
      }"))
  ),
  headerPanel(title = "Unidades Cartográficas de Suelos del PMA - PECIG"),
  br(),
  sidebarPanel(
    selectInput(inputId = "departamento",
              label = shiny::HTML("<p> <span style ='font-family: Roboto; font-size: 14pt;'> Selecciona un departamento </span></p>"),
              choices = c("Guaviare","Meta", "Vichada", "Caqueta")),
    plotOutput(outputId = "mapa")
  ),
  mainPanel(
    plotOutput(outputId = "puntos"),
    uiOutput("UCS_select"))
)

server <- function(input, output, session) {
  
  output$mapa <- renderPlot({
    
    showtext_auto()
    
    ggplot()+
      geom_sf(data = deptos_RAO %>% filter(DEPARTAMENTO == input$departamento), 
              aes(fill = RAO),
              color = NA)+
      ggrepel::geom_label_repel( data = UCS_centroids %>% 
                          filter(DEPARTAMENTO == input$departamento)%>%
                          filter(UCS_F == input$UCS),
                        aes(label = UCS_F, geometry = geometry),
                        alpha = 0.7,
                        col = "grey20",
                        size = 4,
                        force_pull  = 0.2,
                        max.overlaps = Inf,
                        direction = "both",
                        box.padding = 0.5,
                        stat = "sf_coordinates",
                        family = "roboto",
                        segment.size = 0.3,
                        segment.square = FALSE,
                        segment.curvature = -0.3,
                        segment.angle = 30, 
                        segment.ncp = 10,
                        show.legend = FALSE) +
      ggsn::scalebar(data = deptos_RAO %>% filter(DEPARTAMENTO == input$departamento), 
                     dist = 25, 
                     dist_unit = "km",
                     transform = TRUE,
                     st.dist = 0.06,
                     st.color = "grey20",
                     st.size = 4,
                     height=0.02,
                     box.color = NA,
                     box.fill = c("grey20","#c3beb8"),
                     family = "robotoc")+
      theme(legend.position = "top",
            axis.text = element_blank(),
            axis.ticks = element_blank())+
      scale_fill_gradientn(colours = pal)+
      scale_y_continuous(expand=c(0, 0.5))+
      guides(colour = "none",
             fill = guide_colourbar(title = "Incertidumbre - Rao",
                                    title.position = "top",
                                    title.hjust = 0.5,
                                    barwidth = unit(15,"lines"),
                                    barheight = unit(0.5,"lines")))
    
    
  }, bg="transparent", execOnResize = TRUE)
  
  output$puntos <- renderPlot({
    
    ggplot(data = deptos_RAO %>% 
             st_drop_geometry()%>%
             filter(DEPARTAMENTO == input$departamento)%>% 
             distinct(UCS_F, .keep_all = TRUE), 
           aes(y = RAO, x = UCS_TIPO, color = RAO))+
      geom_jitter(aes(size = NUM_SUELOS),
                  alpha = 0.5, 
                  width = 0.25, 
                  shape = 19)+
      geom_label_repel(data = . %>% filter(UCS_F == input$UCS), 
                       aes(label = input$UCS),
                       alpha = 0.7,
                       col = "grey20",
                       size = 4,
                       direction = "y",
                       nudge_y = 0,
                       nudge_x = 0.05,
                       box.padding = 1,
                       family = "roboto",
                       segment.size = 0.3,
                       segment.square = FALSE,
                       show.legend = FALSE)+
      geom_hline(aes(yintercept = 0.5), 
                 color = "#c3beb8", 
                 size = 0.5, 
                 linetype = "dashed")+
      stat_summary(fun = mean, geom = "point", size = 4, shape = 18, color = "grey20")+
      coord_flip() +
      guides(color = "none",
             size = guide_legend(title = "Tipos de suelos que contiene la UCS",
                                 label.position = "bottom",
                                 nrow = 1,
                                 override.aes=list(colour= "#c3beb8",
                                                   shape = 16)))+
      scale_y_continuous(limits = c(0, 0.8))+
      scale_size_continuous(breaks = c(1,2,3,4,5,6)) +
      scale_colour_gradientn(colours = pal) +
      labs(x = NULL, y = "Incertidumbre - Rao")+
      theme(legend.position = "top",
            axis.text.y = element_text(size = 20, face = "bold"),
            panel.border = element_rect(fill = NA, colour = "#c3beb8"))
  }, height = 370)
  
  output$UCS_select <- renderUI({
    radioButtons(inputId = "UCS", 
                 label = shiny::HTML("<p> <span style ='font-family: Roboto; font-size: 14pt'> Unidades Cartográficas de Suelos </span></p>"),
                 choices = deptos_RAO %>% 
                        st_drop_geometry()%>%
                        filter(DEPARTAMENTO == input$departamento) %>% 
                        distinct(UCS_F, .keep_all = TRUE) %>%
                        arrange(desc(RAO)) %>%
                        pull(UCS_F),
                 inline = TRUE)
  })
  
}

shinyApp(ui, server)