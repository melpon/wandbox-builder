# This file is a "Hello, world!" in R language for wandbox.

data(iris)                               ## the "hello, world" of statistics.
summary(iris)                            ## a simple summary of the columns
fit <- lm(Sepal.Length ~ . , data=iris)  ## basic regression
summary(fit)                             ## summary

cat("All done\n")

# R language references:
#   https://cran.r-project.org/manuals.html
