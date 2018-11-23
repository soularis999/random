
module.exports.add = (num1, num2) => num1 + num2;

module.exports.addAsync = (num1, num2, callback) => {
    setTimeout(() => {
	callback(num1 + num2);
    }, 1000);
};

