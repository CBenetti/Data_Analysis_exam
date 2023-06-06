	
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
	if(!file.exists(getAnnotationHubOption("CACHE"))){
		here<-getwd()
		setwd("~")
		home <- unlist(strsplit(getwd(),"/"))
		obj <- unlist(strsplit(getAnnotationHubOption("CACHE"),"/")) 
		abs <- obj[which(match(obj,home, nomatch=0)==0)]
		for(i in 1:length(abs)){dir<-paste(abs[c(1:i)],collapse="/");if(!file.exists(dir)){dir.create(dir)}}
		setwd(here)
	}
	ah <- AnnotationHub()
	ahDb <- query(ah, pattern = c("Homo Sapiens", "EnsDb", 99))
	ahEdb <- ahDb[[1]]
	rownames(ds)[which(match(rownames(ds),genes(ahEdb)$gene_id_version,nomatch=0)==0)]
	tmp <- unlist(lapply(rownames(ds)[which(match(rownames(ds),genes(ahEdb)$gene_id_version,nomatch=0)==0)],function(x){strsplit(x,"_")[[1]][1]}))
	tmp%in%rownames(ds)
	Tx <- vector(length=length(rownames(ds)))
	biotype <- vector(length=length(rownames(ds)))
	names(Tx) <- rownames(ds)
	names(biotype) <- rownames(ds)
 
	#Assigning symbols for Id's which match
	main <- genes(ahEdb)[which(match(genes(ahEdb)$gene_id_version,rownames(ds)[which(match(rownames(ds),genes(ahEdb)$gene_id_version,nomatch=0)>0)],nomatch=0)>0)]
	ids <- as.vector(main$gene_id_version)
	sym <- as.vector(main$symbol)
	Tx[ids] <- sym
        bio <- as.vector(main$gene_biotype)
        biotype[ids] <- bio

	#Assigning symbols for IDs which don't
	main <- genes(ahEdb)[which(match(genes(ahEdb)$gene_id_version,tmp,nomatch=0)>0)]
        ids <- as.vector(main$gene_id_version)
        sym <- as.vector(main$symbol)         
	sym <- unlist(lapply(sym, function(x){paste(c(x,"_PAR_Y"),collapse="")}))
        Tx[ids] <- sym
	bio <- as.vector(main$gene_biotype)
	biotype[ids] <- bio
	names(biotype) <- NULL
	names(Tx)<- NULL

	#Info on duplicated symbols
	dup <- Tx[which(duplicated(Tx)==TRUE)]
	info_on_duplicated_id <- genes(ahEdb)[which(match(genes(ahEdb)$gene_id_version,rownames(ds)[ which(Tx%in%dup ==TRUE)],nomatch=0)>0),] 
	save(info_on_duplicated_id,file="Results/Duplicated_id_info.rda")
	
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
	featureData(minimalSet) <- new("AnnotatedDataFrame",data=data.frame(Geneid=Tx, Biotype=biotype))
	counts <- cpm(ds)
	logcounts <- log(counts+1,2)
	countset <- ExpressionSet(assayData=as.matrix(counts))
	phenoData(countset) <- new("AnnotatedDataFrame",data=phenoD)
        featureData(countset) <- new("AnnotatedDataFrame",data=data.frame(Geneid=Tx,Biotype=biotype))
	logc <- ExpressionSet(assayData=as.matrix(logcounts))
	phenoData(logc) <- new("AnnotatedDataFrame",data=phenoD)
        featureData(logc) <- new("AnnotatedDataFrame",data=data.frame(Geneid=Tx,Biotype=biotype))
	
	
	GSE179983 <- list(minimal = minimalSet,count = countset, log = logc)

save(GSE179983, file="Dataset/GSE179983.rda")
