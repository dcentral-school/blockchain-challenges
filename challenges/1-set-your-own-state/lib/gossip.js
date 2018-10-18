const os = require('os');
const colors = require('colors');
const { updateState, renderState, sample } = require('./helpers');
const fs = require('fs');

// Get your local private IP
var ifaces = os.networkInterfaces();

const iface = Object.values(ifaces)
.map((faces) => faces.find(({family, internal}) => 'IPv4' === family && !internal))
.find((face) => face);

const HOST = iface ? iface.address : '127.0.0.1';

// Declare the State hash and set first value
const STATE = new Object();

const BANDS = fs.readFileSync("bands.txt", "utf8").split('\n').filter((band) => band);
let favoriteBand = sample(BANDS);
let versionNumber = 0
console.log(`My favorite band, is ${favoriteBand.green}!`);

STATE[HOST] = [favoriteBand, versionNumber];

setInterval(() => {
  // TODO
  // Every 8 seconds change your own state to a new favorite band (don't forget to print something fun on the terminal)

  favoriteBand = sample(BANDS);
  versionNumber += 1;
  STATE[HOST] = [favoriteBand, versionNumber];
}, 8000);


setInterval(() => {
  renderState(STATE);
}, 3000);
