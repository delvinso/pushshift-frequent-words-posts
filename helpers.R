
library(hrbrthemes)
import_roboto_condensed()

theme_dark_ds <- function(base_size = 12, grid = "x"){
  theme <- theme_bw(base_size) + 
    theme(  text = element_text(face = "bold", family = "Roboto Condensed", colour = "grey"),
            plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5, face = "bold"),
            #axis.text.x = element_text(angle = 45, hjust = 1),  
            axis.text = element_text(colour = "grey", face = "bold"),
            axis.ticks = element_line(colour = "grey"),
            panel.border = element_rect(colour = "white"),
            plot.background = element_rect(fill = "#252525", colour = "#252525"),
            panel.background = element_rect(fill = "#252525", colour = "#252525"),
            panel.grid.major = element_line(colour = "grey", size = 1),
            # panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            legend.background = element_rect(fill = "#252525", size = 6),
            legend.key = element_rect(colour = "grey", fill = "#252525"),
            strip.background = element_rect(fill = "#252525", colour = "white"),
            strip.text = element_text(colour = "grey", face = "bold")
    ) 
  
  if(grid == "Y"){
    theme + theme(panel.grid.major.y = element_blank())
  } else if(grid == "X"){
    theme + theme(panel.grid.major.x = element_blank())
  } else theme + theme(panel.grid.major = element_blank())
  
}
