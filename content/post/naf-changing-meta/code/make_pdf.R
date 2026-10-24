# Load required library
library(ggplot2)
library(patchwork)

# 1. Define the output file path and dimensions
pdf_path <- "all_team_popularity_plots.pdf"

# 2. Open the PDF graphics device
# You can set the global paper width and height here (in inches)
pdf(file = pdf_path, width = 8.5, height = 5)

# 3. Generate and print plots in a loop
for (i in 1:31) {
  # Create a dummy ggplot
  tmp_res <- res %>% filter(share < 0.25 & sort_order %in% i)
  p1 <-  make_plot(tmp_res, ncol = 1)
  p2 <-  make_plot(tmp_res, ncol = 1, quadratic = T)
  p <- p1 + p2
  # CRITICAL: You must use print() inside loops/scripts 
  # to force R to render the ggplot to the PDF device.
  print(p)
}

# 4. Close the PDF device to finalize and save the file
dev.off()

message("PDF successfully saved to: ", pdf_path)