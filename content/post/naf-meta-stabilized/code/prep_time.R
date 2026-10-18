res <- df %>%
  filter(month_date > as.Date("2023-12-31") & month_date < as.Date("2026-10-01") & variantname %in% c("Blood Bowl 2020","Blood Bowl 2025") & gamedate_ok == 1) %>%
  #filter(country == "Netherlands") %>%
  group_by(year, month_date,  name, variantname) %>%
  summarize(n_games = n_distinct(coach_name)) %>%
  ungroup() %>%
  group_by(year, month_date, variantname) %>%
  mutate(total_games = sum(n_games)) %>%
  mutate(share = n_games/total_games)

res <- res %>%
  filter(!(year == 2026 & variantname == "Blood Bowl 2020"))

res <- res %>%
  left_join(sort_order, join_by("name"))

res$sort_name <- reorder(res$name, res$sort_order)

# * Little effect: unshaken
small_eff <- c(7, 9, 20, 21, 22)

#*  instant pos effect with (partial) bounce back
pos_eff_bb <- c(6, 10, 11, 17, 19, 26, 31)

#*  inst drop with (partial) bounce back
neg_eff_bb <- c(14, 16, 18, 23, 25, 28, 30)

#* Instant neg effect without bounce back
inst_eff_no_bb <- c(24, 27, 29)

#* Gradual effect with bounce back
grad_bb <-c(5, 13, 15)

# * Something else 
smth_else <- c(3, 4,  12)

all <- c(1,2,8, small_eff, pos_eff_bb, neg_eff_bb, inst_eff_no_bb, grad_bb, smth_else)