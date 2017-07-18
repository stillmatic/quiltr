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

    ## /Users/christopherhua/quilt_packages
    ## ├── akarve/examples
    ## ├── examples/wine
    ## └── uciml/wine

"Peek" at a package, and see what tables are included.

``` r
qpeek("akarve/examples")
```

    ## README
    ## sales
    ## wine_chemistry
    ## world100m

Load a file (HDF5 sort of supported right now)

``` r
qload("akarve/examples", "sales") %>% head
```

    ## Warning in H5Dread(h5dataset = h5dataset, h5spaceFile = h5spaceFile,
    ## h5spaceMem = h5spaceMem, : h5read for type 'VLEN' not yet implemented.
    ## Values replaced by NA's.

    ## Warning in H5Dread(h5dataset = h5dataset, h5spaceFile = h5spaceFile,
    ## h5spaceMem = h5spaceMem, : h5read for type 'VLEN' not yet implemented.
    ## Values replaced by NA's.

    ## Warning in H5Dread(h5dataset = h5dataset, h5spaceFile = h5spaceFile,
    ## h5spaceMem = h5spaceMem, : NAs produced by integer overflow while
    ## converting 64-bit integer or unsigned 32-bit integer from HDF5 to a 32-bit
    ## integer in R. Choose bit64conversion='bit64' or bit64conversion='double' to
    ## avoid data loss and see the vignette 'rhdf5' for more details about 64-bit
    ## integers.

    ## Warning in H5Dread(h5dataset = h5dataset, h5spaceFile = h5spaceFile,
    ## h5spaceMem = h5spaceMem, : h5read for type 'VLEN' not yet implemented.
    ## Values replaced by NA's.

    ## Warning in H5Dread(h5dataset = h5dataset, h5spaceFile = h5spaceFile,
    ## h5spaceMem = h5spaceMem, : h5read for type 'VLEN' not yet implemented.
    ## Values replaced by NA's.

    ## Warning in H5Dread(h5dataset = h5dataset, h5spaceFile = h5spaceFile,
    ## h5spaceMem = h5spaceMem, : h5read for type 'VLEN' not yet implemented.
    ## Values replaced by NA's.

    ##         NA. NA..1     NA..2  NA..3 NA..4 NA..5 NA..6 NA..7 NA..8 NA..9
    ## 1   261.540  0.04 -213.2500  38.94 35.00     1     3     6    NA    NA
    ## 2 10123.020  0.07  457.8100 208.16 68.02    49   293    49    NA    NA
    ## 3   244.570  0.01   46.7075   8.69  2.99    50   293    27    NA    NA
    ## 4  4965.759  0.08 1198.9710 195.99  3.99    80   483    30    NA    NA
    ## 5   394.270  0.08   30.9400  21.78  5.94    85   515    19    NA    NA
    ## 6   146.690  0.05    4.4300   6.64  4.95    86   515    21    NA    NA
    ##   NA..10
    ## 1     NA
    ## 2     NA
    ## 3     NA
    ## 4     NA
    ## 5     NA
    ## 6     NA

Search for available packages.

``` r
qsearch("wine")
```

    ## akarve/wine
    ## examples/wine
    ## uciml/wine
    ## uciml/wine_quality

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
-   \[ \] versioning
-   \[ \] import and retrieve
