# ConfusionTableR - a package to flatten carets Confusion Matrix Outputs

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

I found this package to be really useful, as I frequently work with confusion matrices on the back of the CARET library - developed by `Max Kuhn` and his team. 

### Package contents

The package contains three main functions for dealing with binary and multi-class prediction problems, and allows for row level views to be built. The package contents are:

- `binaryVisualiseR` - this function allows you to create a nice looking visual on the back of a binary classification task. 
- `SingleFramer` - this is used for binary classification tasks only and the object passed must be a caret confusion matrix object and class
- `MultiFramer` - this is used for multi-classification taks only. Refer to the vignette for guidance.

## Closing remarks

It has been fun putting this package together and I hope you find it useful. If you find any issues using the package, please raise a git hub ticket and I will address it as soon as possible. 