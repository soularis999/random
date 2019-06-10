'use strict';

const express = require('express');

const { doAddNote, doUpdateNote, doDeleteNote, doCompleteNote} = require('../User');
const {authHook} = require('../middleware/auth');

const router = express.Router();

// note?completed=true
// note?limit=10&skip=10
router.get('/', authHook, async (req, res) => {
	const user = req.app.user;
	try {
		let results = user.notes;
		let completed = req.query.completed
		if(undefined !== completed) {
			completed = "true" === completed;
			results = user.notes.filter(note => note.completed == completed); 
		}

		let skip = req.query.skip;
		let limit = req.query.limit;
		if(undefined === skip) {
			skip = 0;
		} else {
			skip = parseInt(skip);
		}

		if(undefined === limit) {
			limit = results.length;
		} else {
			limit = skip + parseInt(limit);
		}

		results = results.slice(skip, limit);
		res.send(results);
	} catch (e) {
		console.log(e);
		res.status(400).send(e);
	}
});

router.post('/', authHook, async (req, res) => {
	const user = req.app.user;
	try {
		const note_name = req.body.note_name;
		const note_text = req.body.note_text;
		const result = await doAddNote(user, {note_name, note_text});
		res.send(result);
	} catch (e) {
		console.log(e);
		res.status(400).send(e);
	}
});

router.post('/complete/:id', authHook, async (req, res) => {
	const user = req.app.user;
	const noteId = req.params.id;
	try {
		const result = await doCompleteNote(user, noteId);
		res.send(result);
	} catch (e) {
		console.log(e);
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