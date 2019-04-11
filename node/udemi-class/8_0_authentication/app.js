'use strict';

var express = require('express');
var bp = require('body-parser');

var { doAdd, doUpdate, doDelete} = require('./User');
var {authHook, authenticate, doRemoveToken, doClearTokens} = require('./middleware/auth');

var app = express();

app.use(bp.json());

// POST - save todo
app.post('/user', async (req, res) => {
	try {

		console.log("Request body: " + JSON.stringify(req.body));
		let name = req.body.name;
		let password = req.body.password;
		let email = req.body.email;

		let response = await doAdd({name, password, email});
		res.send("OK");
	} catch (e) {
		res.status(400).send(e);
	}
});

app.post('/user/login', async (req, res) => {
	let email = req.body.email;
	let password = req.body.password;

	try {
		let token = await authenticate(email, password);
		res.send({token});
	} catch (e) {
		res.status(400).send(e);
	}
});


app.post('/user/logout', authHook, async (req, res) => {
	let user = req.app.user;
	let token = req.app.token;

	try {
		await doRemoveToken(user, token);
		res.send();
	} catch (e) {
		res.status(500).send(e);
	}
});

app.post('/user/logout/all', authHook, async (req, res) => {
	let user = req.app.user;
	let token = req.app.token;

	try {
		await doClearTokens(user);
		res.send();
	} catch (e) {
		res.status(500).send(e);
	}
});

/*
Authenticate before continue
*/
app.get('/user', authHook, async (req, res) => {
	try {
		res.send(req.app.user);
	} catch (e) {
		res.status(400).send(e);
	}
});

app.patch('/user', authHook, async (req, res) => {
	try {
		let response = await doUpdate(req.app.user, req.body);
		res.send(response);
	} catch (e) {
		res.status(400).send(e);
	}
});

app.delete('/user', authHook, async (req, res) => {
	try {
		let response = await doDelete(req.app.user._id)
		res.send(response);
	} catch (e) {
		res.status(400).send(e);
	}
});

module.exports = app;
