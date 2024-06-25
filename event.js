const EventEmitter = require('node:events');

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter();
myEmitter.on('Waterfall', () => {
  console.log('Turn off the Motor.');
  setTimeout(() => {
    console.log("Again Turn off the Motor!")
  }, 3000);  //3sec wait
});

myEmitter.emit('Waterfall');
myEmitter.emit('Waterfall');