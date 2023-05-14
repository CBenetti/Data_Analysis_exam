FROM rocker/r-ubuntu
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
RUN apt-get install -y nano
RUN apt-get install -y wget
RUN Rscript --vanilla -e "install.packages(c('Biobase','BiocManager','Biobase','edgeR','Rtsne','umap','reticulate','rmarkdown'),repos='http://cran.us.r-project.org')" 


