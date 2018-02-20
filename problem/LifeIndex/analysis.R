rm(list = ls())

library(ggplot2)

load.BLI <- function(path) {
  data <- read.csv(path)
  data <- subset(data, INEQUALITY == 'TOT')
  data <- subset(data, Indicator == 'Life satisfaction')
  data <- data[c('Country', 'Value')]
  data <- subset(data, Country != 'OECD - Total')
  names(data)[2] <- 'LI'
  return(data)
}

load.IMF <- function(path, scale = 1000) {
  data <- read.table(path, header = TRUE, sep = '\t', encoding = 'latin1',
                     na.strings = 'n/a', quote = '', blank.lines.skip = TRUE)
  data <- data[, c('Country', 'X2015')]
  names(data)[2] <- 'GDP'
  data$GDP <- as.character(data$GDP)
  data$GDP <- gsub(',', '', data$GDP)
  data$GDP <- as.double(data$GDP) / scale
  data <- subset(data, !is.na(GDP))
  return(data)
}

load <- function(path.BLI, path.IMF) {
  data <- merge(load.BLI(path.BLI), load.IMF(path.IMF),
                by = 'Country', all = FALSE)
  data$Country = droplevels(data$Country)
  return(data)
}

plot.scatter <- function(data) {
  n <- nlevels(data$Country)
  shapes <- rep(seq(1, 6), ceiling(n / 6))[1:n]
  plot <- ggplot(data, aes(x = GDP, y = LI, color = Country, shape = Country))
  plot <- plot + scale_shape_manual(values = shapes)
  plot <- plot + geom_point(size = 2, stroke = 1)
  plot <- plot + xlab('GDP per capita') + ylab('Life index')
  return(plot)
}

data <- load('data/bli.csv', 'data/imf.dat')
plot.scatter(data)
