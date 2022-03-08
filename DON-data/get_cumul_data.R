library(data.table)
cumdat <- fread("individual urine_cumulative quantity_LODdevidedby2.csv")
ids <- unique(cumdat$ID)
fname <- "cumul.in"
cat("## Cumulative urine\n",file=fname)
for (idnow in ids) {
  cumdat_i <- subset(cumdat,ID == idnow & `Time (hr)` >0)
  cat("# ",idnow,"\n",file=fname,append=TRUE)
  cat("Print(Qu_don_out, Qu_d3g_out, Qu_d15g_out",cumdat_i$`Time (hr)`,sep=", ",file=fname,append=TRUE)
  cat(");\n",file=fname,append=TRUE)
  cat("Data(Qu_don_out",cumdat_i$`DON (nmol)`,sep=", ",file=fname,append=TRUE)
  cat(");\n",file=fname,append=TRUE)
  cat("Data(Qu_d3g_out",cumdat_i$`DON-3-GlcA (nmol)`,sep=", ",file=fname,append=TRUE)
  cat(");\n",file=fname,append=TRUE)
  cat("Data(Qu_d15g_out",cumdat_i$`DON-15-GlcA (nmol)`,sep=", ",file=fname,append=TRUE)
  cat(");\n",file=fname,append=TRUE)
  cat("PrintStep(Qu_don, 0, 25, 0.1);\n",file=fname,append=TRUE);
  cat("PrintStep(Qu_d3g, 0, 25, 0.1);\n",file=fname,append=TRUE);
  cat("PrintStep(Qu_d15g, 0, 25, 0.1);\n",file=fname,append=TRUE);
  cat("\n",file=fname,append=TRUE)
}
