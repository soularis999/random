console.log("inside notes");

var getNoteTitles = () => {
  return "Note titles";
};

var getNote = (title) => {
  console.log("getNote ", title);
  return "Getting note for ", title;
};

var addNote = (title, body) => {
  console.log("addNote ", title, " : ", body);
  return "New note ", title;
};

var removeNote = (title) => {
  console.log("removeNote ", title);
  return "Removed note ", title;
};

module.exports = {
  getNoteTitles,
  getNote,
  addNote,
  removeNote
}
