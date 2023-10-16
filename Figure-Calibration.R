library(coda)
library(bayesplot) 
library(ggplot2)
library(tidyverse)
library(GGally)
library(ggpubr)
library(psych)
ID.calib <- read_csv(file.path("DON-data",
                               "individual urine quantity_LODdevidedby2.csv"), T,"")

load("multicheck_model.calib.Rdata")
df_check <- multicheck$df_check
df_check$ID <- levels(factor(ID.calib$ID))[df_check$Simulation]

#DON
calib025_don <-aggregate(Prediction ~ ID + Time,
                        data=subset(df_check,Output_Var=="Qu_don"),
                        FUN=quantile,prob=0.025)
calib50_don <-aggregate(Prediction ~ ID + Time,
                        data=subset(df_check,Output_Var=="Qu_don"),
                        FUN=quantile,prob=0.5)
calib975_don <-aggregate(Prediction ~ ID + Time,
                        data=subset(df_check,Output_Var=="Qu_don"),
                        FUN=quantile,prob=0.975)

#d3g
calib025_d3g <-aggregate(Prediction ~ ID + Time,
                        data=subset(df_check,Output_Var=="Qu_d3g"),
                        FUN=quantile,prob=0.025)
calib50_d3g <-aggregate(Prediction ~ ID + Time,
                        data=subset(df_check,Output_Var=="Qu_d3g"),
                        FUN=quantile,prob=0.5)
calib975_d3g <-aggregate(Prediction ~ ID + Time,
                        data=subset(df_check,Output_Var=="Qu_d3g"),
                        FUN=quantile,prob=0.975)

#d15g
calib025_d15g <-aggregate(Prediction ~ ID + Time,
                         data=subset(df_check,Output_Var=="Qu_d15g"),
                         FUN=quantile,prob=0.025)
calib50_d15g <-aggregate(Prediction ~ ID + Time,
                         data=subset(df_check,Output_Var=="Qu_d15g"),
                         FUN=quantile,prob=0.5)
calib975_d15g <-aggregate(Prediction ~ ID + Time,
                         data=subset(df_check,Output_Var=="Qu_d15g"),
                         FUN=quantile,prob=0.975)

prediction_calib_don <- ggplot() + 
  geom_point(aes(x=`Time (hr)`,y=`DON (nmol)`,shape=" "), data=ID.calib)+
  geom_line(aes(x=Time,y=Prediction,linetype=" Median"),color="grey50",data=calib50_don)+
  geom_line(aes(x=Time,y=Prediction,linetype="95% CI"),color="grey50",data=calib025_don)+
  geom_line(aes(x=Time,y=Prediction,linetype="95% CI"),color="grey50",data=calib975_don)+
  ggtitle("DON")+theme_bw()+
  ylab("DON in urine (nmol)")+
  theme(panel.grid.minor = element_blank())+
  theme(panel.grid.major = element_blank())+
  scale_linetype_manual("Prediction",values=c("solid","dashed"))+
  scale_shape_manual("Data (Vidal et al. 2018)",values=16)+
  guides(shape = guide_legend(order = 1),
         linetype = guide_legend(order = 2))+
  facet_wrap(~ID)
print(prediction_calib_don)

prediction_calib_d3g <- ggplot() + 
  geom_point(aes(x=`Time (hr)`,y=`DON-3-GlcA (nmol)`,shape=" "), data=ID.calib)+
  geom_line(aes(x=Time,y=Prediction,linetype=" Median"),color="grey50",data=calib50_d3g)+
  geom_line(aes(x=Time,y=Prediction,linetype="95% CI"),color="grey50",data=calib025_d3g)+
  geom_line(aes(x=Time,y=Prediction,linetype="95% CI"),color="grey50",data=calib975_d3g)+
  ggtitle("DON-3-glucuronide")+theme_bw()+
  ylab("DON-3-glucuronide in urine (nmol)")+
  theme(panel.grid.minor = element_blank())+
  theme(panel.grid.major = element_blank())+
  scale_linetype_manual("Prediction",values=c("solid","dashed"))+
  scale_shape_manual("Data (Vidal et al. 2018)",values=16)+
  guides(shape = guide_legend(order = 1),
         linetype = guide_legend(order = 2))+
  facet_wrap(~ID)
print(prediction_calib_d3g)

prediction_calib_d15g <- ggplot() + 
  geom_point(aes(x=`Time (hr)`,y=`DON-15-GlcA (nmol)`,shape=" "), data=ID.calib)+
  geom_line(aes(x=Time,y=Prediction,linetype=" Median"),color="grey50",data=calib50_d15g)+
  geom_line(aes(x=Time,y=Prediction,linetype="95% CI"),color="grey50",data=calib025_d15g)+
  geom_line(aes(x=Time,y=Prediction,linetype="95% CI"),color="grey50",data=calib975_d15g)+
  ggtitle("DON-15-glucuronide")+theme_bw()+
  ylab("DON-15-glucuronide in urine (nmol)")+
  theme(panel.grid.minor = element_blank())+
  theme(panel.grid.major = element_blank())+
  scale_linetype_manual("Prediction",values=c("solid","dashed"))+
  scale_shape_manual("Data (Vidal et al. 2018)",values=16)+
  guides(shape = guide_legend(order = 1),
         linetype = guide_legend(order = 2))+
  facet_wrap(~ID)
print(prediction_calib_d15g)

combine.prediction_calib <- ggarrange(prediction_calib_don, 
                                      prediction_calib_d3g, 
                                      prediction_calib_d15g,
                                      ncol = 1, nrow = 3,labels=c("A","B","C"),
                                      common.legend = TRUE, legend="bottom",
                                      font.label = list(size = 18))
print(combine.prediction_calib)
ggsave(file.path("Figure-Calibration.pdf"), plot = combine.prediction_calib, 
       width=5, height=10,scale=1.2)
