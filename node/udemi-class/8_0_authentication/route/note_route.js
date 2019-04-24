'use strict';

const express = require('express');

const { doAddTask, doUpdateTask, doDeleteTask} = require('../User');
const {authHook} = require('../middleware/auth');

const router = express.Router();

router.post('/', authHook, async (req, res) => {
    const user = req.app.user;
	try {
		const name = req.body.name;
		const value = req.body.value;

		const user = await doAddTask(user, {name, value});
		res.send(user);
	} catch (e) {
		res.status(400).send(e);
	}
});

module.exports = router;