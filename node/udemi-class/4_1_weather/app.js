const request = require('request');
const yargs = require('yargs');
const p = require('./process');

const arg = yargs.options({
    a: {
	demand: true,
	alias: 'address',
	describe: 'Address to fetch weather for',
	string: true
    }
}).help().alias('help','h').argv;


request({
    url: `http://www.mapquestapi.com/geocoding/v1/address?key=HGKAjb6EYFLexIfpySGAmtqMONeeFLQd&location=${encodeURIComponent(arg.a)}`,
    json: true
}, (error, response, body) => {
    if(error) {
	console.log(error);
    } else {
	    p.process(body);
    }
});
