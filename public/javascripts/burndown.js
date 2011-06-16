// ===========================
// A burndown chart with Protovis
// ===========================
//
// See http://vis.stanford.edu/protovis/ex/area.html
//
var Burndown = function(dom_id) {
  // Set the default DOM element ID to bind
  if ('undefined' == typeof dom_id)  dom_id = 'chart';

  var data = function(start,length,json) {
    // Set the data for the chart
    this.data = json;
	this.sprint_start = start;
	this.sprint_length = length - 1;
    return this;
  };

  var draw = function() {

          // Set-up the data
      var entries = this.data;
          // console.log('Drawing, ', entries);
	  var start = this.sprint_start;
	  var length = this.sprint_length;

          // Set-up dimensions and scales for the chart
      var w = 600,
          h = 300,
          max = pv.max(entries, function(d) { return d.count;}),
          x = pv.Scale.linear(0, length).range(0, w),
          y = pv.Scale.linear(0, max).range(0, h);

          // Create the basis panel
      var vis = new pv.Panel()
          .width(w)
          .height(h)
          .bottom(20)
          .left(20)
          .right(40)
          .top(40);

           // Add the chart legend at top left
       vis.add(pv.Label)
           .top(-20)
           .text(function() {
             var first = new Date(start);
             var last  = new Date(start + (length * 86400000));
             return "Burndown for sprint starting on " +
                    [first.getMonth()+1,first.getDate(),first.getFullYear()].join("/") +
                    " and ending on " +
                    [last.getMonth()+1, last.getDate(), last.getFullYear()].join("/");
            })
           .textStyle("#B1B1B1")

           // Add the X-ticks
       vis.add(pv.Rule)
           .data(x.ticks(length))
           .visible(function(d) {return start + (this.index * 86400000);})
           .left(function() { return x(this.index); })
           .bottom(-15)
           .height(15)
           .strokeStyle("#33A3E1")
           // Add the tick label (DD/MM)
           .anchor("right").add(pv.Label)
            .text(function(d) { var date = new Date(start + (this.index * 86400000)); return [date.getMonth()+1, date.getDate()].join('/'); })
            .textStyle("#2C90C8")
            .textMargin("5")

           // Add the Y-ticks
       vis.add(pv.Rule)
           // Compute tick levels based on the "max" value
           .data(y.ticks(max/(max/10)))
           .bottom(y)
           .strokeStyle("#eee")
           .anchor("left").add(pv.Label)
            .text(y.tickFormat)
            .textStyle("#c0c0c0")

           // Add container panel for the chart
       vis.add(pv.Panel)
           // Add the area segments for each entry
		  .add(pv.Line)
            // Set-up auxiliary variable to hold state (mouse over / out) 
           .def("active", -1)
           // Pass the data to Protovis
           .data([ {"time": 0, "count": max},{"time": length, "count": 0}])
           .bottom(function(d) {return y(d.count);})
           // Compute x-axis based on scale
           .left(function(d) {return x(d.time);})
           // Make the chart curve smooth
           .interpolate('linear')
           // set the line width
		   .lineWidth(2)
		   .strokeStyle("#888")
		
          .add(pv.Line)
            // Set-up auxiliary variable to hold state (mouse over / out) 
           .def("active", -1)
           // Pass the data to Protovis
           .data(entries)
           .bottom(function(d) {return y(d.count);})
           // Compute x-axis based on scale
           .left(function(d) {return x(this.index);})
           // Make the chart curve smooth
           .interpolate('basis')
           // set the line width
		   .lineWidth(3)
		
           .strokeStyle("#2C90C8")

           // On "mouse over", set the relevant area segment as active
           .event("mouseover", function() {
             this.active(this.index);
             return this.root.render();
           })
           // On "mouse out", clear the active state
           .event("mouseout",  function() {
             this.active(-1);
             return this.root.render();
           })
           // On "mouse down", perform action, such as filtering the results...
           .event("mousedown", function(d) {
             var time = entries[this.index].time;
             return (alert("Timestamp: '"+time+"'"));
           })

          // Add the circle "label" displaying the count for this day
          .anchor("top").add(pv.Dot)
           // The label is only visible when area segment is active
           .visible( function() { return this.parent.children[0].active() == this.index; } )
           .left(function(d) {return x(this.index);})
           .bottom(function(d) {return y(d.count);})
           .fillStyle("#33A3E1")
           .lineWidth(0)
           .radius(14)
           // Add text to the label
          .anchor("center").add(pv.Label)
           .text(function(d) {return d.count;})
           .textStyle("#E7EFF4")

           // Bind the chart to DOM element
          .root.canvas(dom_id)
           // And render it.
          .render();
  };

  // Create the public API
  return {
    data   : data,
    draw   : draw
  };

};
