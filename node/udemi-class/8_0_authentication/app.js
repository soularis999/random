'use strict';

var express = require('express');
var bp = require('body-parser');
var jwt = require('jsonwebtoken');
var { ObjectID } = require('mongodb');
var { doDelete, doGet, doGetAll, doSave, doUpdate, findByCredentials, doSaveToken} = require('./User');

var app = express();

app.use(bp.json());

const signFunc = async (userId) => {
	return jwt.sign({_id: userId}, "This is an awesome app");
}

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

app.post('/user/login', async (req, res) => {
	let email = req.body.email;
	let password = req.body.password;

	try {
		const user = await findByCredentials(email, password);
		const token = await signFunc(user.id);
		console.log(token)
		await doSaveToken(user, token);
		res.send({user, token});
	} catch (e) {
		res.status(400).send(e);
	}
})

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
		let response = await doGet(id);
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
	
	let id = req.params.id;
	if (!ObjectID.isValid(id)) {
		res.status(404).send();
		return;
	}

	try {
		let response = await doUpdate(id, req.body);
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
		let response = await doDelete(id)
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
