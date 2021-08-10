################################################################################
# Shiny app para explorar datos de suelos del PMA-PECIG
#
# Author: Carlos Guio
# Created: 2021-01-22 
################################################################################


#------------------------------ IMPORTAR LIBRERIAS

library(tidyverse)
library(wesanderson)
library(showtext)
library(ggsn)
library(ggrepel)
library(sf)
library(shinyWidgets)

#------------------------------ CARGAR DATOS


UCS_centroids <- read_rds("data/UCS_centroids.rds")
deptos_RAO <- read_rds("data/deptos_RAO.rds")


#----------------------------- PREPARAR

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
             axis.ticks =  element_blank(),
             legend.title = element_text(size = 22, 
                                         #face = "bold", 
                                         color = "#474747", 
                                         family = "roboto"),
             legend.text = element_text(size = 16, 
                                        color = "#474747", 
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
      @import url('https://fonts.googleapis.com/css?family=Playfair+Display|Roboto|Roboto+Condensed');
      h1 {
          font-family: 'Roboto';
          font-weight: bold;
          font-size: 32pt;
          height: 60px;
          text-align:right;
          margin-bottom:15px;
      }
      .selectize-input {
          height: 14px;
          font-size: 12pt;
          font-family: 'Roboto Condensed';
          padding-top: 5px;
          color: #c3beb8;
      }
      body, label, input, button, select { 
          font-family: Roboto Condensed;
          font-size: 10 pt;
          color: #474747;
      }
      .well {
          background-color: #F0EBE5;
          border-width: 0pt;
      }
      hr {
          border-top: 1px solid #000000;
      }
      .shiny-input-container {
        color: #474747;
      }"))
  ),
  headerPanel(title = "Explora los suelos del PMA - PECIG"),
  br(),
  sidebarPanel(
    selectInput(inputId = "departamento",
                label = shiny::HTML("<p> <span style ='font-family: Roboto; font-size: 16pt;'> Selecciona un departamento </span></p>"),
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
                                 family = "robotoc",
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
                     st.color = "#474747",
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
                       col = "#474747",
                       size = 6,
                       direction = "y",
                       nudge_y = 0,
                       nudge_x = 0.05,
                       box.padding = 1,
                       family = "robotoc",
                       segment.size = 0.3,
                       segment.square = FALSE,
                       show.legend = FALSE)+
      geom_hline(aes(yintercept = 0.5), 
                 color = "#474747", 
                 size = 0.5, 
                 linetype = "dashed")+
      geom_curve(
        aes(x = 1.2, y = 0.5, xend = 0.95, yend = 0.25),
        arrow = arrow(length = unit(0.07, "inch")), size = 0.2,
        color = "#474747", curvature = 0.3) +
      annotate(
        geom = "text", 
        x = 0.9, y = 0.16, family = "robotoc", 
        size = 6, 
        color = "#474747", 
        lineheight = .9,
        label = "Incertidumbre 0.5")+
      stat_summary(fun = mean, geom = "point", size = 4, shape = 18, color = "#474747")+
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
            axis.text.y = element_text(size = 20),
            panel.border = element_rect(fill = NA, colour = "#c3beb8", size = (1)),
            #panel.grid.major.y = element_line(colour= "#F0EBE5", size = (17))
            )
  }, height = 360)
  
  output$UCS_select <- renderUI({
    prettyRadioButtons(
      inputId = "UCS", 
      label = shiny::HTML("<p> <span style ='font-family: Roboto; font-size: 16pt'> Selecciona una unidad cartográfica de suelos (UCS) </span></p>"),
      choices = deptos_RAO %>% 
        st_drop_geometry()%>%
        filter(DEPARTAMENTO == input$departamento) %>% 
        distinct(UCS_F, .keep_all = TRUE) %>%
        arrange(desc(RAO)) %>%
        pull(UCS_F),
      choiceNames = list(
        tags$span(style = "color:red")),
      inline = TRUE,
      status = "warning",
      fill = TRUE
    )
    
  })
  
}

shinyApp(ui, server)