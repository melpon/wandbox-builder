# This file is a "Hello, world!" in R language for wandbox.

data(iris)      ## the "hello, world" of statistics.
summary(iris)   ## a simple summary of the columns
table( iris[, "Species"] )   # tabulation of the Species columns
stopifnot( as.integer(table(iris[, "Species"])) == c(50L, 50L, 50L) )
cat("All done\n")

# R language references:
#   https://cran.r-project.org/manuals.html
