###library
	library(edgeR)
	library(Biobase)
	library(Rtsne)
	library(DESeq2)
	library(circlize)
	library(ComplexHeatmap)
###loading
	load("Dataset/GSE179983.rda")

###Differential expression analysis

##Deseq object initialization

	dds <- DESeqDataSetFromMatrix(countData = exprs(GSE179983$minimal), colData = data.frame(condition=pData(GSE179983$minimal)$stroma,group=pData(GSE179983$minimal)$patient) ,design = ~ group + condition )
	res <- DESeq(dds)

##Differential results

	summary(results(res))
	higher_in_stiff <- rownames(results(res))[which(results(res)$padj < 0.05 & results(res)$log2FoldChange > 3 & results(res)$baseMean>quantile(results(res)$baseMean, probs=seq(0,1,0.05))[16])]
	red <- exprs(GSE179983$log)[higher_in_stiff,]
	hstiff <- fData(GSE179983$log)$Geneid[which(match(rownames(exprs(GSE179983$log)),higher_in_stiff,nomatch=0)>0)]
	heat <- t(apply(exprs(GSE179983$log),1,function(x){x-mean(x)}))	
	toc <- pData(GSE179983$log)
	toc <- toc[order(toc$patient),]
	toc <- toc[order(toc$stroma),]
	heat <- heat[,rownames(toc)]
	col_fun <- colorRamp2(c(-2, 0, 2), c("blue", "white", "red"))
	ha = rowAnnotation( genes=anno_text(hstiff, gp = gpar(fontsize = 1),show_name = TRUE))
	ht1 <- HeatmapAnnotation(Classification = anno_text(toc$patient, gp=gpar(fontsize=8,fill=c(rep("darkseagreen2",9),rep("coral3",9)))))
	ht2 <- Heatmap(heat[higher_in_stiff,], cluster_columns=FALSE, cluster_rows = FALSE, show_column_names=FALSE,show_row_names=FALSE, col=col_fun,top_annotation = ht1,heatmap_legend_param = list(col_fun = col_fun),left_annotation=ha)
	ht3 <- Heatmap(heat[which(match(rownames(heat),higher_in_stiff,nomatch=0)==0),],name = "Gene expression", cluster_columns=FALSE, cluster_rows = FALSE, show_row_names=FALSE,show_column_names=FALSE, col=col_fun,show_heatmap_legend=FALSE, heatmap_height=unit(5,"cm"))


##plot
	pdf("Results/diff_exp.pdf")

	plot(results(res)$baseMean[which(results(res)$padj<0.05)],results(res)$log2FoldChange[which(results(res)$padj<0.05)],xlab="Mean expression",ylab="log2FC",main="Singnificative genes (padj < 0.05)")	
	plot(results(res)$baseMean[which(results(res)$padj<0.05)],results(res)$log2FoldChange[which(results(res)$padj<0.05)],xlim=c(0,1000),xlab="Mean expression",ylab="log2FC",main="Singnificative genes (padj < 0.05)")
	abline(v=quantile(results(res)$baseMean,seq(0,1,0.05))[20], col="blue")
	abline(v=quantile(results(res)$baseMean,seq(0,1,0.05))[18], col="yellow")
	abline(v=quantile(results(res)$baseMean,seq(0,1,0.05))[17], col="green")
	abline(v=quantile(results(res)$baseMean,seq(0,1,0.05))[16], col="red")
	legend("top","left",pch=16,col=c("blue","yellow","green","red"),legend=c("90%","85%","80%","75%"))
	 set.seed(9999)
	tsne <- Rtsne(t(red),perplexity=4)
	plot(tsne$Y[,1],tsne$Y[,2], col=pData(GSE179983$log)$stroma,pch=c(rep(16,6),rep(17,6),rep(18,6)),xlab="tsne1", ylab ="tsne2", main="tsne GSE179983")
	legend("bottom",col=c(rep(1,3),rep(2,3)),pch=rep(c(17,18,16),2), legend = c("Tumor 1, soft","Tumor 2, soft","Tumor 3, soft","Tumor 1, stiff","Tumor 2, stiff","Tumor 3, stiff"))
	draw(ht2 %v% ht3, ht_gap=unit(0.6,"cm"))

	dev.off()
