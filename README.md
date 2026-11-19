# Air Quality Data Processing and Analysis at RDU Airport, 2018-2020

## Project Description

This project analyzes daily average concentrations of the pollutants CO, PM2.5, and O3 in Durham County, NC from January 2018 to April 2020. A reusable R function was developed to clean and process the three annual datasets, including setting implausible negative values to zero, handling multiple observation by keeping their average, and providing an option to convert O3 units between ppb and ppm. The processed datasets were combined and used to generate annual summary tables and vizualise monthly pollutant concentration patterns.

## Data Source 

The three datasets contain raw measurements obtained from the EPA air quality monitor at RDU airport from January 2018 to April 2020.

## File Structure 

- `data\`: Contains the three annual air quality datasets.

- `functions.R`: Contains functions for data cleaning and generating summary tables.

- `Project_2.Rmd`: Contains the tables, visualizations, and analysis.

- `Project_2.docx`: Word report generated from R Markdown file.

## Reproducibility

#### Required Packages

This project was developed in R version 4.6.0 using the following packages:

- tidyverse (version 2.0.0)

- lubridate (version 1.9.5)

- gt (version 1.3.0)

#### Steps to Reproduce

1.  Download this GitHub repository.
2.  Open `Biostat_721_Project2.Rproj` in RStudio.
3.  Ensure the above packages are installed.
4.  Open `Project_2.rmd` .
5.  Run code or click "Knit" to generate the word report.

## Author and Date

Author: Ava Whysong

Date: 11/19/26
