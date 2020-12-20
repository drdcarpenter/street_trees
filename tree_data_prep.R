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


# parking spaces

t <- 14

ps <- case_when(
  t == 7 ~ 180,
  t == 14 ~ 190,
  t == 28 ~ 194)
ps

# colour tree species

st <- read_csv("street_trees.csv")

st <- st %>% 
  mutate(color = case_when(
    Species == "Acer campestre" ~ "red",
    Species == "Crataegus monogyna" ~ "green",
    Species == "Prunus cerasifera" ~ "yellow",
    Species == "Sorbus intermedia" ~ "blue"
  ))
glimpse(st)

write_csv(st, "street_trees.csv")
