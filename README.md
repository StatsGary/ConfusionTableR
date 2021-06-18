# ConfusionTableR - a package to convert confusion matrix outputs

<p><img src = "inst/figures/ConfusionTableR.png" width = "125px" height = "150px" align="right"></p>
<div itemscope itemtype="https://schema.org/Person"><a itemprop="sameAs" content="https://orcid.org/0000-0003-3534-6143" href="https://orcid.org/0000-0003-3534-6143" target="orcid.widget" rel="me noopener noreferrer" style="vertical-align:top;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" style="width:1em;margin-right:.5em;" alt="ORCID iD icon">https://orcid.org/0000-0003-3534-6143</a></div>

This package was spurred from the motivation of storing confusion matrix outputs in a database, or data frame, in a row by row format, as we have to test many machine learning models and it is useful in storing the structures in a database. 

## Installing the package from GitHub

Here, I will use the package remotes to install the package:

``` r
# install.packages("remotes") # if not already installed
remotes::install_github("https://github.com/StatsGary/ConfusionTableR")
library(ConfusionTableR)

```

## Using the package

This will download the package and now you can start to use the package with the ML outputs. The supporting Vignette will give the example usage and how to get the most out of the package. 

I found this package to be really useful, as I frequently work with confusion matrices on the back of the CARET library - developed by [`Max Kuhn`](https://cran.r-project.org/web/packages/caret/caret.pdf) and his team. 

The package aim is to make it easier to convert the outputs of the lists from caret and collapse these down into row-by-row entries, specifically designed for storing the outputs in a database or row by row data frame. 

<strong>NOTE: this has been fully tested to work with GitHub and most checks against CRAN, but warnings remain, therefore it cannot be accepted by CRAN at this stage. I will keep developing it to get it on to CRAN. That is my mission.</strong>

## Vignette

The vignette on how to use the package is available <a href="https://rpubs.com/StatsGary/783101">here</a>.

### Package contents

The package contains three main functions for dealing with binary and multi-class prediction problems, and allows for row level views to be built. The package contents are:

- `binaryVisualiseR` - this function allows you to create a nice looking visual on the back of a binary classification task. 
- `SingleFramer` - this is used for binary classification tasks only and the object passed must be a caret confusion matrix object and class
- `MultiFramer` - this is used for multi-classification taks only. Refer to the vignette for guidance.

## Closing remarks

It has been fun putting this package together and I hope you find it useful. If you find any issues using the package, please raise a git hub ticket and I will address it as soon as possible. 
