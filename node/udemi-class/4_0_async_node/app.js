console.log("start");

setTimeout(() => {
	console.log("in timeout 222");
}, 0);



var getUser = (id, callback) => {
	var user = {
		id: id,
		name: 'Test'
	};
	setTimeout(() => {
		callback(user);
	}, 3000);
}

getUser(31, (user) => {
	console.log(user);
});

console.log("end");
