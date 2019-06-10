'use strict';

const express = require('express');

const app = express();
// defines location of static html files                                                             
app.use(express.static(__dirname + '/static')); 

module.exports = app;