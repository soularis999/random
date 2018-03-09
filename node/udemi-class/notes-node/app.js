console.log("inside app.js");

const fs = require('fs');
const os = require('os');
const notes = require('./notes.js');

// var user = os.userInfo();

// fs.appendFile('greetings.txt', `\nHello ${user.username}, age ${notes.age}`);

// var result = notes.addNote();
// console.log(result);

var result = notes.add(10,5);
console.log("10 + 5 = ", result);


const _ = require('lodash');

console.log("Is true a string", _.isString(true));
console.log('is "Test" a string', _.isString("Test"));

console.log("[2,3,4,5,6,5,4,3,2,1, 'Test'] filtered", _.uniq([2,3,4,5,6,5,4,3,2,1,'Test']));
