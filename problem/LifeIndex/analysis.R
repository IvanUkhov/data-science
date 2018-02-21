plot.scatter <- function(data) {
  n <- nlevels(data$Country)
  shapes <- rep(seq(1, 6), ceiling(n / 6))[1:n]
  plot <- ggplot(data, aes(x = GDP, y = LI, color = Country, shape = Country))
  plot <- plot + scale_shape_manual(values = shapes)
  plot <- plot + geom_point(size = 2, stroke = 1)
  plot <- plot + xlab('GDP per capita') + ylab('Life index')
  return(plot)
}
