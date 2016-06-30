#' Horizon chart
#'
#' Horizon chart of multiple time series
#'
#' @param dates Vector of dates as character strings \code{"YYYY-MM-DD"}.
#' @param df  Data frame with rows = dates, columns = values to plot
#' @param width width in pixels
#' @param height height in pixels
#'
#' @import htmlwidgets
#'
#' @examples
#' file <- system.file("extdata", "test.csv", package="horizon")
#' x <- read.csv(file, stringsAsFactors=FALSE)
#' horizon(x[,1], x[,-1])
#'
#' @export
horizon <- function(dates, df, width = 600, height = 400)
{

    lab <- colnames(df)
    df <- as.list(df)
    names(df) <- NULL

    x = list(dates=dates, labels=lab, data=df)

    # create widget
    htmlwidgets::createWidget(
        name = 'horizon',
        x,
        width = width,
        height = height,
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
