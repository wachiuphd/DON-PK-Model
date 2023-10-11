/* DON-model.model.r.c
   ___________________________________________________

   Model File:  DON-model.model.r

   Date:  Fri Oct 06 23:44:59 2023

   Created by:  "C:/Users/Shren/DOCUME~1/GitHub/DON-PK~1/MCSim/mod.exe v6.1.0"
    -- a model preprocessor by Don Maszle
   ___________________________________________________

   Copyright (c) 1993-2019 Free Software Foundation, Inc.

   Model calculations for compartmental model:

   7 States:
     Q_GI -> 0.0;
     Q_fec_don -> 0.0;
     Qcpt -> 0.0;
     Qu_don -> 0.0;
     Qu_d3g -> 0.0;
     Qu_d15g -> 0.0;
     AUC -> 0.0;

   12 Outputs:
     AUC_convert -> 0.0;
     AUC_dose -> 0.0;
     Ccpt -> 0.0;
     ExRate_don -> 0.0;
     ExRate_d3g -> 0.0;
     ExRate_d15g -> 0.0;
     ExRate_don_out -> 0.0;
     ExRate_d3g_out -> 0.0;
     ExRate_d15g_out -> 0.0;
     Qu_don_out -> 0.0;
     Qu_d3g_out -> 0.0;
     Qu_d15g_out -> 0.0;

   0 Inputs:

   32 Parameters:
     M_lnFgutabs = -0.70;
     M_lnkgutelim = -1.05;
     M_lnktot = -1.20;
     M_lnkmratio = 0;
     M_lnkuDfrac = -1.20;
     SD_lnFgutabs = 0.2;
     SD_lnkgutelim = 0.2;
     SD_lnktot = 0.2;
     SD_lnkmratio = 0.2;
     SD_lnkuDfrac = 0.2;
     lnFgutabs = 0;
     lnkgutelim = 0;
     lnktot = 0;
     lnkmratio = 0;
     lnkuDfrac = 0;
     InitDose = 405.405405405405;
     ConstDoseRate = 0;
     Fgutabs = 0.56;
     Fgutabs_tmp = 0.56;
     kgutabs = 0.35;
     Vdist = 1.24;
     BW = 70;
     ktot = 0.30;
     kmratio = 1.00;
     km_d3g = 0.105;
     km_d15g = 0.105;
     kuD = 0.09;
     kuD_tmp = 0.09;
     kgutelim = 0.35;
     GSD_don = 1.1;
     GSD_d3g = 1.1;
     GSD_d15g = 1.1;
*/


#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <float.h>
#include "modelu.h"
#include "random.h"
#include "yourcode.h"


/*----- Indices to Global Variables */

/* Model variables: States and other outputs */
#define ID_Q_GI 0x00000
#define ID_Q_fec_don 0x00001
#define ID_Qcpt 0x00002
#define ID_Qu_don 0x00003
#define ID_Qu_d3g 0x00004
#define ID_Qu_d15g 0x00005
#define ID_AUC 0x00006
#define ID_AUC_convert 0x00007
#define ID_AUC_dose 0x00008
#define ID_Ccpt 0x00009
#define ID_ExRate_don 0x0000a
#define ID_ExRate_d3g 0x0000b
#define ID_ExRate_d15g 0x0000c
#define ID_ExRate_don_out 0x0000d
#define ID_ExRate_d3g_out 0x0000e
#define ID_ExRate_d15g_out 0x0000f
#define ID_Qu_don_out 0x00010
#define ID_Qu_d3g_out 0x00011
#define ID_Qu_d15g_out 0x00012

/* Inputs */

