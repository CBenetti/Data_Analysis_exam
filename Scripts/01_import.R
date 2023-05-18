	
##Library loading
	library(Biobase)
	library(BiocManager)
	library(edgeR)
	#BiocManager::install('ensembldb')
        library(ensembldb)
	#BiocManager::install('AnnotationHub')
        library(AnnotationHub)

##Database download and loading
	setwd("Dataset/")
	#system("wget https://ftp.ncbi.nlm.nih.gov/geo/series/GSE179nnn/GSE179983/suppl/GSE179983_pdx_hs33_counts.txt.gz")
	#system("gunzip GSE179983_pdx_hs33_counts.txt.gz")
	setwd("../")
	ds <- read.table("Dataset/GSE179983_pdx_hs33_counts.txt", sep=",", header=T, row.names=1)


##Geneid conversion
   #Download an annotation version compatible with Genome assembly hs33	
	ah <- AnnotationHub()
	ahDb <- query(ah, pattern = c("Homo Sapiens", "EnsDb", 99))
	ahEdb <- ahDb[[1]]
	
   #Remove versioning from Ensembl Geneid
	ENS <- unlist(lapply(rownames(ds),function(x){strsplit(x,".",fixed=TRUE)[[1]][1]}))
	Tx <- unlist(lapply(ENS,function(x){genes(ahEdb,filter = GeneIdFilter(x))$gene_name}))

##phenoData annotation

	pd <- readLines("Dataset/GSE179983_biosample.txt")
	pd<-pd[seq(1,90,5)]
	tumor <- unlist(lapply(pd,function(x){strsplit(strsplit(x,"Breast ")[[1]][2],", ")[[1]][1]}))
	tumor <- gsub(" ","",tumor)
	stroma <- unlist(lapply(pd,function(x){strsplit(strsplit(x,", ")[[1]][2]," gel")[[1]][1]}))
	tmp <- unlist(lapply(pd,function(x){gsub("\\]","",strsplit(x,", ")[[1]][3])}))
	name <- unlist(lapply(tmp, function(x){strsplit(x," \\[")[[1]][2]}))
	rep <- unlist(lapply(tmp, function(x){strsplit(x," \\[")[[1]][1]}))
	phenoD <- data.frame(stroma=factor(stroma),patient=factor(tumor),replicate=factor(rep))
	rownames(phenoD) <- name
	colnames(ds) <- unlist(lapply(colnames(ds),function(x){strsplit(x,"\\.")[[1]][1]}))
	phenoD <- phenoD[colnames(ds),]

##Building ExpressionSet

	minimalSet <- ExpressionSet(assayData=as.matrix(ds))
	phenoData(minimalSet) <- new("AnnotatedDataFrame",data=phenoD)
	featureData(minimalSet) <- new("AnnotatedDataFrame",data=data.frame(Geneid=Tx,ENS=ENS))
	counts <- cpm(ds)
	logcounts <- cpm(ds,prior.count=1,log=TRUE)
	countset <- ExpressionSet(assayData=as.matrix(counts))
	phenoData(countset) <- new("AnnotatedDataFrame",data=phenoD)
        featureData(countset) <- new("AnnotatedDataFrame",data=data.frame(Geneid=Tx,ENS=ENS))
	logc <- ExpressionSet(assayData=as.matrix(logcounts))
	phenoData(logc) <- new("AnnotatedDataFrame",data=phenoD)
        featureData(logc) <- new("AnnotatedDataFrame",data=data.frame(Geneid=Tx,ENS=ENS))
	
	
	GSE179983 <- list(minimal = minimalSet,count = countset, log = logc)

save(GSE179983, file="Dataset/GSE179983.rda")
