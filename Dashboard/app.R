library(tidyverse)
library(wesanderson)
library(showtext)
library(ggsn)
library(ggrepel)
library(sf)

#------------------------------ LOAD

temp <- tempfile() #Crear objetos temporales
tempd <- tempdir()

url <- "https://github.com/cmguiob/TERRAE_PECIG_dashaboard/blob/main/Dashboard/RAO_UCS_deptos.zip?raw=true"

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
                                      color = "#c3beb8"),
             axis.title = element_blank(),
             axis.ticks =  element_line(color = "#c3beb8", size = .7),
             legend.title = element_text(size = 12, 
                                         face = "bold", 
                                         color = "grey20", 
                                         family = "roboto"),
             legend.text = element_text(size = 9, 
                                        color = "#c3beb8", 
                                        family = "robotoc",
                                        face = "bold"),
             legend.key.size = unit(0.7, "cm"),
             strip.background = element_blank(),
             strip.text = element_text(face= "bold", color = "#c3beb8", size = 9))

#-------------------------------- APP

library(shiny)

ui <- fluidPage(
  selectInput(inputId = "departamento",
              label = "Selecciona un departamento",
              choices = c("Guaviare","Meta", "Vichada", "Casanare")),
  plotOutput(outputId = "mapa")
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
                          filter(UCS_F == "ZVAb"),
                        aes(label = UCS_F, geometry = geometry),
                        alpha = 0.7,
                        col = "grey20",
                        size = 3,
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
                     dist = 50, 
                     dist_unit = "km",
                     transform = TRUE,
                     st.dist = 0.05,
                     st.color = "grey20",
                     st.size = 3,
                     height=0.02,
                     box.color = NA,
                     box.fill = c("grey20","#c3beb8"),
                     family = "robotoc")+
      theme(legend.position = "top")+
      scale_fill_gradientn(colours = pal)+
      guides(colour = "none",
             fill = guide_colourbar(title = "Incertidumbre - Rao",
                                    title.position = "top",
                                    title.hjust = 0.5,
                                    barwidth = unit(15,"lines"),
                                    barheight = unit(0.5,"lines")))
    
    
  })
  
}

shinyApp(ui, server)