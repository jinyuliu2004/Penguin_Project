library(ggplot2)
source(here("functions", "cleaning.R"))

penguins_clean <- cleaning_penguin_clolumns(penguins_raw)
colnames(penguins_clean)
penguins_shortnames <- shorten_species(penguins_clean)
penguins_shortnames$species
