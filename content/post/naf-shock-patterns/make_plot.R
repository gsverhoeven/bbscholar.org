make_plot <- function(data, ncol = 4, smoothing_group_var = "variantname", quadratic = FALSE){
  
  if (quadratic){
    smoothing_formula = as.formula("y ~ x + I(x^2)")
  } else {
    smoothing_formula = as.formula("y ~ x")
  }
  
  gp1 <- ggplot(data = data, aes(x = month_date, y = share*100, col = factor(variantname))) +
    geom_vline(xintercept = as.Date("2025-12-01"), col = "darkgrey") +
    geom_point(aes(size = n_games)) + 
    expand_limits(y = 0) + 
    facet_wrap(~ sort_name, ncol = ncol) +  
    theme(legend.position = "none")  + 
    ylab("Relative share %") + 
    xlab("") + 
    geom_smooth(aes(group = factor(.data[[smoothing_group_var]]), weight = n_games), method = MASS::rlm, 
                formula = smoothing_formula, se = TRUE, colour = "black") +
    coord_cartesian(ylim = c(0, 10)) +
    scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
    scale_size_area()
  # return plot object
  gp1
}
