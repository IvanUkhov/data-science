FROM rocker/rstudio:latest

RUN apt-get update && apt-get install -y \
  imagemagick \
  texlive \
  texlive-latex-extra

RUN R -e "install.packages('caTools')"
RUN R -e "install.packages('ggplot2')"
RUN R -e "install.packages('rmarkdown')"
