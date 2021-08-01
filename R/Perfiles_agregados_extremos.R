#-------------------------------------------------------------------------------
# SOIL PROFILE MODELING - PECIG
#-------------------------------------------------------------------------------
# Author: Carlos Guio
# Contact: macguiob@gmail.com 
# Organization: Terrae
# Date last modified: 28-07-2020
#-------------------------------------------------------------------------------
# DESCRIPTION:
# This sript plots aggregated soil  profiles for different properties for the meta region
# and a soil profiles collection of specific anomalous soils.
#-------------------------------------------------------------------------------
# OBJECTIVES:
# 1. Slab aggregation for Meta region 
# 2. Slab aggregation for Meta and soils with shallow water table
# 3. Comparison with range of properties from PMA-PECIG for Kd
# 4. Comparison with water table
# 5. Soil profile plotting with inderlying values of C, CEC and P

#-------------------------------------------------------------------------------
#PRELIMINARY WORK ON DATA
# Data was collected from the IGAC 1:100k soil survey from Meta in a Excel table
#-------------------------------------------------------------------------------
# LOAD DATA 
#-------------------------------------------------------------------------------

# Load soil horizon and site data
meta_hz <- read.csv("Datos/DB_Propiedades_perfiles/DBR_Perfiles_Meta_Horiz.csv")  
meta_site <- read.csv("Datos/DB_Propiedades_perfiles/DBR_Perfiles_Meta_Site.csv")  

# Create long-lat variables
NWconv <- function(i,j,k){i+j/60+k/3600} # create new variable with coordinates
meta_site$lat <- NWconv(meta_site$NG,meta_site$NM,meta_site$NS)
meta_site$long <- NWconv(meta_site$WG,meta_site$WM,meta_site$WS)*-1

# Extract NF  variables to plot as brackets later

#-------------------------------------------------------------------------------
# SET SOIL PROFILE COLLECTION
#-------------------------------------------------------------------------------
library(aqp)
depths(meta_hz) <- PERFIL ~ TOPE + BASE

# Set profiles locations
meta_hz$lat <- meta_site$lat # first add it to site data to be able to convert them to profile coordinates
meta_hz$long <- meta_site$long
print(meta_hz)

#Initialize coordinates
coordinates(meta_hz) <- ~ long + lat
coordinates(meta_hz)
print(meta_hz)

# Set spatial reference system
proj4string(meta_hz) <- '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
proj4string(meta_hz) 
print(meta_hz)

# See soil profile locations - important to check whether some coordinates are wrong
meta_soils.sp <- as(meta_hz, 'SpatialPointsDataFrame')
# plot the fake coordinates
plot(meta_soils.sp)
box()

#-------------------------------------------------------------------------------
# PLOT AGGREGATED PROFILE DATA
#-------------------------------------------------------------------------------
library(lattice)


meta_agg <- slab(meta_hz, fm= ~ C + P + CICA + ESTR_PT)
head(meta_agg)

# Set some parameters to delete the strip background, frame and set color line for the median
sty <- list()
sty$strip.border$col <- NA
sty$strip.background$col <- NA
sty$superpose.line$col <- '#CDC0B0'
sty$superpose.line$lwd <- 2.5
sty$layout.heights$strip <-1.5
sty$grid.pars$fontfamily <-"comfortaa"

# Set custom names for the strips
strip_names <-c( "C%" , "P(ppm)","CICA(meq/100g)","ESTR"  )


# Save plot
png(filename="Meta_suelos_agregados.png", 
    type="cairo",
    units="in", 
    width=8, 
    height=4, 
    pointsize=1, 
    res=300)

# Run plot
xyplot(top ~ p.q50 | variable, 
       data=meta_agg,
       ylab=list(label ='Profundidad (cm)', fontsize = 9.5),
       xlab=list(label ='Mediana limitada por cuartiles', fontsize = 9.5),
       lower=meta_agg$p.q25, upper=meta_agg$p.q75, ylim=c(150,-2),
       panel=panel.depth_function,
       alpha=0.3,
       sync.colors=TRUE,
       par.settings=sty,
       prepanel=prepanel.depth_function,
       cf=meta_agg$contributing_fraction, cf.col='#636363', cf.interval=20,
       layout=c(5,1), 
       strip=strip.custom(bg= NA, par.strip.text=list(font=2, cex=0.8, col= "#CDC0B0"),factor.levels=strip_names),
       scales=list(x=list(tick.number=5, alternating=1, relation='free', cex = 0.6),
                   y=list(tick.number=10, alternating=3, cex = 0.6))
)

dev.off() # Finish saving plot

#-------------------------------------------------------------------------------
# EXTRACTION OF NDVI1 VALUES FOR EACH PROFILE
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# PLOT PROFILES
#-------------------------------------------------------------------------------

library(RColorBrewer)
library(wesanderson)

#Subset soil profiles
meta_estr <- meta_hz[c(6,21, 45,52,59,14, 25, 35, 36, 38, 44,48:51), ]
meta_c <- meta_hz[c(6,21, 45,52,59,14, 25, 35, 36, 38, 44,48:51), ]
meta_p <- meta_hz[c(6,21, 45,52,59,14, 25, 35, 36, 38, 44,48:51), ]
meta_cica <- meta_hz[c(6,21, 45,52,59,14, 25, 35, 36, 38, 44,48:51), ]

#Plot
pdf("ESTR_Perfiles_PECIG.pdf", height = 4, width = 7.5)
plot(meta_estr, name = "",color = "ESTR_PT", col.palette = rev(wes_palette("Zissou1", 10, type = "continuous")))
dev.off()

pdf("C_Perfiles_PECIG.pdf", height = 4, width = 7.5)
plot(meta_c, name = "",color = "C", col.palette = brewer.pal(9, 'Greys'))
dev.off()

pdf("P_Perfiles_PECIG.pdf", height = 4, width = 7.5)
plot(meta_p, name = "",color = "P", col.palette = brewer.pal(9, 'PuBuGn'))
dev.off()

pdf("CICA_Perfiles_PECIG.pdf", height = 4, width = 7.5)
plot(meta_cica, name = "",color = "CICA", col.palette = brewer.pal(9, 'PiYG'))
dev.off()
