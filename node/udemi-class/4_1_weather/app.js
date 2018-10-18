const yargs = require('yargs');
const op = require('./process');
const op2 = require('./process2');
const op3 = require('./process_axios');

const arg = yargs.options({
    a: {
	demand: true,
	alias: 'address',
	describe: 'Address to fetch weather for',
	string: true
    }
}).help().alias('help','h').argv;


op.getAddress(arg.a, (data) => {
    console.log(JSON.stringify(data.results[0].providedLocation, undefined, 2));
    console.log(`Latitude:p ${data.results[0].locations[0].latLng.lat}`);
    console.log(`Longtitude: ${data.results[0].locations[0].latLng.lng}`);

    op.getWeather(data.results[0].locations[0].latLng.lat,
		  data.results[0].locations[0].latLng.lng,
		  (body) => {
		      	console.log(`Weather: ${body.currently.temperature}`);
		  });
});

op2.getAddress(arg.a)
    .then((data) => {
	return op2.getWeather(
	    data.results[0].locations[0].latLng.lat,
	    data.results[0].locations[0].latLng.lng);
    }, (error) => {
	console.log(error);
    })
    .then((data) => {
	console.log(`Weather: ${data.currently.temperature}`);
    }, (error) => {
	console.log(error);
    });

op3.getAddress(arg.a)
    .then((response) => {
	return op3.getWeather(
	    response.data.results[0].locations[0].latLng.lat,
	    response.data.results[0].locations[0].latLng.lng);
    })
    .then((response) => {
	console.log(`Weather: ${JSON.stringify(response.data.currently.temperature)}`);
    })
    .catch((error) => {
	console.log(`ERROR: ${error}`);
    });

function censor(censor) {
  var i = 0;

  return function(key, value) {
    if(i !== 0 && typeof(censor) === 'object' && typeof(value) == 'object' && censor == value) 
      return '[Circular]'; 

    if(i >= 29) // seems to be a harded maximum of 30 serialized objects?
      return '[Unknown]';

    ++i; // so we know we aren't using the original object anymore

    return value;  
  };
}
