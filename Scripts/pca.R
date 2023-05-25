library(Biobase)
load("Dataset/GSE179983.rda")

pca <- prcomp(t(exprs(GSE179983$log)))

###Scree plot

x <- factor(colnames(summary(pca)$importance), levels=colnames(summary(pca)$importance))
pdf("Results/Scree_plot.pdf")
barplot(summary(pca)$importance[2,]*100,names.arg=x, las=2, ylab="Variance proportion (%)", main="Scree plot", col="darkcyan")
dev.off()


###PCA plot
pdf("Results/pca.pdf")
plot(pca$x[,1],pca$x[,2], col=pData(GSE179983$log)$stroma,pch=c(rep(16,6),rep(17,6),rep(18,6)),xlab=paste(c("PC 1",summary(pca)$importance[2,1]*100,"%"),collapse=" "), ylab =paste(c("PC 2",summary(pca)$importance[2,2]*100,"%"),collapse=" "), main="PCA GSE179983")
legend("top",col=c(rep(1,3),rep(2,3)),pch=rep(c(17,18,16),2), legend = c("Tumor 1, soft","Tumor 2, soft","Tumor 3, soft","Tumor 1, stiff","Tumor 2, stiff","Tumor 3, stiff"))
dev.off()
