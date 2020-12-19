library(readr)
library(dplyr)

# add species to street tree point data
st <- read_csv("street_trees.csv")

spp <- c("Acer campestre",
         "Crataegus monogyna",
         "Prunus cerasifera",
         "Sorbus intermedia")

probs <- c(0.30, 0.15, 0.30, 0.25)

set.seed(111)

st <- 
  st %>% 
  group_by(centres) %>% 
  mutate(Species = sample(spp, size = n(), prob = probs, replace = TRUE)) %>% 
  arrange(centres) %>% 
  ungroup()

st$dbh <- 9

st <- select(st, id, x, y, centres, Species, dbh)
write_csv(st, "street_trees.csv", append = FALSE)

# test summary table

street_trees <- read_csv("street_trees.csv")

st <- read_csv("street_trees.csv")

sts <- st %>% filter(centres == 28) %>% 
  summarise(`Carbon stored (kg)` = sum(Carbon_Storage_kg), 
            `Carbon Sequestration (kg/yr)` = sum(Carbon_Sequestration_kg_yr),
            `Pollution Removed (g/yr)` = sum(Pollution_Removal_g_yr))
sts$`Carbon stored (kg)`

# add pollution data
tb <- read_csv("tree_benefits.csv")


stb <- left_join(st, tb, by = c("Species" = "Species_Name"))
stb
glimpse(stb)

write_csv(stb, "street_trees.csv")
