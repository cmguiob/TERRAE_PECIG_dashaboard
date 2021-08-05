# Explora los suelos del PMA - PECIG 
## Un dashboard
 
 Este repositorio contiene la documentación y el código para un dashboard interactivo creado con R-shiny. El dashboard permite visibilizar y explorar la complejidad de las *Unidades Cartográficas de Suelos (UCS)* presentadas en el [Plan de Manejo Ambiental (PMA)](https://www.anla.gov.co/proyectos-anla/proyectos-de-interes-en-evaluacion-pecig) del **Programa para la Erradicación de Cultivos Ilícitos con Glifosato (PECIG)** en 2019/2020.
 
*A dashboard to visibilize and explore the complexity of soil-related data from the Plan for Erradication of Illicit Crops with Glyphosate [(PECIG)](https://www.anla.gov.co/proyectos-anla/proyectos-de-interes-en-evaluacion-pecig) in Colombia.*

## ¿Por qué?

El PMA presenta un mapa de UCS y tablas con algunas de sus características. Sin emabargo, visualizar las decenas de UCS como polígonos de categorías satura la capacidad de percepción y análisis en la toma de decisiones ambientales, en este caso, de la incertidumbre -central en el principio de precaución-. El [dashboard *suelosPECIG*](https://cmguiob.shinyapps.io/suelosPECIG/) es una herramienta pedagógica, exploratoria y de visibilización para entender la complejidad y distribución de las UCS en tres de los núcleos designados para aspersión de glifosato. La documentación del dashboard se presenta como [reporte simplificado](https://github.com/cmguiob/UCS_PECIG_dashaboard/tree/main/Reporte) -con código- que explica los datos, el procesamiento, las métricas y los principios para la creación del dashboard.

### El punto de partida
#### *The point of departure*

![UCS_PMA](https://raw.githubusercontent.com/cmguiob/UCS_PECIG_dashaboard/main/UCS_San%20Jose_PMA.jpg)

### Explora la distribución, significado y complejidad de UCS con el [dashboard!](https://cmguiob.shinyapps.io/suelosPECIG/)
#### *Explore CSUs distribution, meaning and complexity with the [dashboard!](https://cmguiob.shinyapps.io/suelosPECIG/)*

![dashboard_soelosPECIG](https://github.com/cmguiob/UCS_PECIG_dashaboard/raw/main/app_gif.gif)

### Trabajo por hacer ...

Este dashboard es una simplificación en varios sentidos: no presenta aún curvas de propiedades de cada tipo de suelo (si hay datos!!), se limita a cuatro departamentos y utiliza un algorítmo realmente básico para estimar incertidumbre/diversidad. El dashboard sintetiza los resultados de una [consultoría](https://c337b8bf-6dae-4ebe-9a71-68b759c9d01e.filesusr.com/ugd/302d3c_be8a0e0f57ae4a4484e502664722b442.pdf) realizada con apoyo de la  [Corporación Geoambiental Terrae](https://www.terraegeoambiental.org/) y patrocinio de la [ONG Dejusticia](https://www.dejusticia.org/por-que-dijimos-no-a-las-fumigaciones-aereas-con-glifosato-durante-una-audiencia-publica/), con quienes colaboré para generar nuevos análisis en torno a esta problemática, los cuáles [presentamos](https://c337b8bf-6dae-4ebe-9a71-68b759c9d01e.filesusr.com/ugd/302d3c_3fac02b7c1524de9bd8d273adb722dd9.pdf) en la udiencia pública de diciembre 2019.




