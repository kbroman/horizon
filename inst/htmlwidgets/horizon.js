// horizon chart widget

HTMLWidgets.widget({

    name: "horizon",
    type: "output",

    initialize: function(widgetdiv, width, height) {
        d3.select(widgetdiv).append("div")
            .attr("id", "maindiv")
            .style("width", width + "px")
            .style("height", height + "px")
    },

    renderValue: function(widgetdiv, x) {
        cubism_plot(d3.select(widgetdiv).select("div#maindiv"),
                    x.dates, x.labels, x.data)
    },

    resize: function(widgetdiv, width, height) {
        d3.select(widgetdiv).select("div#maindiv")
            .style("width", width + "px")
            .style("height", height + "px")
    }

})
