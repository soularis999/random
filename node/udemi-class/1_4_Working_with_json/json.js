var obj = {
  name: "test"
};

var strObj = JSON.stringify(obj);
console.log(typeof obj);
console.log(typeof strObj);
console.log(strObj);

var str = '{"name":"test"}';
var obj = JSON.parse(str);
console.log(typeof str);
console.log(typeof obj);
console.log(obj);

const fs = require('fs');

var originalNote = {
  title: 'some title',
  body: 'some body'
};

var str = JSON.stringify(originalNote);
fs.writeFileSync("notes.json", str);

var noteStr = fs.readFileSync("notes.json");
var note = JSON.parse(noteStr);

console.log(note);
