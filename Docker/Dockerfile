FROM rocker/r-ubuntu
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
RUN apt-get install -y nano
RUN apt-get install -y wget
RUN apt-get install pandoc
RUN Rscript --vanilla -e "install.packages(c(BiocManager','edgeR','Rtsne','umap','reticulate','rmarkdown'),repos='http://cran.us.r-project.org')" 
RUN Rscript --vanilla -e "BiocManager::install(c('Biobase','ensembldb','AnnotationHub','DESeq2'))"

