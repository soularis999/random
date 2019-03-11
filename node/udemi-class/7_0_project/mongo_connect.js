'use strict';

const MongoClient = require('mongodb');


// here we create the url connection string that the driver needs
const getMongoURL = (options) => {
    const url = options.servers.reduce((prev, cur) => prev + `${cur.ip}:${cur.port},`, 'mongodb://');
    return `${url.substr(0, url.length - 1)}/${options.db}`;
};

// mongoDB function to connect, open and authenticate
const connect = (options) => {
    return new Promise((resolve, error) => {
	MongoClient.connect(getMongoURL(options), (err, client) => {
            if (err) {
		error(new Error('db.error', err));
	    }

	    resolve(client);
	});
    });
};

module.exports = Object.assign({}, {connect});
