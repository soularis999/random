'use strict';

const express = require('express');
const bp = require('body-parser');
const user_route = require('./route/user_route');
const note_route = require('./route/note_route');
const multer = require('multer');

const app = express();

const upload = multer({
    dest: 'images'
});

app.use(bp.json());
app.use('/user/', user_route);
app.use('/note/', note_route);

app.post('/upload', upload.single('upload'), (req, res) => {
    res.send();
});

module.exports = app;
