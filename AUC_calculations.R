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

##########################################################
## AUC per unit dose calculation
# AUC = Dose * Fgutabs /(Vd * ktot)
# AUC/Dose = Fgutabs / (Vd * ktot)

M_lnAUC_dose <- posteriors.samp$M_lnFgutabs.1. - 
  posteriors.samp$M_lnktot.1. - 
  log(1.24) # Vd fixed
SD_lnAUC_dose <- sqrt(posteriors.samp$SD_lnFgutabs.1.^2 + 
                        posteriors.samp$SD_lnktot.1.^2) # Independent

AUC_dose.df <- data.frame(M_lnAUC_dose=M_lnAUC_dose,SD_lnAUC_dose=SD_lnAUC_dose,
                     GM_AUC_dose=exp(M_lnAUC_dose),GSD_AUC_dose=exp(SD_lnAUC_dose))

pgm<-ggplot(AUC_dose.df)+geom_histogram(aes(x=GM_AUC_dose,y=..density..))+
  scale_x_log10(limits=c(0.1,5))+annotation_logticks(side="b")+theme_bw()+
  ylab("")+xlab("")+ggtitle("Population GM AUC/Dose")

psd<-ggplot(AUC_dose.df)+geom_histogram(aes(x=GSD_AUC_dose,y=..density..))+
  scale_x_log10(limits=c(1,NA))+annotation_logticks(side="b")+theme_bw()+
  ylab("")+xlab("")+ggtitle("Population GSD AUC/Dose")

pAUC_dose<-ggarrange(pgm,psd,ncol=1,nrow=2)
print(pAUC_dose)
ggsave("Figure-AUC_dose-Posterior.pdf",pAUC_dose,height=6,width=4)

AUC_dose.df$TKVF05 <- AUC_dose.df$GSD_AUC_dose^qnorm(0.95)
AUC_dose.df$TKVF01 <- AUC_dose.df$GSD_AUC_dose^qnorm(0.99)

write.csv(AUC_dose.df,file="AUC_dose_samples.csv")

prior.dens <- data.frame(xlog10=seq(0,1.5,0.01))
prior.dens$density.gsd <- dlnorm(prior.dens$xlog10,meanlog=log(0.167),sdlog=log(1.72))
prior.dens$x.gsd <- 10^prior.dens$xlog10

ggplot(AUC_dose.df)+geom_histogram(aes(x=GSD_AUC_dose,y=..density..))+
  geom_line(aes(x.gsd,density.gsd),data=prior.dens)+
  geom_vline(xintercept=10^(0.5/qnorm(0.99)),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,10))+annotation_logticks(side="b")+theme_bw()
ggsave("Figure-DON-AUC_dose.GSD_compare_prior.pdf",height=3,width=5)

prior.dens$x.tkvf05 <- prior.dens$x.gsd^qnorm(0.95)
prior.dens$density.tkvf05 <- prior.dens$density.gsd/qnorm(0.95)
TKVF05 <- ggplot(AUC_dose.df)+geom_histogram(aes(x=TKVF05,y=..density..))+
  geom_line(aes(x.tkvf05,density.tkvf05),data=prior.dens)+
  geom_vline(xintercept=10^(0.5),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,50))+annotation_logticks(side="b")+theme_bw()+
  xlab(bquote(TKVF["05"]))
print(TKVF05)
ggsave(plot=TKVF05, "Figure-DON-AUC_dose.TKVF05_compare_prior.pdf",height=3,width=5)

prior.dens$x.tkvf01 <- prior.dens$x.gsd^qnorm(0.99)
prior.dens$density.tkvf01 <- prior.dens$density.gsd/qnorm(0.99)
TKVF01 <- ggplot(AUC_dose.df)+geom_histogram(aes(x=TKVF01,y=..density..))+
  geom_line(aes(x.tkvf01,density.tkvf01),data=prior.dens)+
  geom_vline(xintercept=10^(0.5),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,50))+annotation_logticks(side="b")+theme_bw()+
  xlab(bquote(TKVF["01"]))
print(TKVF01)
ggsave(plot=TKVF01, "Figure-DON-AUC_dose.TKVF01_compare_prior.pdf",height=3,width=5)  

TKVF <- ggarrange(TKVF05, TKVF01, labels = c("A", "B"), ncol = 2, nrow = 1)
ggsave("TKVF_figure.pdf", plot=TKVF, scale=0.5, width=20, height=8)


