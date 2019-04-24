'use strict';

const express = require('express');
const bp = require('body-parser');
const user_route = require('./route/user_route');
const note_route = require('./route/note_route');

const app = express();

app.use(bp.json());
app.use('/user/', user_route);
app.use('/note/', note_route);

module.exports = app;
