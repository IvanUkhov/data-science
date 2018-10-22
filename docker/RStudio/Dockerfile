FROM rocker/rstudio:latest

RUN apt-get update && apt-get install -y \
  imagemagick \
  libxml2-dev \
  texlive \
  texlive-latex-extra \
  zlib1g-dev

RUN R -e "install.packages('caTools')"
RUN R -e "install.packages('rmarkdown')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('ggrepel')"
RUN R -e "install.packages('plotly')"