/* Parameters */
#define ID_M_lnFgutabs 0x00013
#define ID_M_lnkgutelim 0x00014
#define ID_M_lnktot 0x00015
#define ID_M_lnkmratio 0x00016
#define ID_M_lnkuDfrac 0x00017
#define ID_SD_lnFgutabs 0x00018
#define ID_SD_lnkgutelim 0x00019
#define ID_SD_lnktot 0x0001a
#define ID_SD_lnkmratio 0x0001b
#define ID_SD_lnkuDfrac 0x0001c
#define ID_lnFgutabs 0x0001d
#define ID_lnkgutelim 0x0001e
#define ID_lnktot 0x0001f
#define ID_lnkmratio 0x00020
#define ID_lnkuDfrac 0x00021
#define ID_InitDose 0x00022
#define ID_ConstDoseRate 0x00023
#define ID_Fgutabs 0x00024
#define ID_Fgutabs_tmp 0x00025
#define ID_kgutabs 0x00026
#define ID_Vdist 0x00027
#define ID_BW 0x00028
#define ID_ktot 0x00029
#define ID_kmratio 0x0002a
#define ID_km_d3g 0x0002b
#define ID_km_d15g 0x0002c
#define ID_kuD 0x0002d
#define ID_kuD_tmp 0x0002e
#define ID_kgutelim 0x0002f
#define ID_GSD_don 0x00030
#define ID_GSD_d3g 0x00031
#define ID_GSD_d15g 0x00032


/*----- Global Variables */

/* For export. Keep track of who we are. */
char szModelDescFilename[] = "DON-model.model.r";
char szModelSourceFilename[] = __FILE__;
char szModelGenAndVersion[] = "C:/Users/Shren/DOCUME~1/GitHub/DON-PK~1/MCSim/mod.exe v6.1.0";

/* Externs */
extern BOOL vbModelReinitd;

/* Model Dimensions */
int vnStates = 7;
int vnOutputs = 12;
int vnModelVars = 19;
int vnInputs = 0;
int vnParms = 32;

/* States and Outputs*/
double vrgModelVars[19];

/* Inputs */
IFN vrgInputs[1];

/* Parameters */
double M_lnFgutabs;
double M_lnkgutelim;
double M_lnktot;
double M_lnkmratio;
double M_lnkuDfrac;
double SD_lnFgutabs;
double SD_lnkgutelim;
double SD_lnktot;
double SD_lnkmratio;
double SD_lnkuDfrac;
double lnFgutabs;
double lnkgutelim;
double lnktot;
double lnkmratio;
double lnkuDfrac;
double InitDose;
double ConstDoseRate;
double Fgutabs;
double Fgutabs_tmp;
double kgutabs;
double Vdist;
double BW;
double ktot;
double kmratio;
double km_d3g;
double km_d15g;
double kuD;
double kuD_tmp;
double kgutelim;
double GSD_don;
double GSD_d3g;
double GSD_d15g;

BOOL bDelays = 0;


/*----- Global Variable Map */

