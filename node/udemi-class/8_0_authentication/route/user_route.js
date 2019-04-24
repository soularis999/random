'use strict';

const express = require('express');

const { doAdd, doUpdate, doDelete} = require('../User');
const {authHook, authenticate, doRemoveToken, doClearTokens} = require('../middleware/auth');

const router = express.Router();

// POST - save todo
router.post('/', async (req, res) => {
	try {
		console.log("Request body: " + JSON.stringify(req.body));
		const name = req.body.name;
		const password = req.body.password;
		const email = req.body.email;

		const response = await doAdd({name, password, email});
		res.send("OK");
	} catch (e) {
		res.status(400).send(e);
	}
});

router.post('/login', async (req, res) => {
	const email = req.body.email;
	const password = req.body.password;

	try {
		const token = await authenticate(email, password);
		res.send({token});
	} catch (e) {
		res.status(400).send(e);
	}
});


router.post('/logout', authHook, async (req, res) => {
	const user = req.app.user;
	const token = req.app.token;

	try {
		await doRemoveToken(user, token);
		res.send();
	} catch (e) {
		res.status(500).send(e);
	}
});

router.post('/logout/all', authHook, async (req, res) => {
	const user = req.app.user;
	const token = req.app.token;

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
router.get('/', authHook, async (req, res) => {
	try {
		res.send(req.app.user);
	} catch (e) {
		res.status(400).send(e);
	}
});

router.patch('/', authHook, async (req, res) => {
	try {
		const updatedUser = await doUpdate(req.app.user, req.body);
		res.send(updatedUser);
	} catch (e) {
		res.status(400).send(e);
	}
});

router.delete('/', authHook, async (req, res) => {
	try {
		const updatedUser = await doDelete(req.app.user._id)
		res.send("OK");
	} catch (e) {
		res.status(400).send(e);
	}
});

module.exports = router;