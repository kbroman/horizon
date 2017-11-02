#' Horizon chart
#'
#' Horizon chart of multiple time series
#'
#' @param dates Vector of dates as character strings (e.g., as \code{"YYYY-MM-DD"}).
#' They need to be equally-spaced. (And actually, on the first,
#' second, and last values are actually used: first and second define
#' gap, and first and last define the time axes.
#' @param df  Data frame with rows = dates, columns = values to plot
#' @param date_format A character string representing the format of \code{dates}.
#'    See \href{https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Formatting.md}{D3 v3 Time Formatting}
#'    for the specifier strings (such as \code{\%m} for decimal month).
#' @param digits Number of digits to show when hovering.
#' @param width width in pixels
#' @param height height in pixels
#' @param axis_height height of axis in pixels
#' @param axis_ticks Number of ticks on axes
#' @param padding Padding around figure
#' @param colors A vector of character strings with RGB colors (like
#' \code{"#rrggbb"}). Must have an event number of elements.
#' \code{length(colors)/2} determines the number of bands; the first
#' half are the colors used for the negative bands, and the second
#' half are the colors for the positive bands.
#' @param tick_format A character string representing the format for date/times in the top and bottom axes.
#'    See \href{https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Formatting.md}{D3 v3 Time Formatting}
#'    for the specifier strings (such as \code{\%m} for decimal month).
#' @param focus_format A character string representing the format for date/time at the focus line.
#'    See \href{https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Formatting.md}{D3 v3 Time Formatting}
#'    for the specifier strings (such as \code{\%m} for decimal month).
#'
#' @details
#' The input \code{dates} need to be converted from character strings to JSON dates.
#'
#' The argument \code{date_format} is used for this. It's a character string like
#' \code{"\%Y-\%m-\%d"} that is used to parse the dates. Here are some of the available
#' codes. (For a complete list, see
#' \href{https://github.com/d3/d3-time-format#locale_format}{the d3.js documentation}.)
#'
#' \itemize{
#' \item \code{\%Y} - 4-digit year (e.g., \code{2016})
#' \item \code{\%y} - 2-digit year (e.g., \code{16})
#' \item \code{\%m} - 2-digit month
#' \item \code{\%d} - 2-digit day-of-month
#' \item \code{\%b} - Month as text (e.g., \code{Mar})
#' }
#'
#' @import htmlwidgets
#'
#' @examples
#' # data included with package
#' file <- system.file("extdata", "test.csv", package="horizon")
#' x <- read.csv(file)
#' horizon(x[,1], x[,-1])
#'
#' # second example with simulated data
#' n <- 600  # number of time points
#' p <- 26   # number of time series
#'
#' # construct sequence of dates
#' dates <- as.character( seq( lubridate::ymd("1969-12-20"), by=7, length=n) )
#'
#' # simulate brownian motion, all starting at 0
#' y <- matrix(0, nrow=n, ncol=p)
#' y[-1,] <- rnorm((n-1)*p, 0, 0.25)
#' y <- apply(y, 2, cumsum)
#' colnames(y) <- letters[1:p]
#'
#' # make the horizon plot
#' horizon(dates, y)
#'
#' @export
horizon <- function(dates, df, date_format = "%Y-%m-%d",
                    digits = NULL, width = NULL, height = NULL,
                    axis_height = 30, axis_ticks=4, padding=15,
                    colors=NULL, tick_format=NULL, focus_format=NULL)
{
    lab <- colnames(df)
    if(is.null(lab))
        lab <- paste0("col", 1:ncol(df))

    if(!is.data.frame(df))
        df <- as.data.frame(df)

    stopifnot(length(dates) == nrow(df))

    df <- as.list(df)
    names(df) <- NULL

    if(is.null(colors))
        colors <- c("#08519c", "#3182bd", "#6baed6", "#bdd7e7",
                    "#bae4b3", "#74c476", "#31a354", "#006d2c")
    if(length(colors) %% 2 != 0)
        stop("length(colors) must be even")

    if(is.null(digits)) {
        digits <- ceiling(log10(diff(range(unlist(df), na.rm=TRUE))))
        digits <- 4 - digits
        digits <- ifelse(digits < 0, 0, digits)
    }

    x = list(dates=dates, labels=lab, data=df, date_format=date_format,
             chartOpts=list(height=height, axis_height=axis_height,
                            axis_ticks=axis_ticks, colors=colors,
                            digits=digits, padding=padding,
                            tick_format=tick_format,
                            focus_format=focus_format))

    # create widget
    htmlwidgets::createWidget(
        name = 'horizon',
        x,
        width = width,
        height = height,
        sizingPolicy=htmlwidgets::sizingPolicy(
                    padding=padding,
                    browser.defaultWidth=800,
                    browser.defaultHeight=600,
                    browser.padding = padding,
                    knitr.defaultWidth=800,
                    knitr.defaultHeight=600,
                    viewer.padding = padding),
        package = 'horizon'
        )
}

#' Shiny bindings for horizon
#'
#' Output and render functions for using horizon within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a horizon
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name horizon-shiny
#'
#' @export
horizonOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'horizon', width, height, package = 'horizon')
}

#' @rdname horizon-shiny
#' @export
renderHorizon <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, horizonOutput, env, quoted = TRUE)
}
