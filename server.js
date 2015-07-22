/*
  CORRELATION ENGINE
  server.js

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 17 Apr 2015
*/

// Express JS related
var express = require('express'),
  app = express(),
  bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({
  extended: true
}));

// Postgres related
var pg = require('pg'),
  conString = "postgres://USER:PASSWORD@localhost:5432/CE",
  CLIENT = new pg.Client(conString);

// Directories
var html_dir = './html/',
  js_dir = './js/',
  css_dir = './css/';

var path = require('path');
app.use(express.static(path.join(__dirname, 'js')));
app.use(express.static(path.join(__dirname, 'css')));

// Socket
var http = require("http"),
  io = require('socket.io')(http);

// Main page
app.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, '/html/index.html'));
});

// Send
app.get('/send', function(req, res) {
  res.sendFile(path.join(__dirname, '/html/send.html'));
});

// Exit handle
process.stdin.resume(); //so the program will not close instantly

function exitHandler(options, err) {
  if (options.cleanup) {
    console.log('Closing DB connection ...');
    CLIENT.end();
  }

  if (err) {
    console.log(err.stack);
  }

  if (options.exit) {
    process.exit();
  }
}

process.on('exit', exitHandler.bind(null, {
  cleanup: true
})); //do something when app is closing

process.on('SIGINT', exitHandler.bind(null, {
  exit: true
})); //catches ctrl+c event

process.on('uncaughtException', exitHandler.bind(null, {
  exit: true
})); //catches uncaught exceptions

// Listener
var server = app.listen(3000, function() {
  console.log('Initiating DB connection ...');
  CLIENT.connect(function(err) {
    if (err) {
      return console.error('could not connect to postgres', err);
    }
  });

  console.log('Listening on port %d', server.address().port);
});


io.listen(server);

io.on('connection', function(socket) {
  // Outgoing: Initial data
  CLIENT.query('SELECT n,x,y,r,r_m,r_h FROM schema_ce.corr_xy WHERE n>0 ORDER BY n;', function(err, result) {
    if (err) {
      return console.error('error running query', err);
    }

    if (result.rows.length > 0) {
      socket.emit('out', {
        'time': (new Date()).toLocaleString(),
        'data': JSON.stringify(result.rows)
      });
    }
  });

  // Outgoing: Incremental data updates
  pg.connect(conString, function(err, client) {
    if (err) {
      console.log(err);
    }

    client.on('notification', function(msg) {
      console.log(msg.payload);
      socket.emit('out', {
        'time': (new Date()).toLocaleString(),
        'data2': msg.payload
      });
    });
    var query = client.query("LISTEN watchers");
  });

  // Incoming data
  socket.on('in', function(data) {
    var X = data.x,
      Y = data.y;

    if (isFinite(X) && isFinite(Y)) {
      CLIENT.query('INSERT INTO schema_ce.corr_xy (x, y) VALUES (' + X + ', ' + Y + ');', function(err, result) {
        if (err) {
          return console.error('error running query', err);
        }
      });
    } else {
      console.log("[Socket] invalid input");
    }
  });
});