VMMAPSTRCT vrgvmGlo[] = {
  {"Q_GI", (PVOID) &vrgModelVars[ID_Q_GI], ID_STATE | ID_Q_GI},
  {"Q_fec_don", (PVOID) &vrgModelVars[ID_Q_fec_don], ID_STATE | ID_Q_fec_don},
  {"Qcpt", (PVOID) &vrgModelVars[ID_Qcpt], ID_STATE | ID_Qcpt},
  {"Qu_don", (PVOID) &vrgModelVars[ID_Qu_don], ID_STATE | ID_Qu_don},
  {"Qu_d3g", (PVOID) &vrgModelVars[ID_Qu_d3g], ID_STATE | ID_Qu_d3g},
  {"Qu_d15g", (PVOID) &vrgModelVars[ID_Qu_d15g], ID_STATE | ID_Qu_d15g},
  {"AUC", (PVOID) &vrgModelVars[ID_AUC], ID_STATE | ID_AUC},
  {"AUC_convert", (PVOID) &vrgModelVars[ID_AUC_convert], ID_OUTPUT | ID_AUC_convert},
  {"AUC_dose", (PVOID) &vrgModelVars[ID_AUC_dose], ID_OUTPUT | ID_AUC_dose},
  {"Ccpt", (PVOID) &vrgModelVars[ID_Ccpt], ID_OUTPUT | ID_Ccpt},
  {"ExRate_don", (PVOID) &vrgModelVars[ID_ExRate_don], ID_OUTPUT | ID_ExRate_don},
  {"ExRate_d3g", (PVOID) &vrgModelVars[ID_ExRate_d3g], ID_OUTPUT | ID_ExRate_d3g},
  {"ExRate_d15g", (PVOID) &vrgModelVars[ID_ExRate_d15g], ID_OUTPUT | ID_ExRate_d15g},
  {"ExRate_don_out", (PVOID) &vrgModelVars[ID_ExRate_don_out], ID_OUTPUT | ID_ExRate_don_out},
  {"ExRate_d3g_out", (PVOID) &vrgModelVars[ID_ExRate_d3g_out], ID_OUTPUT | ID_ExRate_d3g_out},
  {"ExRate_d15g_out", (PVOID) &vrgModelVars[ID_ExRate_d15g_out], ID_OUTPUT | ID_ExRate_d15g_out},
  {"Qu_don_out", (PVOID) &vrgModelVars[ID_Qu_don_out], ID_OUTPUT | ID_Qu_don_out},
  {"Qu_d3g_out", (PVOID) &vrgModelVars[ID_Qu_d3g_out], ID_OUTPUT | ID_Qu_d3g_out},
  {"Qu_d15g_out", (PVOID) &vrgModelVars[ID_Qu_d15g_out], ID_OUTPUT | ID_Qu_d15g_out},
  {"M_lnFgutabs", (PVOID) &M_lnFgutabs, ID_PARM | ID_M_lnFgutabs},
  {"M_lnkgutelim", (PVOID) &M_lnkgutelim, ID_PARM | ID_M_lnkgutelim},
  {"M_lnktot", (PVOID) &M_lnktot, ID_PARM | ID_M_lnktot},
  {"M_lnkmratio", (PVOID) &M_lnkmratio, ID_PARM | ID_M_lnkmratio},
  {"M_lnkuDfrac", (PVOID) &M_lnkuDfrac, ID_PARM | ID_M_lnkuDfrac},
  {"SD_lnFgutabs", (PVOID) &SD_lnFgutabs, ID_PARM | ID_SD_lnFgutabs},
  {"SD_lnkgutelim", (PVOID) &SD_lnkgutelim, ID_PARM | ID_SD_lnkgutelim},
  {"SD_lnktot", (PVOID) &SD_lnktot, ID_PARM | ID_SD_lnktot},
  {"SD_lnkmratio", (PVOID) &SD_lnkmratio, ID_PARM | ID_SD_lnkmratio},
  {"SD_lnkuDfrac", (PVOID) &SD_lnkuDfrac, ID_PARM | ID_SD_lnkuDfrac},
  {"lnFgutabs", (PVOID) &lnFgutabs, ID_PARM | ID_lnFgutabs},
  {"lnkgutelim", (PVOID) &lnkgutelim, ID_PARM | ID_lnkgutelim},
  {"lnktot", (PVOID) &lnktot, ID_PARM | ID_lnktot},
  {"lnkmratio", (PVOID) &lnkmratio, ID_PARM | ID_lnkmratio},
  {"lnkuDfrac", (PVOID) &lnkuDfrac, ID_PARM | ID_lnkuDfrac},
  {"InitDose", (PVOID) &InitDose, ID_PARM | ID_InitDose},
  {"ConstDoseRate", (PVOID) &ConstDoseRate, ID_PARM | ID_ConstDoseRate},
  {"Fgutabs", (PVOID) &Fgutabs, ID_PARM | ID_Fgutabs},
  {"Fgutabs_tmp", (PVOID) &Fgutabs_tmp, ID_PARM | ID_Fgutabs_tmp},
  {"kgutabs", (PVOID) &kgutabs, ID_PARM | ID_kgutabs},
  {"Vdist", (PVOID) &Vdist, ID_PARM | ID_Vdist},
  {"BW", (PVOID) &BW, ID_PARM | ID_BW},
  {"ktot", (PVOID) &ktot, ID_PARM | ID_ktot},
  {"kmratio", (PVOID) &kmratio, ID_PARM | ID_kmratio},
  {"km_d3g", (PVOID) &km_d3g, ID_PARM | ID_km_d3g},
  {"km_d15g", (PVOID) &km_d15g, ID_PARM | ID_km_d15g},
  {"kuD", (PVOID) &kuD, ID_PARM | ID_kuD},
  {"kuD_tmp", (PVOID) &kuD_tmp, ID_PARM | ID_kuD_tmp},
  {"kgutelim", (PVOID) &kgutelim, ID_PARM | ID_kgutelim},
  {"GSD_don", (PVOID) &GSD_don, ID_PARM | ID_GSD_don},
  {"GSD_d3g", (PVOID) &GSD_d3g, ID_PARM | ID_GSD_d3g},
  {"GSD_d15g", (PVOID) &GSD_d15g, ID_PARM | ID_GSD_d15g},
  {"", NULL, 0} /* End flag */
};  /* vrgpvmGlo[] */


