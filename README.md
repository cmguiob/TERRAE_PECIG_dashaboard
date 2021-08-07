# Explora los suelos del PMA - PECIG 

## El dashboard
### The dashboard
 
 Este repositorio contiene la documentación y el código para un dashboard interactivo creado con R-shiny. El dashboard permite visibilizar y explorar la complejidad de las *Unidades Cartográficas de Suelos (UCS)* presentadas en el [Plan de Manejo Ambiental (PMA)](https://www.anla.gov.co/proyectos-anla/proyectos-de-interes-en-evaluacion-pecig) del **Programa para la Erradicación de Cultivos Ilícitos con Glifosato (PECIG)** en 2019/2020. El dashboard sintetiza los resultados de una [consultoría](https://c337b8bf-6dae-4ebe-9a71-68b759c9d01e.filesusr.com/ugd/302d3c_be8a0e0f57ae4a4484e502664722b442.pdf) realizada con la  [Corporación Geoambiental Terrae](https://www.terraegeoambiental.org/) para la [ONG Dejusticia](https://www.dejusticia.org/por-que-dijimos-no-a-las-fumigaciones-aereas-con-glifosato-durante-una-audiencia-publica/), con quienes generamos nuevos análisis en torno a esta problemática, [presentados](https://c337b8bf-6dae-4ebe-9a71-68b759c9d01e.filesusr.com/ugd/302d3c_3fac02b7c1524de9bd8d273adb722dd9.pdf) en la audiencia pública de la ANLA diciembre 2019.
 
*In this repo you will find documentation and code for a R-shiny dashboard that visibilizes and explores the complexity of soil-related data from the Plan for Erradication of Illicit Crops with Glyphosate [(PECIG)](https://www.anla.gov.co/proyectos-anla/proyectos-de-interes-en-evaluacion-pecig) in Colombia.*

## ¿Por qué?
#### Why?

El PMA presenta mapas categóricos de cloropletas de UCS y tablas con algunas de sus características. Sin emabargo, visualizar las decenas de UCS de esta forma satura la capacidad de percepción y análisis en la toma de decisiones ambientales, en este caso, de la incertidumbre -central en el principio de precaución-. El [dashboard *suelosPECIG*](https://cmguiob.shinyapps.io/suelosPECIG/) es una herramienta pedagógica, exploratoria y de visibilización para entender la complejidad y distribución de las UCS en cuatro áreas designadas para aspersión de glifosato. La documentación del dashboard se presenta como [reporte simplificado](https://github.com/cmguiob/UCS_PECIG_dashaboard/tree/main/Reporte) -con código- que explica los datos, el procesamiento, las métricas y los principios para la creación del dashboard.

*The environmental management plan for the PECIG presents categorical chloropleth maps of hundreds cartographic soil units (CSUs), which make difficult to interpret soil data in form of uncertainty. With the [dashboard *suelosPECIG*](https://cmguiob.shinyapps.io/suelosPECIG/) I intend to convey the distribution, meaning and complexity of CSUs within the framework of the precautionary principle in environmental decision-making.*

### El punto de partida
#### The point of departure

![UCS_PMA](https://raw.githubusercontent.com/cmguiob/UCS_PECIG_dashaboard/main/UCS_San%20Jose_PMA.jpg)

### Explora la distribución, significado y complejidad de UCS con el [dashboard!](https://cmguiob.shinyapps.io/suelosPECIG/)
#### Explore CSUs distribution, meaning and complexity with the [dashboard!](https://cmguiob.shinyapps.io/suelosPECIG/)

![dashboard_soelosPECIG](https://github.com/cmguiob/UCS_PECIG_dashaboard/raw/main/app_gif.gif)

## ¿Interés en colaborar?
#### Would you like to to contribute?

Este dashboard es una simplificación en varios sentidos: no explora aún las propiedades de cada tipo de suelo por UCS (si hay datos!!), se limita a cuatro departamentos y utiliza un algorítmo realmente básico para estimar incertidumbre/diversidad. POdrías colabora con financiación, código o distribución del dashboard!

*This dashboard is a siplification in many ways: it doesn't explore yet the properties of each soil type present in the CSUs (although the data exists!!), it is limited to four departments and it uses a basic algorithm to estimate uncertainty/diversity. Either funding, coding collaboration or spreading the dashboard woud be appreaciated!*



