% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/horizon.R
\name{horizon}
\alias{horizon}
\title{Horizon chart}
\usage{
horizon(
  dates,
  df,
  date_format = "\%Y-\%m-\%d",
  digits = NULL,
  width = NULL,
  height = NULL,
  axis_height = 30,
  axis_ticks = 4,
  padding = 15,
  colors = NULL,
  tick_format = NULL,
  focus_format = NULL
)
}
\arguments{
\item{dates}{Vector of dates as character strings (e.g., as \code{"YYYY-MM-DD"}).
They need to be equally-spaced. (And actually, on the first,
second, and last values are actually used: first and second define
gap, and first and last define the time axes.}

\item{df}{Data frame with rows = dates, columns = values to plot}

\item{date_format}{A character string representing the format of \code{dates}.
See \href{https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Formatting.md}{D3 v3 Time Formatting}
for the specifier strings (such as \code{\%m} for decimal month).}

\item{digits}{Number of digits to show when hovering.}

\item{width}{width in pixels}

\item{height}{height in pixels}

\item{axis_height}{height of axis in pixels}

\item{axis_ticks}{Number of ticks on axes}

\item{padding}{Padding around figure}

\item{colors}{A vector of character strings with RGB colors (like
\code{"#rrggbb"}). Must have an event number of elements.
\code{length(colors)/2} determines the number of bands; the first
half are the colors used for the negative bands, and the second
half are the colors for the positive bands.}

\item{tick_format}{A character string representing the format for date/times in the top and bottom axes.
See \href{https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Formatting.md}{D3 v3 Time Formatting}
for the specifier strings (such as \code{\%m} for decimal month).}

\item{focus_format}{A character string representing the format for date/time at the focus line.
See \href{https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Formatting.md}{D3 v3 Time Formatting}
for the specifier strings (such as \code{\%m} for decimal month).}
}
\description{
Horizon chart of multiple time series
}
\details{
The input \code{dates} need to be converted from character strings to JSON dates.

The argument \code{date_format} is used for this. It's a character string like
\code{"\%Y-\%m-\%d"} that is used to parse the dates. Here are some of the available
codes. (For a complete list, see
\href{https://github.com/d3/d3-time-format#locale_format}{the d3.js documentation}.)

\itemize{
\item \code{\%Y} - 4-digit year (e.g., \code{2016})
\item \code{\%y} - 2-digit year (e.g., \code{16})
\item \code{\%m} - 2-digit month
\item \code{\%d} - 2-digit day-of-month
\item \code{\%b} - Month as text (e.g., \code{Mar})
}
}
\examples{
# data included with package
file <- system.file("extdata", "test.csv", package="horizon")
x <- read.csv(file)
horizon(x[,1], x[,-1])

# second example with simulated data
n <- 600  # number of time points
p <- 26   # number of time series

# construct sequence of dates
dates <- as.character( seq( lubridate::ymd("1969-12-20"), by=7, length=n) )

# simulate brownian motion, all starting at 0
y <- matrix(0, nrow=n, ncol=p)
y[-1,] <- rnorm((n-1)*p, 0, 0.25)
y <- apply(y, 2, cumsum)
colnames(y) <- letters[1:p]

# make the horizon plot
horizon(dates, y)

}