/*----- InitModel
   Should be called to initialize model variables at
   the beginning of experiment before reading
   variants from the simulation spec file.
*/

void InitModel(void)
{
  /* Initialize things in the order that they appear in
     model definition file so that dependencies are
     handled correctly. */

  vrgModelVars[ID_Q_GI] = 0.0;
  vrgModelVars[ID_Q_fec_don] = 0.0;
  vrgModelVars[ID_Qcpt] = 0.0;
  vrgModelVars[ID_Qu_don] = 0.0;
  vrgModelVars[ID_Qu_d3g] = 0.0;
  vrgModelVars[ID_Qu_d15g] = 0.0;
  vrgModelVars[ID_AUC] = 0.0;
  vrgModelVars[ID_AUC_convert] = 0.0;
  vrgModelVars[ID_AUC_dose] = 0.0;
  vrgModelVars[ID_Ccpt] = 0.0;
  vrgModelVars[ID_ExRate_don] = 0.0;
  vrgModelVars[ID_ExRate_d3g] = 0.0;
  vrgModelVars[ID_ExRate_d15g] = 0.0;
  vrgModelVars[ID_ExRate_don_out] = 0.0;
  vrgModelVars[ID_ExRate_d3g_out] = 0.0;
  vrgModelVars[ID_ExRate_d15g_out] = 0.0;
  vrgModelVars[ID_Qu_don_out] = 0.0;
  vrgModelVars[ID_Qu_d3g_out] = 0.0;
  vrgModelVars[ID_Qu_d15g_out] = 0.0;
  M_lnFgutabs = -0.70;
  M_lnkgutelim = -1.05;
  M_lnktot = -1.20;
  M_lnkmratio = 0;
  M_lnkuDfrac = -1.20;
  SD_lnFgutabs = 0.2;
  SD_lnkgutelim = 0.2;
  SD_lnktot = 0.2;
  SD_lnkmratio = 0.2;
  SD_lnkuDfrac = 0.2;
  lnFgutabs = 0;
  lnkgutelim = 0;
  lnktot = 0;
  lnkmratio = 0;
  lnkuDfrac = 0;
  InitDose = 405.405405405405;
  ConstDoseRate = 0;
  Fgutabs = 0.56;
  Fgutabs_tmp = 0.56;
  kgutabs = 0.35;
  Vdist = 1.24;
  BW = 70;
  ktot = 0.30;
  kmratio = 1.00;
  km_d3g = 0.105;
  km_d15g = 0.105;
  kuD = 0.09;
  kuD_tmp = 0.09;
  kgutelim = 0.35;
  GSD_don = 1.1;
  GSD_d3g = 1.1;
  GSD_d15g = 1.1;

  vbModelReinitd = TRUE;

} /* InitModel */


/*----- Dynamics section */

void CalcDeriv (double  rgModelVars[], double  rgDerivs[], PDOUBLE pdTime)
{

  CalcInputs (pdTime); /* Get new input vals */


  rgDerivs[ID_Q_GI] = ConstDoseRate - rgModelVars[ID_Q_GI] * ( kgutabs + kgutelim ) ;

  rgDerivs[ID_Q_fec_don] = rgModelVars[ID_Q_GI] * kgutelim ;

  rgDerivs[ID_Qcpt] = rgModelVars[ID_Q_GI] * kgutabs - rgModelVars[ID_Qcpt] * ( kuD + km_d3g + km_d15g ) ;

  rgDerivs[ID_Qu_don] = rgModelVars[ID_Qcpt] * kuD ;

  rgDerivs[ID_Qu_d3g] = rgModelVars[ID_Qcpt] * km_d3g ;

  rgDerivs[ID_Qu_d15g] = rgModelVars[ID_Qcpt] * km_d15g ;

  rgDerivs[ID_AUC] = rgModelVars[ID_Qcpt] / ( Vdist * BW ) ;

} /* CalcDeriv */


