
# Differential expression analysis on the geneset GSE179983: relationship between stromal stiffness and cancer cell features
This is the GitHub repository containing all the information about the exam.

In the main folder you can find the Rmd file, with the instructions to compile an rmarkdown html output. 

Due to the size limitations of GitHub, the html with the rmarkdown file cannot be visualized without first downloading the raw html file. I apologize for the inconvenience.

This repository is divided in 5 sections:

### Dataset/

The folder contains the txt file downloaded from [GEO](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE179983) and the Expressionset object used for the analysis.

### Scripts/

The folder containing the 3 main Rscripts required for the analyis. Each script is throughfully explained in the rmarkdown file.

### Results/ 

The folder containing images and objects as a result of the analysis.

### Images/

Folder containing some useful images used in the rmarkdown.


To reproduce the analysis, it must be downloaded as follows:

```bash
git clone https://github.com/CBenetti/Data_Analysis_exam.git
```

To ensure reproducibility, instructions on how to pull or build the Docker environment are available in the [Docker folder](https://github.com/CBenetti/Data_Analysis_exam/tree/main/Docker) 
as a README.md file.
After running the docker with the instructions on the Docker folder, working directory is set and analysis sourced as follows:

```bash
cd var/log/Data_Analysis_exam/
Rscript Scripts/01_import.R
Rscript Scripts/02_dimensional_reduction_plot.R
Rscript Scripts/03_differential_expression.R
Rscript --vanilla -e 'rmarkdown::render("CBproject.Rmd")'
```
