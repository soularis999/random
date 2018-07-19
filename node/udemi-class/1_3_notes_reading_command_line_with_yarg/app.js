/*********************
 * To run node app.js <task: list, read, add>
 * for add use params --title "title" --body "body"
 *********************/

const fs = require('fs');
const _ = require('lodash');
const yargs = require('yargs');
const notes = require('./notes');

const argv = yargs.argv;
console.log("yargs, ", argv)
const command = argv._[0];
console.log("command ", command);

switch(command) {
  case "list":
    console.log(notes.getNoteTitles());
    break;
  case "read":
    notes.getNote(argv.title);
    break;
  case "add":
    notes.addNote(argv.title, argv.body);
    break;
  case "remove":
    notes.removeNote(argv.title);
    break;
  default:
    console.log("ERROR");
}
