% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse.R
\name{qparse}
\alias{qparse}
\title{Parse JSON specification to find info about a file}
\usage{
qparse(pkg_name, file)
}
\arguments{
\item{pkg_name}{which package the file belongs to}

\item{file}{path to the file, see examples}
}
\value{
dataframe with info about a particular file
}
\description{
Parse JSON specification to find info about a file
}
\examples{
qparse("examples/wine", "quality/red")
qparse("akarve/seattle_911", "responses")
}
