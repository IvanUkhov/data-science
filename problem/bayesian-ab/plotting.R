plot <- function(data,
                 y = 'expected_loss',
                 color = 'passed_any',
                 line = NA,
                 labels = c('Not passed', 'Passed')) {
  day_max <- max(data$day)
  end_points <- data %>%
    group_by(replication) %>%
    filter(day == max(day),
           day != day_max) %>%
    slice(1)
  data %>%
    ggplot(aes_string('day', y, group = 'replication')) +
    geom_line(aes_string(alpha = color, color = color)) +
    geom_hline(color = 'orange', yintercept = line, lty = 2) +
    geom_point(data = end_points, color = 'orange') +
    scale_color_manual(values = c('black', 'orange'), labels = labels) +
    scale_alpha_manual(values = c(0.1, 1), labels = labels) +
    labs(x = 'Day of experiment', color = '', alpha = '')
}
