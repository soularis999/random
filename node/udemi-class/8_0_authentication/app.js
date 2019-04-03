'use strict';

var express = require('express');
var bp = require('body-parser');
var { ObjectID } = require('mongodb');
var { doDelete, doGet, doGetAll, doSave, doUpdate } = require('./User');

var app = express();

app.use(bp.urlencoded({ extended: true }));
app.use(bp.json());

// POST - save todo
app.post('/user', async (req, res) => {
	try {
		console.log("Request body: " + JSON.stringify(req.body));
		let name = req.body.name;
		let password = req.body.password;
		let email = req.body.email;

		let response = await doSave(name, password, email);
		res.send(response);
	} catch (e) {
		res.status(400).send(e);
	}
});

app.get('/user', async (req, res) => {
	try {
		let response = await doGetAll();
		res.send(response);
	} catch (e) {
		res.status(400).send(e);
	}
});

app.get('/user/:id', async (req, res) => {
	let id = req.params.id;

	if (!ObjectID.isValid(id)) {
		res.status(404).send();
		return;
	}

	try {
		let response = doGet(id);
		if (!response) {
			res.status(404).send();
		} else {
			res.send(response);
		}
	} catch (e) {
		res.status(400).send(e);
	}
});

app.patch('/user/:id', async (req, res) => {
	let updateKeys = Object.keys(req.body);
	let allowed = ["name", "email", "password"]
	let isValid = updateKeys.every(key => allowed.includes(key))
	let id = req.params.id;

	if (!ObjectID.isValid(id) || !isValid) {
		res.status(404).send();
		return;
	}

	try {
		let response = doUpdate(id, 
			name=req.body["name"], 
			password=req.body["password"], 
			email=req.body["email"]);
		if (!response) {
			res.status(404).send();
		} else {
			res.send(response);
		}
	} catch (e) {
		res.status(400).send(e);
	}
});

app.delete('/user/:id', async (req, res, done) => {
	let id = req.params.id;

	if (!ObjectID.isValid(id)) {
		res.status(404).send();
		done();
		return;
	}
	try {
		let response = doDelete(id)
		if (!response) {
			res.status(404).send();
		} else {
			res.send(response);
		}
	} catch (e) {
		res.status(400).send(e);
	}
});


module.exports = app;
