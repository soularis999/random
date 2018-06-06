
const fs = require('fs');
const _ = require('lodash');

const notes = require('./notes');

var command = process.argv[2];
console.log("Command: ", command);

switch(command) {
  case "list":
    console.log("listing");
    break;
  case "read":
    console.log("reading");
    break;
  case "add":
    console.log("adding");
    break;
  default:
    console.log("ERROR");
}
