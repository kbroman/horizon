var my_colors = null

which_min =
    function(x, arr)
{
    d = arr.map(function(d) { return(Math.abs(d - x)) })

    result = 0
    value = d[0]
    for(i=1; i<d.length; i++) {
        if(d[i] < value) {
            value = d[i]
            result = i
        }
    }

    return(result)
}


// function to make the plot
cubism_plot = function(div, dates, labels, data_by_col, date_format, chartOpts)
{
    // chart options
    var height = chartOpts.height
    var axis_height = chartOpts.axis_height
    var axis_ticks = chartOpts.axis_ticks
    var colors = chartOpts.colors
    var digits = chartOpts.digits
    var padding = chartOpts.padding
    var tick_format = chartOpts.tick_format // char string for date/time format for axis ticks
    var focus_format = chartOpts.focus_format // char string for date/time format for focus

    // dates from strings to proper dates
    var format = d3.time.format(date_format);
    dates = dates.map(function(d) { return(format.parse(d)) })

    // range of data
    var ylim = [d3.min(data_by_col.map(function(d) { return(d3.min(d)) })),
                d3.max(data_by_col.map(function(d) { return(d3.max(d)) }))]

    // gap in times
    var gap = (+dates[1] - +dates[0])

    // other parameters
    var width = dates.length
    var horizon_height = Math.floor( (height - axis_height*2 - padding*2) / labels.length )

    var dF = new Date(2015,1,1)
    var context = cubism.context()
        .serverDelay(gap)
        .step(gap)
        .size(width)
        .stop();

    div.style("width", width + "px")

    div.append("div")
        .attr("class", "rule")
        .call(context.rule())

    // set x-axis domain to observed range of dates
    context.scale.domain([dates[0], dates[dates.length-1]])

    // top axis
    var top_axis = context.axis().orient("top").ticks(axis_ticks)
    if(tick_format)
        top_axis.tickFormat( d3.time.format(tick_format) )
    if(focus_format) {
        top_axis.focusFormat( function(d) {
            closest_date = dates[which_min(d, dates)]

            return( d3.time.format(focus_format)(closest_date) )
        })
    }
    var top_axis_svg = div.append("div").attr("class", "axis")
                          .append("svg").attr("width", width)
                                        .attr("height", axis_height)
                                        .call(top_axis)

    var Data = []
    for(i=0; i<labels.length; i++) {
        Data.push(make_metric(data_by_col[i], labels[i]))
    }

    div.selectAll(".horizon")
        .data(Data)
        .enter().append("div")
        .attr("class", "horizon")
        .call(context.horizon().height(horizon_height)
              .colors(colors)
              .extent(ylim) // adjust y-axis in each
              .format(d3.format("." + digits + "f")))

    // bottom axis
    var bottom_axis = context.axis().orient("bottom").ticks(axis_ticks)
    if(tick_format)
        bottom_axis.tickFormat( d3.time.format(tick_format) )
    if(focus_format) {
        bottom_axis.focusFormat( function(d) {
            closest_date = dates[which_min(d, dates)]

            return( d3.time.format(focus_format)(closest_date) )
        })
    }
    var bottom_axis_svg = div.append("div").attr("class", "axis")
                          .append("svg").attr("width", width)
                                        .attr("height", axis_height)
                                        .call(bottom_axis)

    context.on("focus", function(i) {
        d3.selectAll(".value").style("right", i == null ? null : context.size() - i + "px");
    });

    // adjust text alignment
    div.selectAll("span.value").style("line-height", horizon_height + "px")
    div.selectAll("span.title").style("line-height", horizon_height + "px")

    // upper and lower borders
    div.style("border-top", "solid 0px #fff")
        .style("border-bottom", "solid 0px #fff")

    // adjust height of axis divs
    div.selectAll("div.axis").style("height", axis_height + "px")

    function make_metric(vector, label) {
        return context.metric(function(start, stop, step, callback) {
                callback(null, vector)
        }, label);
    }
}
