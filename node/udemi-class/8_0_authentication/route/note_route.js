'use strict';

const express = require('express');

const { doAddNote, doUpdateNote, doDeleteNote} = require('../User');
const {authHook} = require('../middleware/auth');

const router = express.Router();

router.get('/', authHook, async (req, res) => {
	const user = req.app.user;
	try {
		const results = user.notes;
		const completed = req.query.completed
		if(undefined !== completed) {
			completed = "true" === completed;
			results = user.notes.filter(note => note.completed == completed); 
		}
		res.send(results);
	} catch (e) {
		res.status(400).send(e);
	}
});

router.post('/', authHook, async (req, res) => {
	const user = req.app.user;
	try {
		const name = req.body.name;
		const value = req.body.value;
		const result = await doAddNote(user, {name, value});
		res.send(result);
	} catch (e) {
		res.status(400).send(e);
	}
});

router.patch('/', authHook, async (req, res) => {
	const user = req.app.user;
	try {
		const id = req.body.id;
		let data = {}
		if(req.body.note_name) {
			data["note_name"] = req.body.note_name;
		}
		if(req.body.note_text) {
			data["note_text"] = req.body.note_text;
		}
		const result = await doUpdateNote(user, id, data);
		res.send(result);
	} catch (e) {
		res.status(400).send(e);
	}
});

router.delete('/', authHook, async (req, res) => {
	const user = req.app.user;
	try {
		const id = req.body.id;
		const result = await doDeleteNote(user, id);
		res.send(result);
	} catch (e) {
		res.status(400).send(e);
	}
});

module.exports = router;