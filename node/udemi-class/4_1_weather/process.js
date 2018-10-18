const request = require('request');

/**
 * The key that need to be defined in envvironment
 */
var MAP_QUEST_KEY=process.env.MAP_QUEST_KEY;
var DARK_SKY_KEY=process.env.DARK_SKY_KEY;

var getAddress = (address, callback) => {
    request({
	url: `http://www.mapquestapi.com/geocoding/v1/address?key=${MAP_QUEST_KEY}&location=${encodeURIComponent(address)}`,
	json: true
    }, (error, response, body) => {
	if (error) {
	    console.log(error);
        } else if(body.info.statuscode == 400) {
	    console.log("address not found");
	} else {
	    try {
		callback(body);
	    } catch (e) {
		console.log(`Error processing: ${JSON.stringify(body)}, ${e}`);
	    }
	}
    });
};

var getWeather = (latitude, longtitude, callback) => {
    request({
	url: `https://api.darksky.net/forecast/${DARK_SKY_KEY}/${latitude},${longtitude}`,
	json: true,
    }, (error, response, body) => {
	if(error || 200 !== response.statusCode) {
	    console.log(`Error: ${error}`);
	    return;
	}
	callback(body);
    });
};

module.exports = {
    getAddress,
    getWeather
};
