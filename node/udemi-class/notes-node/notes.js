console.log("inside notes");

module.exports.addNote = () => {
  console.log("addNote");
  return "New note";
};

module.exports.add = (a, b) => {
  return a + b;
}
