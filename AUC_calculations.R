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

M_lnAUC_dose <- posteriors.samp$M_lnFgutabs.1. - 
  posteriors.samp$M_lnktot.1. - 
  log(1.24) # Vd fixed
SD_lnAUC_dose <- sqrt(posteriors.samp$SD_lnFgutabs.1.^2 + 
                        posteriors.samp$SD_lnktot.1.^2) # Independent

AUC.df <- data.frame(M_lnAUC_dose=M_lnAUC_dose,SD_lnAUC_dose=SD_lnAUC_dose,
                     GM_AUC_dose=exp(M_lnAUC_dose),GSD_AUC_dose=exp(SD_lnAUC_dose))
write.csv(AUC.df,file="AUC_samples.csv")

pgm<-ggplot(AUC.df)+geom_histogram(aes(x=GM_AUC_dose,y=..density..))+
  scale_x_log10(limits=c(0.1,5))+annotation_logticks(side="b")+theme_bw()+
  ylab("")+xlab("")+ggtitle("Population GM AUC/Dose")

psd<-ggplot(AUC.df)+geom_histogram(aes(x=GSD_AUC_dose,y=..density..))+
  scale_x_log10(limits=c(1,NA))+annotation_logticks(side="b")+theme_bw()+
  ylab("")+xlab("")+ggtitle("Population GSD AUC/Dose")

pauc<-ggarrange(pgm,psd,ncol=1,nrow=2)
print(pauc)
ggsave("Figure-AUC-Posterior.pdf",pauc,height=6,width=4)

## Tabulated
probs <- c(0.025,0.5,0.975)
AUCquants <- apply(AUC.df,2,quantile,prob=probs)
write.csv(t(AUCquants),file="Table-AUC_posteriors.csv")

