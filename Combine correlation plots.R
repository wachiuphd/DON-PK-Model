library("ggpubr")
cor.plot <- ggarrange(checksplotlast, checksplot, nrow=2, ncol=1, heights=c(1,2),
                      labels = c("A", "B"))
ggsave(plot=cor.plot, file="Combine checksplots.pdf", path="Calibration Plots",
       width=8, height=10)