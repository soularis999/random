'use strict';

const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/TodoApp');

var Todo = mongoose.model('Todo', {
    text: {
	type: String,
	required: true,
	minLength: 1,
	trim: true
    },
    completed: {
	type: Boolean,
	default: false
    },
    completedAt: {
	type: Number,
	default: null
    }
});

async function doSave(todoText, callback, error) {
    try {
	var todo = new Todo({
	    text: todoText
	});
	var result = await todo.save();
	console.log(`Saved todo ${todo}`);
	callback(result);
    } catch (e) {
	console.log(`Error in save todo ${todo}`, e);
	error(e);
    }
}

async function doGetAll(callback, error) {
    try {
	var result = await Todo.find();
	callback(result);
    } catch(e) {
	console.log("Error in getting todo", e);
	error(e);
    }
}

async function doGet(id, callback, error) {
    try {
	var result = await Todo.findById(id);
	callback(result);
    } catch(e) {
	console.log("Error in getting todo", e);
	error(e);
    }
}

async function doDelete(id, callback, error) {
    try {
	var result = await Todo.findByIdAndRemove(id);
	callback(result);
    } catch(e) {
	console.log("Error in deleting todo", e);
	error(e);
    }
}


module.exports = Object.assign({}, {Todo, doDelete, doGet, doGetAll, doSave});
