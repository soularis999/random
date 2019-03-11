'use strict';

var {Todo} = require('./db/mongoose');
var {ObjectID} = require('mongodb');
var express = require('express');
var bp = require('body-parser');

var app = express();

app.use(bp.json());

// POST - save todo
app.post('/todos', (req, res, done) => {
    var todo = new Todo({
	text: req.body.text
    });
    doSave(todo,
	   (response) => {
	       res.send(response);
	       done();
	   },
	   (error) => {
	       res.status(400).send(error);
	       done();
	   });
});

app.get('/todos', (req, res, done) => {
    doGetAll(
	(response) => {
	    res.send(response);
	    done();
	},
	(error) => {
	    res.status(400).send(error);
	    done();
	});
});

app.get('/todos/:id', (req, res, done) => {
    let id = req.params.id;

    if(!ObjectID.isValid(id)) {
	res.status(404).send();
	done();
	return;
    }
    
    doGet(id,
	(response) => {
	      if(!response) {
		  res.status(404).send();	  
	      } else {
		  res.send(response);
	      }
	      done();
	},
	(error) => {
	    res.status(400).send();
	    done();
	});
});

app.delete('/todos/:id', (req, res, done) => {
    let id = req.params.id;

    if(!ObjectID.isValid(id)) {
	res.status(404).send();
	done();
	return;
    }
    
    doDelete(id,
	(response) => {
	      if(!response) {
		  res.status(404).send();	  
	      } else {
		  res.send(response);
	      }
	      done();
	},
	(error) => {
	    res.status(400).send();
	    done();
	});
});

function doResponse(response, done) {
}

async function doSave(todo, callback, error) {
    try {
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
    

module.exports = app;
