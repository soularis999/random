var asyncAdd = (a, b) => {
    return new Promise((resolve, reject) => {
	setTimeout(() => {
	    if(typeof a === 'number' && typeof b === 'number') {
		console.log(b);
		resolve(a + b);
	    } else {
		reject('Arguments must be numbers');
	    }
	}, 1500);
    });
};

var somePromise = new Promise((resolve, reject) => {
    setTimeout(() => {
	reject("No promise");
    }, 2500);
});

somePromise.then((message) => {
    console.log('Success', message);
}, (error) => {
    console.log("Error", error);
});

asyncAdd( 5, 7).then((result) => {
    console.log(`Result is ${result}`);
});
