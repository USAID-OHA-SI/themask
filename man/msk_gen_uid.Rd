% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/msk_gen_uid.R
\name{msk_gen_uid}
\alias{msk_gen_uid}
\title{Generate a Unique ID}
\usage{
msk_gen_uid(codeSize = 11)
}
\arguments{
\item{codeSize}{character length for UID output (default = 11)}
}
\value{
random alphanumeric string
}
\description{
This function is used to create a unique ID (UID) to mimic the UIDs created
and used by DATIM for the MER and other PEPFAR Structured Datasets.
}
\examples{
 msk_gen_uid()
}
