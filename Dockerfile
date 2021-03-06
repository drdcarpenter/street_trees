# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# install R packages
RUN R -e "install.packages('shinydashboard')"

RUN R -e "install.packages(c('leaflet', 'readr', 'dplyr', 'DT'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# copy necessary files
## app folder
COPY app.R /srv/shiny-server/street_trees/
COPY street_trees.csv /srv/shiny-server/street_trees/

RUN sudo rm /srv/shiny-server/index.html
COPY index.html /srv/shiny-server/index.html
COPY /index_files /srv/shiny-server/index_files/
COPY dc_temp.jpg /srv/shiny-server/dc_temp.jpg
