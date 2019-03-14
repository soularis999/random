'use strict';

var {doDelete, doGet, doGetAll, doSave} = require('./db/mongoose');
var {ObjectID} = require('mongodb');
var express = require('express');
var bp = require('body-parser');

var app = express();

app.use(bp.json());

// POST - save todo
app.post('/todos', (req, res, done) => {
    let text = req.body.text;
    doSave(text,
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

module.exports = app;
