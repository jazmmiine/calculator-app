## Retirement Contribution Calculator 


The idea is to create a calculator to see how much money you could accumulate in
your employer retirement plan (or other similar retirement account) over time by
making periodic contributions from each paycheck.

![](screenshot.png)

## Inputs

1) __initial salary__: default value 80000.

2) __rate of growth__: this corresponds to the annual salary's rate of growth;
default value 0.02 (i.e. 2%)

3) __contribution percentage (i.e. savings rate)__: the percentage of salary 
that is contributed to the retirement plan every year; default value 0.15 (i.e. 15%)

4) __number of periods__: this corresponds to the number of periodic 
contributions in a year; default 12 (monthly contributions)
    + annually: k=1
    + semi-annual: k=2
    + quarterly: k=4
    + bimonthly: k=6
    + monthly: k=12
    + weekly: k=52

5) __years invested__: number of years; default = 5.

6) __annual rate of return__: expected (average) annual rate of return (this
is the return of investments); default value 0.08 (8%)

7) __target amount__: optional target amount; default value 35000

8) __show target__: by default, no mark for the target amount will be displayed
in the plots, but the user should be allowed to display a mark to visualize this 
amount.

## Outputs

Output Plot-1

The first output has to do with the plot of a timeline to visualize the 
evolution of the retirement balance.

Output Plot-2

The second output has to do with the plot to visualize the composition of 
"Own contributions" versus "Investments Growth".

Output Data Table

The third output involves a data table containing at least six columns (you can 
add more columns if you consider them useful/pertinent for your app):

1) __year__: year (starting with values at the end of year 1);

2) __salary__: annual salary;

3) __contribution__: contribution to retirement plan during each year;

4) __balance__: the total balance of the retirement account at the end
of each year;

5) __own__: cumulative sum of annual contributions;

6) __growth__: growth from the investments.

7) __own_pct__: own in percentage (out of the balance);

8) __growth_pct__: growth in percentage (out of the balance).

9) __hit_target__: whether the balance has hit the target amount (yes/no).


## Running the app


To run the app in Rstudio, execute the following code in R:


```r
library(shiny)

# Run an app from a subdirectory in the repo

runGitHub(
  repo = "calculator-app",
  username = "jazmmiine")
  
```

## Author 

Jazmine Gamboa 

[jazmine-gamboa.quarto.pub](https://jazmine-gamboa.quarto.pub)