## Tabulated
probs <- c(0.025,0.5,0.975)
AUC_dosequants <- apply(AUC_dose.df,2,quantile,prob=probs)
write.csv(t(AUC_dosequants),file="Table-AUC_dose_posteriors.csv")

##########################################################
## AUC per unit total urinary excretion calculation
# Utot = Dose * Fgutabs 
# AUC = Utot /(Vd * ktot)
# AUC_Utot = 1/(Vd * ktot)

M_lnAUC_Utot <- - posteriors.samp$M_lnktot.1. - log(1.24) # Vd fixed
SD_lnAUC_Utot <- posteriors.samp$SD_lnktot.1.

AUC_Utot.df <- data.frame(M_lnAUC_Utot=M_lnAUC_Utot,SD_lnAUC_Utot=SD_lnAUC_Utot,
                          GM_AUC_Utot=exp(M_lnAUC_Utot),GSD_AUC_Utot=exp(SD_lnAUC_Utot))

pgm<-ggplot(AUC_Utot.df)+geom_histogram(aes(x=GM_AUC_Utot,y=..density..))+
  scale_x_log10(limits=c(0.1,5))+annotation_logticks(side="b")+theme_bw()+
  ylab("")+xlab("")+ggtitle("Population GM AUC/Utot")

psd<-ggplot(AUC_Utot.df)+geom_histogram(aes(x=GSD_AUC_Utot,y=..density..))+
  scale_x_log10(limits=c(1,NA))+annotation_logticks(side="b")+theme_bw()+
  ylab("")+xlab("")+ggtitle("Population GSD AUC/Utot")

pAUC_Utot<-ggarrange(pgm,psd,ncol=1,nrow=2)
print(pAUC_Utot)
ggsave("Figure-AUC_Utot-Posterior.pdf",pAUC_Utot,height=6,width=4)

AUC_Utot.df$TKVF05 <- AUC_Utot.df$GSD_AUC_Utot^qnorm(0.95)
AUC_Utot.df$TKVF01 <- AUC_Utot.df$GSD_AUC_Utot^qnorm(0.99)

write.csv(AUC_Utot.df,file="AUC_Utot_samples.csv")

prior.dens <- data.frame(xlog10=seq(0,1.5,0.01))
prior.dens$density.gsd <- dlnorm(prior.dens$xlog10,meanlog=log(0.167),sdlog=log(1.72))
prior.dens$x.gsd <- 10^prior.dens$xlog10

ggplot(AUC_Utot.df)+geom_histogram(aes(x=GSD_AUC_Utot,y=..density..))+
  geom_line(aes(x.gsd,density.gsd),data=prior.dens)+
  geom_vline(xintercept=10^(0.5/qnorm(0.99)),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,10))+annotation_logticks(side="b")+theme_bw()
ggsave("Figure-DON-AUC_Utot.GSD_compare_prior.pdf",height=3,width=5)

prior.dens$x.tkvf05 <- prior.dens$x.gsd^qnorm(0.95)
prior.dens$density.tkvf05 <- prior.dens$density.gsd/qnorm(0.95)
ggplot(AUC_Utot.df)+geom_histogram(aes(x=TKVF05,y=..density..))+
  geom_line(aes(x.tkvf05,density.tkvf05),data=prior.dens)+
  geom_vline(xintercept=10^(0.5),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,50))+annotation_logticks(side="b")+theme_bw()
ggsave("Figure-DON-AUC_Utot.TKVF05_compare_prior.pdf",height=3,width=5)

prior.dens$x.tkvf01 <- prior.dens$x.gsd^qnorm(0.99)
prior.dens$density.tkvf01 <- prior.dens$density.gsd/qnorm(0.99)
ggplot(AUC_Utot.df)+geom_histogram(aes(x=TKVF01,y=..density..))+
  geom_line(aes(x.tkvf01,density.tkvf01),data=prior.dens)+
  geom_vline(xintercept=10^(0.5),color="red",linetype="dotted")+
  scale_x_log10(limits=c(1,50))+annotation_logticks(side="b")+theme_bw()
ggsave("Figure-DON-AUC_Utot.TKVF01_compare_prior.pdf",height=3,width=5)  

## Tabulated
probs <- c(0.025,0.5,0.975)
AUC_Utotquants <- apply(AUC_Utot.df,2,quantile,prob=probs)
write.csv(t(AUC_Utotquants),file="Table-AUC_Utot_posteriors.csv")
