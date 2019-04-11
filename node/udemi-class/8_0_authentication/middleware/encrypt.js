'use strict';

const bcrypt = require('bcryptjs');

const encrypt = async (password) => {
    try {
        return await bcrypt.hash(password, 8);
    } catch (e) {
        throw e;
    }
}

/*
Compare the provided password with hashed version of one
*/
const match = async (password, masterPassword) => {
    try {
       return await bcrypt.compare(password, masterPassword);
    } catch (e) {
        throw e;
    }
}

module.exports = Object.assign({}, {
    encrypt,
    match
});