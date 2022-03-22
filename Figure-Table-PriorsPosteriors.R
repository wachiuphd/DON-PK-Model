library(coda)
library(bayesplot) 
library(ggplot2)
library(tidyverse)
library(GGally)
library(ggpubr)
library(psych)
library(truncnorm)

load("multicheck_model.calib.Rdata")
parms.samp <- multicheck$parms.samp
posteriors.samp <- parms.samp[,2:11]

plist <- list()
for (j in 1:10) { #
  jcol <- c(1,6,2,7,3,8,4,9,5,10)[j]
  postdf <- data.frame(x=posteriors.samp[,jcol])
  lab <- names(posteriors.samp)[jcol]
  lab <- gsub(".1.","",lab)
  if (jcol == 1) {
    xx <- c(seq(-4.62,0.0,0.01),1e-6)
    yy <- dunif(xx,min=-4.61,max=0)
  } else if (jcol == 2) {
    xx <- -1.05 + 1.15*seq(-3,3,0.01)
    yy <- dnorm(xx,m=-1.05,sd=1.15)
  } else if (jcol == 3) {
    xx <- -1.20 + 1.15*seq(-3,3,0.01)
    yy <- dnorm(xx,m=-1.20,sd=1.15)
  } else if (jcol == 4) {
    xx <- 0 + 2.3*seq(-3,3,0.01)
    yy <- dnorm(xx,m=0,sd=2.3)
  } else if (jcol == 5) {
    xx <- c(seq(-4.61,-0.01,0.01),-0.01+1e-6)
    yy <- dtruncnorm(xx,a=-4.61,b=-0.01,m=-1.20,sd=1.15)
  } else {
    xx <- c(-1e-6,0.7*seq(0,3,0.01))
    yy <- dtruncnorm(xx,a=0,b=Inf,m=0,sd=0.7)
  }
  priordf <- data.frame(x=xx,y=yy)
  plist[[j]] <- ggplot()+
    geom_histogram(aes(x=x,y=..density..,fill="Posterior"),
                   data=postdf)+
    geom_line(aes(x=x,y=y,linetype="Prior"),data=priordf)+
    theme_bw()+
    scale_fill_manual("",values="grey50")+
    scale_linetype_manual("",values = c("solid"))+
    guides(linetype = guide_legend(order = 1),
           fill = guide_legend(order = 2))+
    labs(subtitle=lab)+
    xlab("")+ylab("")+theme(axis.text.y=element_blank())
}
pall <- ggarrange(plotlist=plist,nrow=5,ncol=2,
                  common.legend = TRUE,
                  legend = "bottom")
print(pall)
ggsave("Figure-Prior-Posterior.pdf",pall,height=6,width=4,scale=1.2)
## Tabulated
probs <- c(0.025,0.5,0.975)
posteriors <- apply(posteriors.samp,2,quantile,prob=probs)
priors <- posteriors
priors[,1] <- qunif(probs,min=-4.61,max=0)  
priors[,2] <- qnorm(probs,m=-1.05,sd=1.15)
priors[,3] <- qnorm(probs,m=-1.20,sd=1.15)
priors[,4] <- qnorm(probs,m=0,sd=2.30)
priors[,5] <- qtruncnorm(probs,a=-4.61,b=-0.01,m=-1.20,sd=1.15)

priors[,6] <- qtruncnorm(probs,a=0,b=Inf,m=0,sd=0.7)
priors[,7] <- qtruncnorm(probs,a=0,b=Inf,m=0,sd=0.7)
priors[,8] <- qtruncnorm(probs,a=0,b=Inf,m=0,sd=0.7)
priors[,9] <- qtruncnorm(probs,a=0,b=Inf,m=0,sd=0.7)
priors[,10] <- qtruncnorm(probs,a=0,b=Inf,m=0,sd=0.7)

colnames(priors)<-gsub("ln","",colnames(priors))
colnames(priors)<-gsub(".1.","",colnames(priors))
colnames(priors)<-paste0("G",colnames(priors))
colnames(posteriors)<-gsub("ln","",colnames(posteriors))
colnames(posteriors)<-gsub(".1.","",colnames(posteriors))
colnames(posteriors)<-paste0("G",colnames(posteriors))
write.csv(exp(t(priors)),file="Table-Priors.csv")
write.csv(exp(t(posteriors)),file="Table-Posteriors.csv")

