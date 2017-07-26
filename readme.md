Readme
================

Quilt
-----

R package to Quilt data package manager. See: <https://docs.quiltdata.com/>

Extremely experimental - should be considered *totally unusable* right now. This package currently has a hard requirement on Python and access to shell commands.

### Installation

-   `devtools::install_github('stillmatic/quiltr')`
-   `pip install quilt` <!-- * `devtools::install_github('apache/spark', ref='master', subdir='R/pkg')` -->

If you have trouble testing in Rstudio, follow [instructions](https://stackoverflow.com/questions/31121645/rstudio-shows-a-different-path-variable) to set the proper PATH for Rstudio.

### Demo

``` r
seattle <- qload("akarve/seattle_911", "responses", suppress=TRUE)
```

``` r
seattle %>% head %>% knitr::kable()
```

|  CAD CDW ID|  CAD Event Number|  General Offense Number|  Event Clearance Code| Event Clearance Description   | Event Clearance SubGroup      | Event Clearance Group    | Event Clearance Date   | Hundred Block Location            | District/Sector | Zone/Beat |  Census Tract|  Longitude|  Latitude| Incident Location              | Initial Type Description | Initial Type Subgroup | Initial Type Group | At Scene Time |
|-----------:|-----------------:|-----------------------:|---------------------:|:------------------------------|:------------------------------|:-------------------------|:-----------------------|:----------------------------------|:----------------|:----------|-------------:|----------:|---------:|:-------------------------------|:-------------------------|:----------------------|:-------------------|:--------------|
|       15736|       10000246357|              2010246357|                   242| FIGHT DISTURBANCE             | DISTURBANCES                  | DISTURBANCES             | 07/17/2010 08:49:00 PM | 3XX BLOCK OF PINE ST              | M               | M2        |      8100.200|  -122.3381|  47.61098| (47.610975163, -122.338146748) | NA                       | NA                    | NA                 | NA            |
|       15737|       10000246471|              2010246471|                    65| THEFT - MISCELLANEOUS         | THEFT                         | OTHER PROPERTY           | 07/17/2010 08:50:00 PM | 36XX BLOCK OF DISCOVERY PARK BLVD | Q               | Q1        |      5700.101|  -122.4046|  47.65832| (47.658324899, -122.404612874) | NA                       | NA                    | NA                 | NA            |
|       15738|       10000246255|              2010246255|                   250| MISCHIEF, NUISANCE COMPLAINTS | NUISANCE, MISCHIEF COMPLAINTS | NUISANCE, MISCHIEF       | 07/17/2010 08:55:00 PM | 21XX BLOCK OF 3RD AVE             | M               | M2        |      7200.203|  -122.3428|  47.61355| (47.613551471, -122.342843234) | NA                       | NA                    | NA                 | NA            |
|       15739|       10000246473|              2010246473|                   460| TRAFFIC (MOVING) VIOLATION    | TRAFFIC RELATED CALLS         | TRAFFIC RELATED CALLS    | 07/17/2010 09:00:00 PM | 7XX BLOCK OF ROY ST               | D               | D1        |      7200.100|  -122.3418|  47.62540| (47.625401388, -122.341846999) | NA                       | NA                    | NA                 | NA            |
|       15740|       10000246330|              2010246330|                   250| MISCHIEF, NUISANCE COMPLAINTS | NUISANCE, MISCHIEF COMPLAINTS | NUISANCE, MISCHIEF       | 07/17/2010 09:00:00 PM | 9XX BLOCK OF ALOHA ST             | D               | D1        |      6700.101|  -122.3397|  47.62742| (47.627424837, -122.339708605) | NA                       | NA                    | NA                 | NA            |
|       15741|       10000246477|              2010246477|                   281| SUSPICIOUS VEHICLE            | SUSPICIOUS CIRCUMSTANCES      | SUSPICIOUS CIRCUMSTANCES | 07/17/2010 09:02:00 PM | 30XX BLOCK OF W GOVERNMENT WAY    | Q               | Q1        |      5700.200|  -122.3966|  47.66131| (47.66131158, -122.39662681)   | NA                       | NA                    | NA                 | NA            |

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
