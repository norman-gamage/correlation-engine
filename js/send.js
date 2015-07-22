/*
  CORRELATION ENGINE
  send.js

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 24 Apr 2015
*/

var timer = null,
  interval = 10,
  x = y = 0,
  sign = 1,
  socket = io.connect();

// Post data over socket connection
function post() {
  socket.emit('in', {
    'x': x,
    'y': y
  });
}

// Update values
function updateValues() {
  $('#x').html(
    Math.round((x += 0.1) * 10000) / 10000
  );
  $('#y').html(y += sign);

  post();
}

// Start/pause data generation
$("#play").click(function() {
  if (timer !== null) {
    clearInterval(timer);
    timer = null;

    $('#play').val('Start');
  } else {
    timer = setInterval(function() {
      updateValues();
    }, interval);

    $('#play').val('Pause');
  }
});

// Reset
$("#reset").click(function() {
  x = y = 0;

  $('#x').html(0);
  $('#y').html(0);
});

// Toggle data trend i.e. positive, negative
$("#trend").click(function() {
  sign *= -1;

  $('#trend').val('Trend (' + (sign > 0 ? '+' : '-') + ')');
});
