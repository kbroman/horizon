// function to make the plot
cubism_plot = function(div, dates, labels, data_by_col, date_format, chartOpts)
{
    // chart options
    var height = chartOpts.height
    var axis_height = chartOpts.axis_height
    var axis_ticks = chartOpts.axis_ticks

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
    var horizon_height = (height - axis_height*2) / labels.length

    var dF = new Date(2015,1,1)
    var context = cubism.context()
        .serverDelay(gap)
        .step(gap)
        .size(width)
        .stop();

    div.style("width", width + "px")

    div.append("div")
        .attr("class", "rule")
        .call(context.rule());

    // set x-axis domain to observed range of dates
    context.scale.domain([dates[0], dates[dates.length-1]])

    // FIX ME: need to get the axes within the widgetdiv container (currently pushed to top and bottom of page)
    // top axis
    var top_axis = context.axis().orient("top").ticks(axis_ticks)
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
              .extent(ylim) // adjust y-axis in each
              .format(d3.format(".3f")));
    // FIX ME: need to add control of colors with .colors()

    // bottom axis
    var bottom_axis = context.axis().orient("bottom").ticks(axis_ticks)
    var bottom_axis_svg = div.append("div").attr("class", "axis")
                          .append("svg").attr("width", width)
                                        .attr("height", axis_height)
                                        .call(bottom_axis)

    context.on("focus", function(i) {
        d3.selectAll(".value").style("right", i == null ? null : context.size() - i + "px");
    });

    function make_metric(vector, label) {
        return context.metric(function(start, stop, step, callback) {
                callback(null, vector)
        }, label);
    }
}
