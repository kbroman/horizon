## Making the horizon package

The [R/horizon package](https://github.com/kbroman/horizon) is
an [htmlwidgets](http://www.htmlwidgets.org)-based R package for
making horizon plots with the
[cubism.js](http://square.github.io/cubism/) library. Cubism.js is
aimed towards "real time" dashboards, fetching time series data
incrementally. R/horizon focuses just on making horizon plot of a
static data set.

Here, I'll describe briefly how I created the package.

## Creating a basic horizon function

I started with this gist: <https://gist.github.com/bae25/10797393>,
which itself is based on
[this demo](https://bost.ocks.org/mike/cubism/intro/demo-stocks.html).

The first thing to do was to tear apart the HTML, CSS, and Javascript
into three separate files.

Next, I want to turn the thing into a function that takes some
data. The main task, in doing so, is to pull out
[the code that reads data from files](https://gist.github.com/bae25/10797393#file-index-html-L145-L153),
which in the original gist and demo were deep inside things, and have
that be way on the outside.

My first successful attempt is at
<https://github.com/kbroman/cubism_test/blob/master/script.js>.

## Scales

The next thing that was confusing was the x-axis scale. It turns out
the cubism expects evenly-spaced data, with a single pixel per time
point.

The code
[`cubism.context()`](https://github.com/kbroman/cubism_test/blob/master/script.js#L52)
is the main initializer of everything, and
[`.size()`](https://github.com/kbroman/cubism_test/blob/master/script.js#L55)
is going to be the number of data points. I don't completely
understand `.serverDelay()`  and `.step()`, but note that
[`.stop()`](https://github.com/kbroman/cubism_test/blob/master/script.js#L56)
is used to stop trying to grab data externally.

## Divs

The next confusing bit was that Cubism doesn't make a single graphic,
but rather each horizontal segment (that is, each separate time
series) exists in a separate `<canvas>` within a separate `<div>`.
The horizontal rules bordering each is controlled in the CSS.

These things are created by calls to
[`context.horizon()`](https://github.com/kbroman/cubism_test/blob/master/script.js#L89)

The upper and lower axes are separate SVGs, and their placement at the
very top and bottom was controlled in the CSS. These are created by
calls to [`context.axis()`](https://github.com/kbroman/cubism_test/blob/master/script.js#L65)

`context.horizon()` and `context.axis()` each return a function that,
when called, will create the actual objects. These can be done both at
once, as I've done for
[`.horizon()`](https://github.com/kbroman/cubism_test/blob/master/script.js#L89-L91),
or in separate pieces, as I've done for
[`.axis()`](https://github.com/kbroman/cubism_test/blob/master/script.js#L73-L78).

## Creating the htmlwidgets package

To make the horizon plots accessible from R, we need to create a
separate R package.

You can use the `htmlwidgets::scaffoldWidget` function to create the
basic "scaffolding", or you can just do it by hand.

### Libraries

- Create a directory `/inst/htmlwidgets/lib`.

- Put D3.js code in [`inst/htmlwidgets/lib/d3`](https://github.com/kbroman/horizon/tree/master/inst/htmlwidgets/lib/d3)

- Put Cubism.js code in [`inst/htmlwidgets/lib/cubism`](https://github.com/kbroman/horizon/tree/master/inst/htmlwidgets/lib/cubism).

- I put the basic function to make the horizon plot, plus related CSS
  code, within
  [`inst/htmlwidgets/lib/cubism_horizon`](https://github.com/kbroman/horizon/tree/master/inst/htmlwidgets/lib/cubism_horizon).

### Javascript to create the plot

- Within `inst/htmlwidgets`, create a
 [`horizon.yaml`](https://github.com/kbroman/horizon/tree/master/inst/htmlwidgets/horizon.yaml)
 file that indicates the dependencies (on D3, Cubism, and the special
 [`cubism_horizon.js`](https://github.com/kbroman/horizon/tree/master/inst/htmlwidgets/lib/cubism_horizon/cubism_horizon.js)
 and [`cubism_horizon.css`](https://github.com/kbroman/horizon/tree/master/inst/htmlwidgets/lib/cubism_horizon/cubism_horizon.css).

- Also within `inst/htmlwidgets`, create a
 [`horizon.js`](https://github.com/kbroman/horizon/tree/master/inst/htmlwidgets/horizon.js)
 file that contains a call to `HTMLWidgets.widget()`. This defines
 three separate function: `initialize`, `renderValue` (which calls the
 main function to make the plot), and `resize` (which you can use to
 re-size the plot).

- The functions pass around a `<div>` in which you'll place the actual plot.

- I futz around a bit here to try to pass the height of the widget to
  my `cubism_plot()` function.


### R function to really create the plot

- Within `R`, create an R function that reorganizes the data and any
  other plotting options and passes them to
  `htmlwidgets::createWidget`.

- You can use `sizingPolicy` to control the default sizes (and
  padding) of the chart in different contexts.

- You can also define Shiny bindings, for creating the chart within a
  Shiny app.


## Dimensions

I had a whole bunch of messing around with sizes of things. Mostly,
I'm taken the height of the plot as given, and I'm not trying to
control the width at all, but rather leaving at the Cubism default of 1 pixel per
time point.
