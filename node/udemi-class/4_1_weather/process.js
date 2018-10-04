var process = (data) => {
    console.log(JSON.stringify(data.results[0].providedLocation, undefined, 2));
    console.log(`Latitude: ${data.results[0].locations[0].latLng.lat}`);
    console.log(`Longtitude: ${data.results[0].locations[0].latLng.lng}`);
};

module.exports = {
    process
}
