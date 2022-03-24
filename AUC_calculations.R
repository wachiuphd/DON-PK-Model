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

pgm<-ggplot(AUC.df)+geom_histogram(aes(x=GM_AUC_dose,y=..density..))+
  scale_x_log10(limits=c(0.1,5))+annotation_logticks(side="b")+theme_bw()+
  ylab("")+xlab("")+ggtitle("Population GM AUC/Dose")

psd<-ggplot(AUC.df)+geom_histogram(aes(x=GSD_AUC_dose,y=..density..))+
  scale_x_log10(limits=c(1,NA))+annotation_logticks(side="b")+theme_bw()+
  ylab("")+xlab("")+ggtitle("Population GSD AUC/Dose")

pauc<-ggarrange(pgm,psd,ncol=1,nrow=2)
print(pauc)
ggsave("Figure-AUC-Posterior.pdf",pauc,height=6,width=4)

AUC.df$TKVF05 <- AUC.df$GSD_AUC_dose^qnorm(0.95)
AUC.df$TKVF01 <- AUC.df$GSD_AUC_dose^qnorm(0.99)

write.csv(AUC.df,file="AUC_samples.csv")

prior.dens <- data.frame(xlog10=seq(0,1.5,0.01))
prior.dens$density.gsd <- dlnorm(prior.dens$xlog10,meanlog=log(0.167),sdlog=log(1.72))
prior.dens$x.gsd <- 10^prior.dens$xlog10

ggplot(AUC.df)+geom_histogram(aes(x=GSD_AUC_dose,y=..density..))+
  geom_line(aes(x.gsd,density.gsd),data=prior.dens)+
  geom_vline(xintercept=10^(0.5/qnorm(0.99)),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,10))+annotation_logticks(side="b")+theme_bw()
ggsave("Figure-DON-AUC_dose.GSD_compare_prior.pdf",height=3,width=5)

prior.dens$x.tkvf05 <- prior.dens$x.gsd^qnorm(0.95)
prior.dens$density.tkvf05 <- prior.dens$density.gsd/qnorm(0.95)
ggplot(AUC.df)+geom_histogram(aes(x=TKVF05,y=..density..))+
  geom_line(aes(x.tkvf05,density.tkvf05),data=prior.dens)+
  geom_vline(xintercept=10^(0.5),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,50))+annotation_logticks(side="b")+theme_bw()
ggsave("Figure-DON-AUC_dose.TDVF05_compare_prior.pdf",height=3,width=5)

prior.dens$x.tkvf01 <- prior.dens$x.gsd^qnorm(0.99)
prior.dens$density.tkvf01 <- prior.dens$density.gsd/qnorm(0.99)
ggplot(AUC.df)+geom_histogram(aes(x=TKVF01,y=..density..))+
  geom_line(aes(x.tkvf01,density.tkvf01),data=prior.dens)+
  geom_vline(xintercept=10^(0.5),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,50))+annotation_logticks(side="b")+theme_bw()
ggsave("Figure-DON-AUC_dose.TDVF01_compare_prior.pdf",height=3,width=5)  

## Tabulated
probs <- c(0.025,0.5,0.975)
AUCquants <- apply(AUC.df,2,quantile,prob=probs)
write.csv(t(AUCquants),file="Table-AUC_posteriors.csv")

