const colors = require('colors');

function sample(array) {
  return array[Math.floor(Math.random()*array.length)];
}


function renderState(state) {
  console.log('-------------------------------------------');
  Object.keys(state).sort().forEach((host) => {
    const band = state[host] && state[host][0];
    if (band) {
      console.log(`${host.green} currently likes ${band.yellow}`);
    }
  });
  console.log('-------------------------------------------');
}


function updateState(newState, state) {
  Object.keys(newState).forEach((host) => {
    if (!host) { return; }

    if (newState[host] && newState[host].length > 0 && newState[host].every((el) => el)) {
      state[host] = (!state[host] || newState[host][1] >= state[host][1]) ? newState[host]: state[host];
    } else {
      state[host] = state[host] || [];
    }
  })
}

module.exports = {sample, renderState, updateState};
