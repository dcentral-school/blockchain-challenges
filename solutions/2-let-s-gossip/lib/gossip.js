const os = require('os');
const colors = require('colors');
const { updateState, renderState, sample } = require('./helpers');
const fs = require('fs');
const fetch = require('node-fetch');
const express = require('express');
const bodyParser = require('body-parser')
const app = express();
app.use(bodyParser.json());

// Set same PORT for everyone in Sinatra
const PORT = 1111;

// Get your local private IP
var ifaces = os.networkInterfaces();

const iface = Object.values(ifaces)
.map((faces) => faces.find(({family, internal}) => 'IPv4' === family && !internal))
.find((face) => face);

const HOST = iface ? iface.address : '127.0.0.1';

// Get the first peer from the command line
const PEER_HOST = process.argv[2] || HOST;

// Declare the State hash and set first value
const STATE = new Object();

const BANDS = fs.readFileSync("bands.txt", "utf8").split('\n').filter((band) => band !== '');
let favoriteBand = sample(BANDS);
let versionNumber = 0
console.log(`My favorite band, is ${favoriteBand.green}!`);

STATE[HOST] = [favoriteBand, versionNumber];
STATE[PEER_HOST] = null;

setInterval(() => {
  // TODO
  // Every 8 seconds change your own state to a new favorite band (don't forget to print something fun on the terminal)

  favoriteBand = sample(BANDS);
  versionNumber += 1;
  STATE[HOST] = [favoriteBand, versionNumber];
}, 8000);


setInterval(() => {
  const dupState = Object.assign({}, STATE);
  Object.keys(dupState).forEach((host) => {
    if (host === HOST) { return; }
    console.log(`Fetching update from ${host.green}`);
    fetch(`http://${host}:${PORT}/gossip`, { method: 'POST', body: JSON.stringify(STATE) })
    .then((res) => res.json())
    .then((newState) => {
      console.lgo(newState);
      updateState(newState, STATE);
    })
    .catch((err) => {
      delete STATE[host];
    });
  });
  renderState(STATE);
}, 3000);

app.post('/gossip', function (req, res) {
  // TODO get the JSON body, update the state with it and response the updated state in JSON
  const theirState = req.body;
  updateState(theirState, STATE)
  res.json(STATE);
})

app.listen(PORT);
