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

sts <- street_trees %>% filter(centres == 7) %>% 
  summarise(`total c` = sum(centres), total_d = sum(dbh))
sts
