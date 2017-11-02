## horizon 0.2-1 (2017-11-02)

### New features

- Added arguments `tick_format` and `focus_format` for controlling the
  formatting of the date/times in the top/bottom axes and at the focus
  point, respectively. These are character string representations of
  date/times, using the codes at
  <https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Formatting.md>

- When `focus_format` is provided, we also force the displayed
  date/time at the focus point to match the closest value in the dates
  provided (avoiding the Cubism's interpolation).
