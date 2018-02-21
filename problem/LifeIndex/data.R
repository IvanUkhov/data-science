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
                     na.strings = 'n/a', quote = '', nrows = 189)
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
