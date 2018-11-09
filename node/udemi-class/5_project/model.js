const _ = require('lodash');

const model = [
    { group: 'A', single: 4.00, tenRide: 38.00, monthly: 116.00 },
    { group: 'B', single: 4.25, tenRide: 40.50, monthly: 123.25 },
    { group: 'C', single: 5.50, tenRide: 52.25, monthly: 159.50 },
    { group: 'D', single: 6.25, tenRide: 59.50, monthly: 181.25 },
    { group: 'E', single: 6.75, tenRide: 64.25, monthly: 195.75 },
    { group: 'F', single: 7.25, tenRide: 69.00, monthly: 210.25 },
    { group: 'G', single: 7.75, tenRide: 73.75, monthly: 224.75 },
    { group: 'H', single: 8.25, tenRide: 78.50, monthly: 239.25 },
    { group: 'I', single: 9.00, tenRide: 85.50, monthly: 261.00 },
    { group: 'J', single: 9.50, tenRide: 90.25, monthly: 275.50 }
];

var getGroups = () => {
    return _.map(model, (val) => {
	return val.group;
    });
};

var getModel = (group) => {
    return _.find(model, function(data) { return group === data.group; });
};

module.exports = {
    getGroups,
    getModel
};
