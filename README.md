## Retirement Contribution Calculator 


The idea is to create a calculator to see how much money you could accumulate in
your employer retirement plan (or other similar retirement account) over time by
making periodic contributions from each paycheck.

![](screenshot.png)

## Running the app


To run the app in Rstudio, execute the following code in R:


```r
library(shiny)

# Run an app from a subdirectory in the repo

runGitHub(
  repo = "calculator-app",
  username = "jazmmiine")
  
```