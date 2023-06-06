
FROM rocker/r-ubuntu
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
RUN apt-get install -y nano
RUN apt-get install -y wget
RUN apt-get update
RUN sudo apt install -y build-essential checkinstall zlib1g-dev
RUN sudo apt-get install -y libssl-dev
RUN sudo apt-get install -y libxml2-dev
RUN sudo sudo apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y pandoc
RUN Rscript --vanilla -e "install.packages(c('BiocManager','Rtsne','umap','reticulate','rmarkdown','circlize'),repos='http://cran.us.r-project.org')" 
RUN Rscript --vanilla -e "BiocManager::install(c('Biobase','ensembldb','AnnotationHub','edgeR','DESeq2','ComplexHeatmap'))"

