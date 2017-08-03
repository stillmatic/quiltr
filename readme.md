Readme
================

Quiltr
------

An R package to Quilt data package manager. See [docs](https://docs.quiltdata.com/) and [GitHub](https://github.com/quiltdata/quilt)

Extremely experimental - should be considered *mostly unusable* right now. This package currently has a hard dependency on Python.

### Installation

-   `devtools::install_github('stillmatic/quiltr')`
-   `pip install quilt`

If you have trouble testing in Rstudio, follow [instructions](https://stackoverflow.com/questions/31121645/rstudio-shows-a-different-path-variable) to set the proper PATH for Rstudio.

### Demo

``` r
seattle <- qload("akarve.seattle_911", "responses")
```

    ## Warning: Coercing int64 to double

    ## Warning: Coercing int64 to double

``` r
seattle %>% head %>% knitr::kable()
```

| CAD CDW ID |  CAD Event Number|  General Offense Number| Event Clearance Code | Event Clearance Description   | Event Clearance SubGroup      | Event Clearance Group    | Event Clearance Date   | Hundred Block Location            | District/Sector | Zone/Beat | Census Tract | Longitude           | Latitude          | Incident Location              | Initial Type Description | Initial Type Subgroup | Initial Type Group | At Scene Time |
|:-----------|-----------------:|-----------------------:|:---------------------|:------------------------------|:------------------------------|:-------------------------|:-----------------------|:----------------------------------|:----------------|:----------|:-------------|:--------------------|:------------------|:-------------------------------|:-------------------------|:----------------------|:-------------------|:--------------|
| 15736      |       10000246357|              2010246357| 242                  | FIGHT DISTURBANCE             | DISTURBANCES                  | DISTURBANCES             | 07/17/2010 08:49:00 PM | 3XX BLOCK OF PINE ST              | M               | M2        | 8100.2001    | -122.33814674799999 | 47.610975163      | (47.610975163, -122.338146748) |                          |                       |                    |               |
| 15737      |       10000246471|              2010246471| 65                   | THEFT - MISCELLANEOUS         | THEFT                         | OTHER PROPERTY           | 07/17/2010 08:50:00 PM | 36XX BLOCK OF DISCOVERY PARK BLVD | Q               | Q1        | 5700.1012    | -122.404612874      | 47.65832489899999 | (47.658324899, -122.404612874) |                          |                       |                    |               |
| 15738      |       10000246255|              2010246255| 250                  | MISCHIEF, NUISANCE COMPLAINTS | NUISANCE, MISCHIEF COMPLAINTS | NUISANCE, MISCHIEF       | 07/17/2010 08:55:00 PM | 21XX BLOCK OF 3RD AVE             | M               | M2        | 7200.2025    | -122.342843234      | 47.613551471      | (47.613551471, -122.342843234) |                          |                       |                    |               |
| 15739      |       10000246473|              2010246473| 460                  | TRAFFIC (MOVING) VIOLATION    | TRAFFIC RELATED CALLS         | TRAFFIC RELATED CALLS    | 07/17/2010 09:00:00 PM | 7XX BLOCK OF ROY ST               | D               | D1        | 7200.1002    | -122.341846999      | 47.625401388      | (47.625401388, -122.341846999) |                          |                       |                    |               |
| 15740      |       10000246330|              2010246330| 250                  | MISCHIEF, NUISANCE COMPLAINTS | NUISANCE, MISCHIEF COMPLAINTS | NUISANCE, MISCHIEF       | 07/17/2010 09:00:00 PM | 9XX BLOCK OF ALOHA ST             | D               | D1        | 6700.1009    | -122.339708605      | 47.627424837      | (47.627424837, -122.339708605) |                          |                       |                    |               |
| 15741      |       10000246477|              2010246477| 281                  | SUSPICIOUS VEHICLE            | SUSPICIOUS CIRCUMSTANCES      | SUSPICIOUS CIRCUMSTANCES | 07/17/2010 09:02:00 PM | 30XX BLOCK OF W GOVERNMENT WAY    | Q               | Q1        | 5700.2005    | -122.39662681       | 47.66131158       | (47.66131158, -122.39662681)   |                          |                       |                    |               |

Design Philosophy
-----------------

Given that the bulk of development on the Quilt project is done in Python, it makes sense to provide wrappers to the Python code for non-essential commands, and provide native R code to handle import/export of data only. Additionally, the Quilt project is under heavy development; rather than reimplementing this moving target in R, we can use

Many of the commands named by Quilt conflict with existing R functions, especially in `base`, e.g. `search` or `ls`. To avoid confusion we generally will prefix functions with `q`.

This package makes extensive use of the R package `reticulate` to interface with Python. The file IO and conversion is done via the `feather` project, in lieu of R support for Apache Arrow (see, e.g. [ARROW-1325](https://issues.apache.org/jira/browse/ARROW-1325) and other stuff on the arrow-dev listserv).

TODO
----

-   \[X\] search
-   \[X\] permissions/auth
-   \[X\] download
-   \[ \] push/build
-   \[X\] versioning
-   \[X\] import and retrieve
