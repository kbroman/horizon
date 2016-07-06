// horizon chart widget

HTMLWidgets.widget({

    name: "horizon",
    type: "output",

    initialize: function(widgetdiv, width, height) {
        d3.select(widgetdiv)
            .style("height", height + "px")
    },

    renderValue: function(widgetdiv, x) {
        // grab height from container
        var h = d3.select(widgetdiv).style("height")
        h = h.slice(0, h.length-2) // remove "px"
        h -= 30 // subtract off 30 pixels as fudge within RStudio

        // force things to work out to be integers
        band_h = Math.floor((h - x.chartOpts.axis_height*2)/x.labels.length)
        h = band_h * x.labels.length + 2*x.chartOpts.axis_height

        // adjust height of widgetdiv
        d3.select(widgetdiv).style("height", h+x.chartOpts.axis_height+30 + "px")

        x.chartOpts.height = h

        // make the plot
        cubism_plot(d3.select(widgetdiv),
                    x.dates, x.labels, x.data,
                    x.date_format, x.chartOpts)
    },

    resize: function(widgetdiv, width, height) {
        d3.select(widgetdiv)
            .style("height", height + "px")
    }

})
