## Title

Eccentric exercise improves joint flexibility in adults: A systematic review update and meta-analysis


## Journal

Musculoskeletal Science and Practice


## Authors

Joanna Diong, Peter C Carden, Kieran O’Sullivan, Catherine Sherrington, Darren S Reed


## Corresponding author 

Dr Joanna Diong \
School of Medical Sciences \
Faculty of Medicine and Health \
The University of Sydney \
Sydney, NSW 2006, Australia 

Email: joanna.diong@sydney.edu.au


## Data files 

__Data->eccentric_R1.xlsx__ \
Excel file of effect sizes extracted from full texts of trials included in the meta-analysis. Data from this file were used in the meta-analyses to generate Figures 2-5 of the manuscript.

__Data->EccentricexSR_DATA_2022-01-19_1344.xlsx__ \
Excel file of descriptive data extracted into RedCap from full texts of trials included in the systematic review. 
Data from this file are not analysed with computer code; calculations were done in the spreadsheet. 


## Code files 

Stata code files to perform meta-analysis and generate figures were written by Joanna Diong (Stata v16). 

__eccentric.do__ \
Main script: Stata do file to analyse data. Calls `Data->eccentric.xlsx`, performs meta-analysis, plots figures. 

__eccentric-PI_R1.xlsx__ \
Spreadsheet to calculate prediction interval of overall effect of eccentric exercise. Spreadsheet was obtained from [www.meta-analysis-books.com](www.meta-analysis-books.com).

__scheme-lean3.scheme__ \
Graph scheme. Place `scheme-lean3.scheme` in Stata directory _Stata16->ado->base->s_


## Instructions to run analysis

Download all data and code files. \
Open `eccentric.do`, change filepath to local folder (Line 44)

Ensure dependencies are installed. Run in Stata: 
  
  * ssc install metan, replace
  * ssc install metafunnel, replace
  * ssc install metabias, replace

Run `eccentric.do`.

Note: for ease and transparency, all raw and processed data are hosted in the OSF repository. 


### Calculation of 95% prediction interval 

__eccentric-PI.xlsx__ \ 
__Log files->Log eccentric 25 May 2020 14h07m33s.log__

The spreadsheet was obtaind from https://meta-analysis-books.com/

Enter data into spreadsheet from log file lines 66 to 145.


## Outputs


### Figures 

* Graphs->effectfunnel
* Graphs->effectfunnel_by
* Graphs->effectrand
* Graphs->effectrandby_outcome
* Graphs->effectrandby_compare2Rx
* Graphs->effectrandby_limb
* Graphs->effectrandSens

These are Stata .gph graph and .tif figures of 
- funnel plots
- random-effects meta-analysis: pooled outcomes
- random-effects meta-analysis: separate range of motion and fascicle length outcomes
- random-effects meta-analysis by subgroup of comparisons against 2 interventions and no intervention
- random-effects meta-analysis by subgroup of upper and lower limbs

### Log files

* Log files-> "Do eccentric 19 Jan 2022 12h24m48s.txt"
* Log files-> "Log eccentric 19 Jan 2022 12h24m48s.txt"

These are date and time-stamped files recording the Stata Do file code and Log of output.

