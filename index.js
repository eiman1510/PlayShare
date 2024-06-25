//Wrapper function which node automatically wraps around a file
//(function(exports,require,module,__filename,__dirname){
console.log("Hello World!");
//Node follows non blocking I/o model in which a queue is used to enroll events and handle them hence 
//handling more than one event at a time.
//npm commands:
// npm init which you can create your own package whic is a javascript code library any one could use if they have the packaga
//npm i packagename to install any package from the net also creates a folder of node modules
//exporting object from another file
const c=require('./second');
console.log(c);
//})