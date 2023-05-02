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
- Tobias B. Polak <sup>1,2,3,4,*</sup>
- David G.J. Cucchi <sup>5,6</sup>
- Jasmin Schelhaas <sup>1</sup>
- Syed S. Ahmed <sup>1</sup>
- Naima Khoshnaw <sup>1</sup>
- Joost van Rosmalen <sup>2,3</sup>
- Carin A. Uyl - de Groot <sup>4</sup>

<sup>1</sup> Real-World Data Department, myTomorrows, Amsterdam, Netherlands

<sup>2</sup> Department of Biostatistics, Erasmus Medical Center, Rotterdam, Netherlands

<sup>3</sup> Department of Epidemiology, Erasmus Medical Center, Rotterdam, Netherlands

<sup>4</sup> Erasmus School of Health Policy & Management, Erasmus University Rotterdam, Rotterdam, Netherlands

<sup>5</sup> Department of Hematology, Amsterdam UMC, Vrije Universiteit Amsterdam, Cancer Center Amsterdam, Amsterdam, Netherlands

<sup>6</sup> Department of Internal Medicine, Franciscus Gasthuis & Vlietland, Rotterdam, The Netherlands

<sup>*</sup> Corresponding author: t.polak@erasmusmc.nl

## Graphical Information
1. Pubmed Animation:
   ![Pubmed Animation](/Animations/1_Pubmed.gif)
   Depicts the search on Pubmed, where we categorize papers as relevant, irrelevant, or unclear.
   
2. Unclear Animation:
   ![Unclear Animation](/Animations/2_Unclear.gif)
   Depicts the process of resolving edge cases with multiple independent reviewers.
   
3. PM_DATA Animation:
   ![PM_DATA Animation](/Animations/3_PM_DATA.gif)
   Depicts the extraction of all relevant information from the papers to populate a proprietary database.
