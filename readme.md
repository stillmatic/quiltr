Readme
================

Quilt
-----

R package to Quilt data package manager. See: <https://docs.quiltdata.com/>

Extremely experimental - should be considered *totally unusable* right now.

### Installation

-   `devtools::install_github('stillmatic/quiltr')`
-   `pip install quilt` <!-- * `devtools::install_github('apache/spark', ref='master', subdir='R/pkg')` -->

If you have trouble testing in Rstudio, follow [instructions](https://stackoverflow.com/questions/31121645/rstudio-shows-a-different-path-variable).

### Demo

List installed packages

``` r
qls()
```

    ## [1] "/Users/christopherhua/quilt_packages"
    ## [2] "├── akarve/examples"                 
    ## [3] "├── akarve/seattle_911"              
    ## [4] "├── examples/wine"                   
    ## [5] "└── uciml/wine"

"Peek" at a package, and see what tables are included.

``` r
qpeek("akarve/examples")
```

    ## README
    ## sales
    ## wine_chemistry
    ## world100m

Load a file. Rudimentary support for Parquet and for HDF5 formats.

``` r
qload("akarve/seattle_911", "responses") %>% head
```

    ## Warning: Missing column names filled in: 'X1' [1]

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character(),
    ##   X1 = col_integer(),
    ##   `CAD CDW ID` = col_integer(),
    ##   `CAD Event Number` = col_double(),
    ##   `General Offense Number` = col_integer(),
    ##   `Event Clearance Code` = col_integer(),
    ##   `Census Tract` = col_double(),
    ##   Longitude = col_double(),
    ##   Latitude = col_double()
    ## )

    ## See spec(...) for full column specifications.

    ## Warning in rbind(names(probs), probs_f): number of columns of result is not
    ## a multiple of vector length (arg 1)

    ## Warning: 2192 parsing failures.
    ## row # A tibble: 5 x 5 col     row          col expected actual expected   <int>        <chr>    <chr>  <chr> actual 1  1486 Census Tract a double   NULL file 2  3170 Census Tract a double   NULL row 3  3210 Census Tract a double   NULL col 4  3256 Census Tract a double   NULL expected 5  3685 Census Tract a double   NULL actual # ... with 1 more variables: file <chr>
    ## ... ................. ... .................................... ........ .................................... ...... .................................... .... .................................... ... .................................... ... .................................... ........ .................................... ...... .......................................
    ## See problems(...) for more details.

    ## # A tibble: 6 x 20
    ##      X1 `CAD CDW ID` `CAD Event Number` `General Offense Number`
    ##   <int>        <int>              <dbl>                    <int>
    ## 1     0        15736        10000246357               2010246357
    ## 2     1        15737        10000246471               2010246471
    ## 3     2        15738        10000246255               2010246255
    ## 4     3        15739        10000246473               2010246473
    ## 5     4        15740        10000246330               2010246330
    ## 6     5        15741        10000246477               2010246477
    ## # ... with 16 more variables: `Event Clearance Code` <int>, `Event
    ## #   Clearance Description` <chr>, `Event Clearance SubGroup` <chr>, `Event
    ## #   Clearance Group` <chr>, `Event Clearance Date` <chr>, `Hundred Block
    ## #   Location` <chr>, `District/Sector` <chr>, `Zone/Beat` <chr>, `Census
    ## #   Tract` <dbl>, Longitude <dbl>, Latitude <dbl>, `Incident
    ## #   Location` <chr>, `Initial Type Description` <chr>, `Initial Type
    ## #   Subgroup` <chr>, `Initial Type Group` <chr>, `At Scene Time` <chr>

Search for available packages.

``` r
qsearch("wine")
```

    ## [1] "akarve/wine"        "examples/wine"      "uciml/wine"        
    ## [4] "uciml/wine_quality"

Design Philosophy
-----------------

Given that the bulk of development on the Quilt project is done in Python, it makes sense to provide wrappers to the Python code for non-essential commands, and provide native R code to handle import/export of data only.

Many of the commands named by Quilt conflict with existing R functions, especially in `base`, e.g. `search` or `ls`. To avoid confusion we generally will prefix functions with `q`.

Known bugs:

-   <https://github.com/pandas-dev/pandas/pull/9661>

TODO
----

-   \[X\] search
-   \[ \] permissions/auth
-   \[ \] download
-   \[ \] push
-   \[X\] versioning
-   \[X\] import and retrieve
