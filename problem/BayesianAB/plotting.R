plot <- function(data,
                 line = 0.05,
                 color = 'pass_end',
                 y_aestetic = 'p_value',
                 labels = c('Not passed', 'Passed')) {
  data %>%
    ggplot(aes_string('day', y_aestetic, group = 'replication')) +
    geom_line(aes_string(alpha = color, color = color)) +
    geom_hline(color = 'red', yintercept = line, lty = 2) +
    scale_color_manual(values = c('black', 'red'), labels = labels) +
    scale_alpha_manual(values = c(0.15, 1), labels = labels) +
    labs(color = '', alpha = '') +
    xlab('Day of experiment')
}
