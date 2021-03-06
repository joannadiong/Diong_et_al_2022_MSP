

    ********** NOTES ********** 

      ** Author: Joanna Diong
      ** Date: 10 Jan 2020

      ** This do file runs meta-analysis on data on eccentric exercise to 
      ** improve increase joint range or muscle fascicle length.
      **
      ** Data are stored as eccentric.xlsx
      **
      ** Note: clear variables in Stata console before running each time

    ********** PRELIMINARIES ********** 
  
  * Install libraries if not yet done so
  *ssc install metan, replace
  *ssc install metafunnel, replace
  *ssc install metabias, replace
  *ssc install metareg, replace
  
  *. net from http://clinicalepidemio.fr/Stata // pairwise, network meta-analysis
  *ssc install metaan, replace     // newer metan package
  *ssc install robumeta, replace   // robust vaiance estimation in meta-regression
  

  version 16
  clear all
  clear matrix
  drop _all
  capture log close
   
      ** Settings.
   
  set more off
  set scheme lean3
  pause on
/*
*/
   
      ** Enter name of root directory and name of this do file.

  local pathname = `""/home/joanna/Dropbox/Projects/eccSR/src/code/stats/""'
  local dofilename = `""eccentric.do""'

      ** Open a time- and date-stamped log file and copy a time- and date-stamped
      ** do file and data file to the log file directory.

  local pathandnameofdofile = `"""' + `pathname' + `dofilename' + `"""'
  local pathoflogfilesname = `"""' + `pathname' + "Log files/" + `"""'
  local pathofdatafilesname = `"""' + `pathname' + "Data/" + `"""'
  local pathofgraphfilesname = `"""' + `pathname' + "Graphs/" + `"""'
  local cdate = "c(current_date)"
  local ctime = "c(current_time)"
  local ctime = subinstr(`ctime',":","h",1)
  local ctime = subinstr("`ctime'",":","m",1)
  local logfilename = `"""' + "Log eccentric " + `cdate' + " " + "`ctime'" + "s.log" + `"""'
  local backupdofilename = `"""' + "Do eccentric " + `cdate' + " " + "`ctime'" + "s.txt" + `"""'
  cd `pathoflogfilesname'
  *log using `logfilename'
  *copy `pathandnameofdofile' `backupdofilename'
  cd `pathofdatafilesname'


    ********** IMPORT DATA AND CLEAN ********** 

  cd `pathofdatafilesname'  
  import excel "eccentric_R1.xlsx", sheet("hedgesg") firstrow clear
  
  drop in 1

  quietly {
    rename Studyname studyname
    rename Comparison comparison
    rename Outcome outcome
    rename Dataformat dataformat
    rename ExerciseMeanDifference eccMeanDiff
    rename ExerciseDifferenceSD eccSDDiff
    rename ExerciseSamplesize eccN
    rename ControlMeanDifference conMeanDiff
    rename ControlDifferenceSD conSDDiff
    rename ControlSamplesize conN
    rename PrePostcorrelation prepostR
    rename Effectdirection direction
    rename Standardizeby stdBy
    rename Hedgessg hg
    rename StdErr se
    rename Variance variance
    rename Limb limb
    rename Compare2Rx compare2Rx
    rename Nordic nordic
    rename MBI mbi
  }

  label variable studyname "Study name"
  label variable hg "Hedges's g"
  
    ********** PRIMARY ANALYSIS: META-ANALYSIS OF PRIMARY OUTCOME **********

  cd `pathofgraphfilesname'
  
  drop if studyname == "Alonso-Fernandez 2019 LG" | /// 
          studyname == "Blazevich 2007 No training" | ///
          studyname == "Chaconas 2017 Abduction" | ///
	      studyname == "Chaconas 2017 External rotation" | ///
          studyname == "Chaconas 2017 Flexion" | ///
	      studyname == "Gomes da Silva 2018 VL, Ecc" | ///
	      studyname == "Gomes da Silva 2018 VL, Ecc + NMES" | ///
          studyname == "Gomes da Silva 2018 RF, Ecc + NMES" | ///
	      studyname == "Kay 2018 Fascicle length" | ///
	      studyname == "Mahieu 2007 Knee flexed" | ///
	      studyname == "Potier 2009 Fascicle length" | ///
	      studyname == "Raj 2011 MG, waitlist" | ///
	      studyname == "Raj 2011 MG, conventional" | ///
	      studyname == "Raj 2011 VL, waitlist" | ///
	      studyname == "Ribeiro-Alvares 2018 Fascicle length" | ///
	      studyname == "Stefansson 2019 Ecc, bent knee" | ///
	      studyname == "Stefansson 2019 Ecc + massage, bent knee" | ///
          studyname == "Stefansson 2019 Ecc + massage, straight knee" | ///
          studyname == "Alonso-Fernandez 2021 PROM" | ///
	      studyname == "Margaritelis 2021" | ///
	      studyname == "Marusic 2020"	  

  quietly {
  replace studyname = "Alonso-Fernandez 2019" if studyname == "Alonso-Fernandez 2019 MG"
  replace studyname = "Blazevich 2007" if studyname == "Blazevich 2007 Conc"
  replace studyname = "Chaconas 2017" if studyname == "Chaconas 2017 Internal rotation" 
  replace studyname = "Gomes da Silva 2018" if studyname == "Gomes da Silva 2018 RF, Ecc"
  replace studyname = "Kay 2018" if studyname == "Kay 2018 PROM" 
  replace studyname = "Mahieu 2007" if studyname == "Mahieu 2007 Knee extended" 
  replace studyname = "Potier 2009" if studyname == "Potier 2009 PROM" 
  replace studyname = "Raj 2011" if studyname == "Raj 2011 VL, conventional" 
  replace studyname = "Ribeiro-Alvares 2018" if studyname == "Ribeiro-Alvares 2018 Sit-and-reach" 
  replace studyname = "Stefansson 2019" if studyname == "Stefansson 2019 Ecc, straight knee"
  
  replace studyname = "Alonso-Fernandez 2021" if studyname == "Alonso-Fernandez 2021 PROM"
  replace studyname = "Benford 2020" if studyname == "Benford 2020 mid-point"
  replace studyname = "Delvaux 2020" if studyname == "Delvaux 2020 PROM"
  replace studyname = "Presland 2020" if studyname == "Presland 2020 ecc v conv"
  
  replace studyname = "Quinlan 2021 Young" if studyname == "Quinlan 2021 young"
  replace studyname = "Quinlan 2021 Older" if studyname == "Quinlan 2021 older"
  }
    

  ** Meta-analysis of primary outcome (Hedges' g effect size of ecc ex)

  metan hg se, random lcols (studyname) effect (Effect size) boxsca(50) texts(110) xlabel(-1 0 1) nowarning  favours(Favours control # Favours exercise)
  graph save effectrand, replace
  graph export effectrand.tif, width(1200) height(900) replace

 
  ** Funnel plot of SE on Hedges' g and Egger's test of bias

  metafunnel hg se, xtitle("Standardised difference (Hedges' g)") ytitle("Standard error") 
  graph save effectfunnel, replace
  graph export effectfunnel.tif, width(1200) height(900) replace

  metabias hg se, egger
  
  
  ** Sensitivity analysis: exclude Timmins
  
  preserve
  
     drop if studyname == "Timmins 2015"
     
     metan hg se, random lcols (studyname) effect (Effect size) boxsca(50) texts(110) xlabel(-1 0 1) nowarning  favours(Favours control # Favours exercise)
     graph save effectrandSens, replace
     graph export effectrandSens.tif, width(1200) height(900) replace
  
  restore
   
    
    ********** SECONDARY ANALYSIS: PRE-SPECIFIED SUBGROUPS **********
    
  quietly generate limb1 = 0 if limb == "ll"
  quietly replace limb1 = 1 if limb == "ul"
  label define limbs 0 "Lower limb" 1 "Upper limb" 
  label values limb1 limbs
  drop limb
  rename limb1 limb
  
  label define dichotomous 0 "Compared against no intervention" 1 "Compared against another intervention"
  foreach var of varlist compare2Rx nordic mbi {
    label values `var' dichotomous
  }
  
  label variable limb "Limb"
  label variable compare2Rx "Comparison between two interventions"
  label variable nordic "Nordic exercise"
  label variable mbi "Performed MBI analysis"
  
  ** Meta-analysis of primary outcome, by dichotomous secondary outcomes

  display _n
  display as text "Meta-analysis of Hedges' g by subgroup " as result "limb"
    
  metan hg se, by(limb) random lcols (studyname) effect (Effect size) nowt boxsca(50) texts(110) xlabel(-1 0 1) nowarning  favours(Favours control # Favours exercise) /*title("Effect by limb")*/
  graph save effectrandby_limb, replace
  graph export effectrandby_limb.tif, width(1200) height(900) replace
  graph drop _all
  
  metareg hg limb, wsse(se)
    
  display _n
  display as text "Meta-analysis of Hedges' g by subgroup " as result "compare2Rx"
    
  metan hg se, by(compare2Rx) random lcols (studyname) effect (Effect size) nowt boxsca(50) texts(110) xlabel(-1 0 1) nowarning  favours(Favours control # Favours exercise) /*title("Effect by comparing two interventions")*/
  graph save effectrandby_compare2Rx, replace
  graph export effectrandby_compare2Rx.tif, width(1200) height(900) replace
      
  metareg hg compare2Rx, wsse(se)
  
  
    ********** SECONDARY ANALYSIS: POSTHOC SUBGROUPS **********
  
  quietly generate outcome1 = 0 if outcome == "prom" | outcome == "arom" | outcome == "rom"
  quietly replace outcome1 = 1 if outcome == "lfas"
  label define outcomes 0 "Range of motion" 1 "Fascicle length"
  label values outcome1 outcomes
  drop outcome
  rename outcome1 outcome
  
  
  ** Meta-analysis of rom vs lfas
  
  display _n
  display as text "Meta-analysis of Hedges' g by subgroup " as result "outcome"
    
  metan hg se, by(outcome) random lcols (studyname) effect (Effect size) nowt boxsca(50) texts(110) xlabel(-1 0 1) nowarning  favours(Favours control # Favours exercise) /*title("Effect by outcome")*/
  graph save effectrandby_outcome, replace
  graph export effectrandby_outcome.tif, width(1200) height(900) replace
  
  metareg hg outcome, wsse(se)
  
  
  ** Funnel plot of SE on Hedges' g: by range of motion and fascicle length

  metafunnel hg se, by(outcome) xtitle("Standardised difference (Hedges' g)") ytitle("Standard error") legend(label(1 "Range of motion") label(2 "Fascicle length"))
  graph save effectfunnel_by, replace
  graph export effectfunnel_by.tif, width(1200) height(900) replace

  metabias hg se, egger

  
  
  
  graph drop _all
  

    ********** END. ********** 

  *log close
  exit  
  
