# DON PK Model
 PK model for DON urinary excretion data
 
The model uses GNU MCSim v6.1.0 under R and R studio. The GNU MCSim code is provided in the MCSim directory. The main script compiles the GNU MCSim code.

The MCMC simulation runs the model with 4 chains. The model parameters are provided in "DON-model.model.R"" file. The simulation settings of population and individual levels are provided in "DON-model-calib.in.R" file. The model.R and in.R files are input to perform the MCMC simulation.

# Model test
The MCMC simulation runs one random sample, random iteration from last row of chain 4 to test the model calibration.

# Model calibration
The model parameters are checked using MCMC posterior parameters after burn-in. Parameters are also diagnosed for cross correlation. The time-course simulation is calibrated using raw biomonitoring data of DON and its metabolites (DON-3-GlcA and DON-15-GlcA). 

input file:
- individual urine quantity_LODdevidedby2.csv

original files in repository:
DON-data

main script:
  DON-PK-model-calib.Rmd

output:
- checksplot_model.calib.pdf (Supplementary Figure S2)
- checksplot_model.calib-last.pdf (Supplementary Figure S2)
- mcmc_model.calib.Rdata
- multicheck_model.calib.Rdata
- DiagnosticPlots_model.calib.pdf (Supplementary Figure S3)
- combine.prediction_model.calib-tot.pdf
- combine.prediction_log_model.calib-tot.pdf
- combine.prediction_all_model.calib.pdf
- combine.prediction_log_all_model.calib.pdf
  
# Prior and posterior parameters comparison
Prior and posterior parameter distributions are compared based on population and individual levels.

input data:
- individual urine quantity_LODdevidedby2.csv

original files in repository:
DON-data

input file:
- multicheck_model.calib.Rdata

script:
  Figure-Table-PriorsPosteriors.R

output:
- Figure-Prior-Posterior.pdf (Supplementary Figure S4)
- Table-Priors.csv
- Table-Posteriors.csv
- Figure-Indiv-Posterior.pdf (Supplementary Figure S4)
  
# Posterior model prediction
Posterior prediction for urinary excretion is visualized for each individual. The visualization plot is used to modify model calibration.

input data:
- individual urine quantity_LODdevidedby2.csv

original files in repository:
DON-data

input file:
- multicheck_model.calib.Rdata

script:
  Figure-Calibration.R
  
output:
- Figure-Calibration.pdf (manuscript Figure 3)

## Human AUC calculation
Human AUC value is derived from posterior prediction of population levels. The AUC distribution is used to calculate interspecies toxicokinetic (TK) extrapolation and intraspecies TK distribution.The geometric standard deviation (GSD) of AUC is used to derive toxicokinetic variability factor (TKVF). The AUC is also calculated based on per unit total urinary excretion.

input file:
- multicheck_model.calib.Rdata
  
script:
  AUC_calculation.R

output:
- Figure-AUC_dose-Posterior.pdf
- AUC_dose_samples.csv
- Figure-DON-AUC_dose.GSD_compare_prior.pdf
- Figure-DON-AUC_dose.TKVF05_compare_prior.pdf
- Figure-DON-AUC_dose.TKVF01_compare_prior.pdf
- TKVF_figure.pdf (Supplementary Figure S5)
- Table-AUC_dose_posteriors.csv
- Figure-AUC_Utot-Posterior.pdf
- AUC_Utot_samples.csv
- Figure-DON-AUC_Utot.GSD_compare_prior.pdf
- Figure-DON-AUC_Utot.TKVF05_compare_prior.pdf
- Figure-DON-AUC_Utot.TKVF01_compare_prior.pdf
- Table-AUC_Utot_posteriors.csv