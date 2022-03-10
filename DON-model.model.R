# Molecular weight (in grams/mol)
#MW_don = 296.32;
#Dose   = 0.07/(1000*MW_don); # 1 microgram/kg ----(moles)

#updated gall bladder recirculation
# Default parameter values
# ========================
# Units:
# Volumes: liter
# Time:    minute
# Quantity:   nmol

# Conversions between mg and nMol:
#Dose = Dose/(1000*MW_don);# in number of moles
#InitDose = Dose * 1e+9; # In nmol

# M0 - removed Qm_d3g, Qm_d15g

States  = { 
  Q_GI,       # Quantity of DON in the GI compartment (nmol)
  Q_fec_don,  # Quantity of free DON in feces (nmol)
  Qcpt,       # Quantity in central compartment (nmol)
  Qu_don,     # Quantity of don in urine (nmol)
  Qu_d3g,     # Quantity of d3g in urine (nmol)
  Qu_d15g,    # Quantity of d15g in urine (nmol)
  AUC,         # AUC of central compartment (nmol-hr/L)
};  

Outputs = {
  AUC_convert, AUC_dose, Ccpt, 
  ExRate_don, ExRate_d3g, ExRate_d15g, 
  ExRate_don_out, ExRate_d3g_out, ExRate_d15g_out,
  Qu_don_out, Qu_d3g_out, Qu_d15g_out
};

#population mean
M_lnFgutabs = -0.70; # 50% absorption
M_lnkgutelim = -1.05;
M_lnktot = -1.20;
M_lnkmratio = 0;
M_lnkuDfrac = -1.20;

#population variance
SD_lnFgutabs = 0.2;
SD_lnkgutelim = 0.2;
SD_lnktot = 0.2;
SD_lnkmratio = 0.2;
SD_lnkuDfrac = 0.2;

#individual log transformed, z-score
lnFgutabs = 0;
lnkgutelim = 0;
lnktot = 0;
lnkmratio = 0;
lnkuDfrac = 0;

#individual parameters
# Oral input modeling
InitDose    = 405.405405405405; # ingested input at t=0 (nmol)
ConstDoseRate = 0; # Constant dose rate per hour (nmol/h) 
Fgutabs    = 0.56; #fraction of gut absorption
Fgutabs_tmp = 0.56; #set it to avoid the value larger than 1
kgutabs    = 0.35; # Intestinal absorption rate (/h); kgutelim * Fgutabs/(1-Fgutabs)

# Distribution volumes (L/kg)
Vdist = 1.24;

# Body weight (kg)
BW = 70;

# Elimination rate constants (/h)
ktot      = 0.30;     #total elimination rate constant for DON urine, D3GA and D15GA (nmol/h)
kmratio   = 1.00;     #metabolic rate ratio for D3GA and D15GA 
km_d3g    = 0.105;    #metabolic rate constant for D3GA (nmol/h)
km_d15g   = 0.105;    #metabolic rate constant for D15GA (nmol/h)
kuD       = 0.09;     #Urinary xcretion rate constant for DON (nmol/h)
kuD_tmp   = 0.09; #set it to avoid the value geq ktot

kgutelim   = 0.35;     #gut elimination rate

#GSD
GSD_don    = 1.1;
GSD_d3g    = 1.1;
GSD_d15g   = 1.1;

Initialize {
  Q_GI = InitDose;
  Fgutabs_tmp = exp(M_lnFgutabs + SD_lnFgutabs * lnFgutabs);
  Fgutabs = (Fgutabs_tmp > 1) ? 1 : Fgutabs_tmp;
  kgutelim = exp(M_lnkgutelim + SD_lnkgutelim * lnkgutelim);
  kgutabs = kgutelim * Fgutabs / (1 - Fgutabs);
  ktot = exp(M_lnktot + SD_lnktot * lnktot);
  kuD_tmp = ktot * exp(M_lnkuDfrac + SD_lnkuDfrac * lnkuDfrac);
  kuD = (kuD_tmp > (0.99*ktot)) ? (0.99*ktot) : kuD_tmp;
  kmratio = exp(M_lnkmratio + SD_lnkmratio * lnkmratio);
  km_d3g = (ktot - kuD) * kmratio / (1 + kmratio);
  km_d15g = (ktot - kuD) / (1 + kmratio);
  }

Dynamics { 
  dt (Q_GI)  = ConstDoseRate - Q_GI * (kgutabs + kgutelim);
  dt (Q_fec_don) = Q_GI * kgutelim;
  dt (Qcpt) = Q_GI * kgutabs - Qcpt * (kuD + km_d3g + km_d15g);
  dt (Qu_don) = Qcpt * kuD;
  dt (Qu_d3g) = Qcpt * km_d3g;
  dt (Qu_d15g) = Qcpt * km_d15g;
  dt (AUC) = Qcpt/(Vdist*BW);
}

CalcOutputs { 
  AUC_convert = AUC*296.32*0.001*0.001; #nmol-hr/L to ug-hr/ml
  AUC_dose = AUC * BW /InitDose; #nmol-hr/L to hr-kg/L (dose in nmol/kg)
  Ccpt = Qcpt  / (Vdist*BW);
  ExRate_don = Qcpt * kuD; 
  ExRate_d3g  = Qcpt * km_d3g;
  ExRate_d15g = Qcpt * km_d15g; 
  ExRate_don_out = (ExRate_don < 1e-15 ? 1e-15 : ExRate_don);
  ExRate_d3g_out = (ExRate_d3g < 1e-15 ? 1e-15 : ExRate_d3g);
  ExRate_d15g_out = (ExRate_d15g < 1e-15 ? 1e-15 : ExRate_d15g);
  Qu_don_out = (Qu_don < 1e-15 ? 1e-15 : Qu_don);
  Qu_d3g_out = (Qu_d3g < 1e-15 ? 1e-15 : Qu_d3g);
  Qu_d15g_out = (Qu_d15g < 1e-15 ? 1e-15 : Qu_d15g);
}


End.