Readme
================

Quilt
-----

R package to Quilt data package manager. See: <https://docs.quiltdata.com/>

Contact: <hua.christopher@gmail.com>

*Installation*:

-   `devtools::install_github('stillmatic/quiltr')`
-   `pip install quilt` <!-- * `devtools::install_github('apache/spark', ref='master', subdir='R/pkg')` -->

If you have trouble testing in Rstudio, follow [instructions](https://stackoverflow.com/questions/31121645/rstudio-shows-a-different-path-variable).

Design Philosophy
-----------------

Given that the bulk of development on the Quilt project is done in Python, it makes sense to provide wrappers to the Python code for non-essential commands, and provide native R code to handle import/export of data only.

Many of the commands named by Quilt conflict with existing R functions, especially in `base`, e.g. `search` or `ls`. To avoid confusion we generally will prefix functions with `q`.

Known bugs:

-   <https://github.com/pandas-dev/pandas/pull/9661>

TODO
----

-   \[ \] search
-   \[ \] permissions/auth
-   \[ \] download
-   \[ \] push
-   \[X\] read - implementing different types
