#do not put install.packages() in script - prevent repeated downloading.can write in console
#libraries (ex. tidyverse) can contain functions and/or data 

library(tidyverse)
library(palmerpenguins)
library(here)
library(janitor)

#don't use setwd(), won't work on other computers. use here() instead
here()

#penguins_raw is a variable from the palmerpenguins package data
head(penguins_raw)
colnames(penguins_raw)
#problem: spaces in column names, brackets & slashes, different capitalization patterns
#in this case, never go into the original excel file to change names because it will not be reproducible

#save the raw data first using here()
write.csv(penguins_raw, here("data","penguins_raw.csv"))
#this means save penguins_raw in the folder "data" in the current project with the filename "penguins_raw.csv"

#removing the "Comments" column by:
#penguins_raw <- select(penguins_raw, -Comments)
#is bad practice because it will overwrite if the code is ran again.
#should save the deleted version into a new name 

#we can reload the complete version from the file saved before:
penguins_raw <- read.csv(here("data", "penguins_raw.csv"))

#using piping to remove columns comments AND delta columns
#and use janitor package to clean column names - remove spaces and make everything lowercase
#piping symbol %>% means "and"
penguins_clean <- penguins_raw %>%
  select(-Comments) %>%
  select(-starts_with("Delta")) %>%
  clean_names()

write.csv(penguins_clean, here("data","penguins_clean.csv"))

#creating a function in R 
cleaning_penguin_clolumns <- function(raw_data){
  raw_data %>%
    select(-Comments) %>%
    select(-starts_with("Delta")) %>%
    clean_names()
}
penguins_clean <- cleaning_penguin_clolumns(penguins_raw)
colnames(penguins_clean)

#loading functions from a separate file 
source(here("functions","cleaning.R"))
penguins_shortnames <- shorten_species(penguins_clean)
penguins_shortnames$species

#environment: storing all the packages used for this project for other people to run
#renv::init()
#renv::snapshot()
#these should be written in the console 
#snapshot: take a snapshot of the current packages being used and store them in env
#Call renv::init() to start using renv in the current project. 
#If you call renv::init() with a project that is already using renv, 
#it will attempt to do the right thing: it will restore the project library, 
#or otherwise ask you what to do.



#-------------------------------Session2: Figures------------------------------
library(ggplot2)

penguins_clean <- read_csv(here("data", "penguins_clean.csv"))

#making plot from penguins_clean gave warning message because it has NAs

#subset the columns, only species and flipper length
#remove NAs from the two variables to solve the warning message 
penguins_flippers <- penguins_shortnames %>%
  select(c("species", "flipper_length_mm")) %>%
  drop_na()
colnames(penguins_flippers)

#redo the plot

species_colours <- c("Adelie" = "darkorange",
                     "Chinstrap" = "purple",
                     "Gentoo" = "cyan4")

flipper_boxplot <- ggplot(
  data = penguins_flippers,
  aes(x = species,
      y = flipper_length_mm)) + 
  geom_boxplot(aes(color = species),
               show.legend = FALSE,
               width = 0.4) +
  geom_jitter(aes(color = species),
              alpha = 0.3,
              show.legend = FALSE,
              position = position_jitter(
                width = 0.2,
                seed = 0)) + 
  scale_color_manual(values = species_colours) + 
  labs(x = "Species",
       y= "Flipper Length (mm)") + 
  theme_bw()
flipper_boxplot

#for the jitterplot, use a random seed to make sure the dots 
#appear in the same arrangement on the x-axis every time you 
#run the graph (the x-distribution is random)

#can make a separate file for plotting and make plotting into a function 
#plot_boxplot <- function(data,
#                         x_column,
#                         y_column,
#                         x_label,
#                         y_label, 
#                         colour_mapping) 
#       etc. 
# then, can make multiple different plots with several lines 
# plot1 <- plot_boxplot(data = penguin_clean, x = species, y = flipper_length_mm, xlab = "" ) 
#   etc.


#saving & scaling of the figures: use the "ragg" and "svglite" packages 






