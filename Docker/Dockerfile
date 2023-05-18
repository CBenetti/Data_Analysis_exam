
FROM rocker/r-ubuntu
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
RUN apt-get install -y nano
RUN apt-get install -y wget
RUN apt-get update
RUN sudo apt install build-essential checkinstall zlib1g-dev -y
RUN sudo apt-get install libssl-dev
RUN sudo apt-get install libxml2-dev
RUN sudo sudo apt-get install libcurl4-openssl-dev
RUN apt-get install pandoc
RUN Rscript --vanilla -e "install.packages(c(BiocManager','Rtsne','umap','reticulate','rmarkdown'),repos='http://cran.us.r-project.org')" 
RUN Rscript --vanilla -e "BiocManager::install(c('Biobase','ensembldb','AnnotationHub','edgeR','DESeq2'))"