/*----- Model scaling */

void ScaleModel (PDOUBLE pdTime)
{

  vrgModelVars[ID_Q_GI] = InitDose ;
  Fgutabs_tmp = exp ( M_lnFgutabs + SD_lnFgutabs * lnFgutabs ) ;
  Fgutabs = ( Fgutabs_tmp > 1 ) ? 1 : Fgutabs_tmp ;
  kgutelim = exp ( M_lnkgutelim + SD_lnkgutelim * lnkgutelim ) ;
  kgutabs = kgutelim * Fgutabs / ( 1 - Fgutabs ) ;
  ktot = exp ( M_lnktot + SD_lnktot * lnktot ) ;
  kuD_tmp = ktot * exp ( M_lnkuDfrac + SD_lnkuDfrac * lnkuDfrac ) ;
  kuD = ( kuD_tmp > ( 0.99 * ktot ) ) ? ( 0.99 * ktot ) : kuD_tmp ;
  kmratio = exp ( M_lnkmratio + SD_lnkmratio * lnkmratio ) ;
  km_d3g = ( ktot - kuD ) * kmratio / ( 1 + kmratio ) ;
  km_d15g = ( ktot - kuD ) / ( 1 + kmratio ) ;

} /* ScaleModel */


/*----- Jacobian calculations */

void CalcJacob (PDOUBLE pdTime, double rgModelVars[],
                long column, double rgdJac[])
{

} /* CalcJacob */


/*----- Outputs calculations */

void CalcOutputs (double  rgModelVars[], double  rgDerivs[], PDOUBLE pdTime)
{

  rgModelVars[ID_AUC_convert] = rgModelVars[ID_AUC] * 296.32 * 0.001 * 0.001 ;
  rgModelVars[ID_AUC_dose] = rgModelVars[ID_AUC] * BW / InitDose ;
  rgModelVars[ID_Ccpt] = rgModelVars[ID_Qcpt] / ( Vdist * BW ) ;
  rgModelVars[ID_ExRate_don] = rgModelVars[ID_Qcpt] * kuD ;
  rgModelVars[ID_ExRate_d3g] = rgModelVars[ID_Qcpt] * km_d3g ;
  rgModelVars[ID_ExRate_d15g] = rgModelVars[ID_Qcpt] * km_d15g ;
  rgModelVars[ID_ExRate_don_out] = ( rgModelVars[ID_ExRate_don] < 1e-15 ? 1e-15 : rgModelVars[ID_ExRate_don] ) ;
  rgModelVars[ID_ExRate_d3g_out] = ( rgModelVars[ID_ExRate_d3g] < 1e-15 ? 1e-15 : rgModelVars[ID_ExRate_d3g] ) ;
  rgModelVars[ID_ExRate_d15g_out] = ( rgModelVars[ID_ExRate_d15g] < 1e-15 ? 1e-15 : rgModelVars[ID_ExRate_d15g] ) ;
  rgModelVars[ID_Qu_don_out] = ( rgModelVars[ID_Qu_don] < 1e-15 ? 1e-15 : rgModelVars[ID_Qu_don] ) ;
  rgModelVars[ID_Qu_d3g_out] = ( rgModelVars[ID_Qu_d3g] < 1e-15 ? 1e-15 : rgModelVars[ID_Qu_d3g] ) ;
  rgModelVars[ID_Qu_d15g_out] = ( rgModelVars[ID_Qu_d15g] < 1e-15 ? 1e-15 : rgModelVars[ID_Qu_d15g] ) ;

}  /* CalcOutputs */


