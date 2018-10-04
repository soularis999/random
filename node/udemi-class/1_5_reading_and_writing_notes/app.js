/*********************
 * To run node app.js <task: list, read, add>
 * for add use params --title "title" --body "body"
 *********************/
const fs = require('fs');
const _ = require('lodash');
const yargs = require('yargs');
const notes = require('./notes');

const argv = yargs
  .command('add', 'add note', {
    title: {describe: "title of the note", demand: true, alias: 't'},
    body: {describe: "body of the note", demand: true, alias: 'b'},
  })
  .command('remove', 'remove note', {
    title: {describe: "title of the note", demand: true, alias: 't'},
  })
  .command('list', 'list note titles')
  .command('read', 'read note', {
    title: {describe: "title of the note", demand: true, alias: 't'},
  })
  .help()
  .argv;
// console.log("yargs, ", argv)
const command = argv._[0];
// console.log("command ", command);

switch(command) {
  case "list":
    notes.getNoteTitles().forEach(title => console.log(title));
    break;
  case "read":
    var note = notes.getNote(argv.title);
    if(note) {
      console.log(note);
    } else {
      console.log(`No note found for ${argv.title}`);
    }
    break;
  case "add":
    var note = notes.addNote(argv.title, argv.body);
    if(!note) {
      console.log(`Title ${argv.title} could not be added`);
    } else {
      console.log(`Title ${argv.title} was added`);
    }
    notes.getNoteTitles().forEach(title => console.log(title));
    break;
  case "remove":
    notes.removeNote(argv.title);
    notes.getNoteTitles().forEach(title => console.log(title));
    break;
}
