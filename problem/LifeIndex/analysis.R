rm(list = ls())

library(ggplot2)

readIMF <- function(path, scale = 1000) {
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

readBLI <- function(path) {
  data <- read.csv(path)
  data <- subset(data, INEQUALITY == 'TOT')
  data <- subset(data, Indicator == 'Life satisfaction')
  data <- data[c('Country', 'Value')]
  data <- subset(data, Country != 'OECD - Total')
  names(data)[2] <- 'LS'
  return(data)
}

load <- function(bli_path, imf_path) {
  data <- merge(readBLI(bli_path),
                readIMF(imf_path),
                by = 'Country', all = FALSE)
  data$Country = droplevels(data$Country)
  return(data)
}

plot.scatter <- function(data) {
  n <- nlevels(data$Country)
  shapes <- rep(seq(1, 6), ceiling(n / 6))[1:n]
  plot <- ggplot(data, aes(x = GDP, y = LS, color = Country, shape = Country))
  plot <- plot + scale_shape_manual(values = shapes)
  plot <- plot + geom_point(size = 2, stroke = 1)
  plot <- plot + xlab('GDP per capita') + ylab('Life satisfaction')
  return(plot)
}

data <- load('data/bli.csv', 'data/imf.dat')
plot.scatter(data)