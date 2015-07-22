/*
  CORRELATION ENGINE
  main.js

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 17 Apr 2015
*/

var margin = {
    top: 20,
    right: 80,
    bottom: 30,
    left: 50
  },
  width = 960 - margin.left - margin.right,
  height = 300 - margin.top - margin.bottom,

  socket = io.connect(),
  initPlotDone = false,

  element = "div#plot1",
  element2 = "div#plot2",
  width = 800,
  height = 300,

  data = [];

// Listening to socket
socket.on('out', function(from_db) {
  if (!initPlotDone) {
    data = $.parseJSON(from_db.data);
  } else {
    data.push($.parseJSON(from_db.data2));
  }

  var time = from_db.time,

    data1 = [{
      label: 'x',
      x: data.map(function(d) {
        return parseFloat(d.n);
      }),
      y: data.map(function(d) {
        return parseFloat(d.x)
      }),
    }, {
      label: 'y',
      x: data.map(function(d) {
        return parseFloat(d.n)
      }),
      y: data.map(function(d) {
        return parseFloat(d.y)
      }),
    }],

    data2 = [{
      label: 'r',
      x: data.map(function(d) {
        return parseFloat(d.n);
      }),
      y: data.map(function(d) {
        return typeof(d.r) !== "object" ? parseFloat(d.r) : 0;
      }),
    }, {
      label: 'r_m',
      x: data.map(function(d) {
        return parseFloat(d.n)
      }),
      y: data.map(function(d) {
        return typeof(d.r_m) !== "object" ? parseFloat(d.r_m) : 0;
      }),
    }, {
      label: 'r_h',
      x: data.map(function(d) {
        return parseFloat(d.n)
      }),
      y: data.map(function(d) {
        return typeof(d.r_h) !== "object" ? parseFloat(d.r_h) : 0;
      }),
    }];

  if (!initPlotDone) {
    initPlot(data1, element, width, height, "time", "value");
    initPlot(data2, element2, width, height, "time", "correlation");
    initPlotDone = true;
  } else {
    updatePlot(data1, element, width, height);
    updatePlot(data2, element2, width, height);
  }

  $("#time").text(time);
});
