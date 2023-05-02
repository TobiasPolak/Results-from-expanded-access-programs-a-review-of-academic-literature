# Results from Expanded Access Programs: A review of Academic Literature

This repository contains the source code and data for the paper "Results from Expanded Access Programs: A review of Academic Literature," which is currently in press in the Drugs journal.

## Citation

This paper has not yet been published. We will make a citation available upon publication. 

## How to run the code
The code available in the [Scripts](/Scripts) folder can be run sequentially to reproduce the analysis.

1. The `01LoadInstall.R` script installs the required packages and loads the necessary functions. This script ensures that all the necessary R packages are installed and loads the custom functions required for the data analysis. The script performs the following tasks:
   - Installs necessary packages from CRAN.
   - Loads custom functions for data processing and analysis.
   
2. The `02DataAnalysis.R` script performs the data analysis and generates the results. It includes the code for processing the data, conducting statistical analyses, and deriving the main findings of the study.
   
3. The `03Plots.R` script creates the plots and visualizations. This script contains the code for generating various graphical representations, such as charts, graphs, and figures, to illustrate the results of the data analysis.

For a detailed description of our methodology, please refer to the Methods section of our paper.

## Note
- Make sure you have an internet connection while running the script, as it may download additional data files.
- This script assumes that you have R and RStudio installed on your system.

### Authors
- Tobias B. Polak <sup>1,2,3,4,*</sup> (ORCID: 0000-0002-2720-3479)
- David G.J. Cucchi <sup>5,6</sup> (ORCID: 0000-0001-6706-5464)
- Jasmin Schelhaas <sup>1</sup>
- Syed S. Ahmed <sup>1</sup>
- Naima Khoshnaw <sup>1</sup>
- Joost van Rosmalen <sup>2,3</sup> (ORCID: 0000-0002-9187-244X)
- Carin A. Uyl - de Groot <sup>4</sup> (ORCID: 0000-0001-6492-5203)

<sup>1</sup> Real-World Data Department, myTomorrows, Amsterdam, Netherlands

<sup>2</sup> Department of Biostatistics, Erasmus Medical Center, Rotterdam, Netherlands

<sup>3</sup> Department of Epidemiology, Erasmus Medical Center, Rotterdam, Netherlands

<sup>4</sup> Erasmus School of Health Policy & Management, Erasmus University Rotterdam, Rotterdam, Netherlands

<sup>5</sup> Department of Hematology, Amsterdam UMC, Vrije Universiteit Amsterdam, Cancer Center Amsterdam, Amsterdam, Netherlands

<sup>6</sup> Department of Internal Medicine, Franciscus Gasthuis & Vlietland, Rotterdam, The Netherlands

<sup>*</sup> Corresponding author: t.polak@erasmusmc.nl

## Graphical Information
1. Initial independent systematic search of PubMed articles based on 'expanded access terms'. Papers were considered relevant if they described new data of a therapeutic intervention delivered under expanded access.
   ![Pubmed Animation](/Animations/1_PubMed.gif)
   Depicts the search on Pubmed, where we categorize papers as relevant, irrelevant, or unclear. If independent researchers didn't agree on in or exclusion, papers were categorized as unclear. These papers were subsequently analyzed by a third independent reviewer.
   
2. All articles were assessed at least twice. Discordance was resolved by a third independent author.
   ![Unclear Animation](/Animations/2_Unclear.gif)
   Depicts the process of resolving edge cases (unclear) with multiple independent reviewers.
   
3. For all relevant articles, we extracted all relevant information into a database. We labelled articles for time of publication, research location (country, national/international, single-center/multi-center), number of patients, research methodology (retrospective/prospective), drug, disease, and disease area, among others.
   ![PM_DATA Animation](/Animations/3_PM_DATA.gif)
   Depicts the extraction of all relevant information from the papers to populate a proprietary database.
   
## Author Contributions
TBP conceived the idea for this review. TBP, DGJC, SSA, JS, and NK collected and labelled the data. TBP and JvR performed the statistical analysis. TBP drafted the manuscript. DGJC, JvR, and CAU-dG critically revised the manuscript. All authors approved the final version of the manuscript.

## Statements and Declarations
CAU-dG has received unrestricted grants from Boehringer Ingelheim, Astellas, Celgene, Sanofi, Janssen-Cilag, Bayer, Amgen, Genzyme, Merck, Glycostem Therapeutics, Astra Zeneca, Roche, and Merck. TBP works part-time for expanded access service provider myTomorrows, in which he holds stock and stock options (< 0.01%). He is contractually free to publish, and the service provider is not involved in any of his past or ongoing research, nor in this manuscript. DGJC received payments for lectures for Takeda, and conference visit support from Servier, all outside the submitted work. JS, SSA, NK, and JVR do not report any conflicts of interest.

## Funding
CAU-dG, JvR, and TBP work on a Dutch government grant from HealthHolland. For this grant, they research legal, ethical, policy, and statistical issues of evidence generation in expanded access programs (EMCLSH20012). HealthHolland is a funding vehicle for the Dutch Ministry of Economic Affairs and Climate Policy that addresses the Dutch Life Sciences & Health sector.

## Acknowledgements
We would like to express our gratitude to Rebeca Domínguez for helping with the animations.

