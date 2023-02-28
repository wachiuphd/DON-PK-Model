library("ggpubr")
TKVF <- ggarrange(TKVF05, TKVF01, 
                 labels = c("A", "B"),
                 ncol = 2, nrow = 1)
ggsave("TKVF_figure.pdf", plot=TKVF, scale=0.5, width=20, height=8)
