console.log("inside notes");

const fs = require('fs');

/**
 * function returns back the parsed object of array of notes read from file
 */
var fetchNotes = () => {
  try {
    if(fs.existsSync('notes-data.json')) {
      var notesString = fs.readFileSync('notes-data.json');
      return JSON.parse(notesString);
    }
    return [];
  } catch(e) {
    console.log(e);
    return [];
  }
};

/**
 * function saves tbe array of notes in json format to file
 */
var saveNotes = (notes) => {
  try {
    fs.writeFileSync('notes-data.json', JSON.stringify(notes));
  } catch(e) {
    console.log(e);
  }
};

/*
 * function returns the note titles as an array []
 */
var getNoteTitles = () => {
  var notes = fetchNotes();
  return notes.map((note) => note.title);
};

/*
 * Given the title the function returns note if matches exactly
 * othervise returns null
 */
var getNote = (title) => {
  var filtered = fetchNotes().filter(note => note.title === title);
  if(0 == filtered.length) {
    return null;
  }
  return filtered[0];
};
/**
 * The function adds note to the list and returns back the note
 * if note was not added the null will be returned
 */
var addNote = (title, body) => {
  var notes = fetchNotes();
  var note = {title, body};
  var dups = notes.filter((note) => note.title === title);
  if(0 === dups.length) {
    notes.push(note);
    saveNotes(notes);
    return note;
  } else {
    return null;
  }
};
/**
 * The function removes the note from list and returns it back to caller
 */
var removeNote = (title) => {
  var notes = fetchNotes();
  var filtered = notes.filter(note => note.title !== title);
  saveNotes(filtered);
  return notes.filter(note => note.title !== title);
};

module.exports = {
  getNoteTitles,
  getNote,
  addNote,
  removeNote
}
