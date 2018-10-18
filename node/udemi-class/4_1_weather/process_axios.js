const axios = require('axios');

/**
 * The key that need to be defined in envvironment
 */
var MAP_QUEST_KEY=process.env.MAP_QUEST_KEY;
var DARK_SKY_KEY=process.env.DARK_SKY_KEY;

var getAddress = (address) => {
    var mapUrl = `http://www.mapquestapi.com/geocoding/v1/address?key=${MAP_QUEST_KEY}&location=${encodeURIComponent(address)}`;
    console.log(mapUrl);
    return axios.get(mapUrl);
};

var getWeather = (latitude, longtitude) => {
    var weatherUrl = `https://api.darksky.net/forecast/${DARK_SKY_KEY}/${latitude},${longtitude}`;
    console.log(weatherUrl);
    return axios.get(weatherUrl);
};

module.exports = {
    getAddress,
    getWeather
};
