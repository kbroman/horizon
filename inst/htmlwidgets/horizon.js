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
