mm25 <- df %>%
  filter(variantname == "Blood Bowl 2020" & month_date == as.Date("2024-09-01")) %>%
  group_by(name, variantname) %>%
  summarise(n_games = n()) %>%
  ungroup() %>%
  group_by(variantname) %>%
  mutate(tot_games = sum(n_games)) %>%
  mutate(perc = n_games/tot_games)

mm26 <- df %>%
  filter(variantname == "Blood Bowl 2020" & month_date == as.Date("2025-09-01")) %>%
  mutate(variantname = "Blood Bowl 2025") %>%
  group_by(name, variantname) %>%
  summarise(n_games = n()) %>%
  ungroup() %>%
  group_by(variantname) %>%
  mutate(tot_games = sum(n_games)) %>%
  mutate(perc = n_games/tot_games)

sort_order <- mm26 %>%
  arrange(-n_games) %>%
  ungroup() %>%
  mutate(sort_order = 1:n()) %>%
  select(name, sort_order)

mm <- rbind(mm25, mm26) %>%
  left_join(sort_order, join_by(name))

mm <- mm %>% select(name, perc, variantname, sort_order) %>%
  mutate(variantname = str_to_snake(variantname)) %>%
  mutate(perc = 100*perc) %>%
  pivot_wider(values_from = "perc", names_from = "variantname") %>%
  mutate(delta = blood_bowl_2020 - blood_bowl_2025) %>%
  mutate(delta_color = if_else(delta > 0, "green", "red"))
