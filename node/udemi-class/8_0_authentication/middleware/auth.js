'use strict';


var jwt = require('jsonwebtoken');
var { doGet, doGetByEmail } = require('../User');
var { match } = require('./encrypt');

/*
authorization middleware that is responsible for authorization based on the
header Authorization key
The end result is:
request will have new variable "app". Content of "app": user, token
The failure in authentication will result in 401 error returned back to client
*/
const authHook = async (req, resp, next) => {
    try {
        const token = req.header("Authorization").replace("Bearer ", "")
        console.log(token);
        const decode = jwt.verify(token, "This is an awesome app");
        console.log(decode);
        const user = await doGet(decode._id);
        console.log(`User: ${user}`);

        if (!user || user.tokens.every(tk => tk.token !== token)) {
            throw new Error();
        }

        req.app = {};
        req.app.user = user;
        req.app.token = token;

        next();
    } catch (e) {
        console.log(`Error processing authorization request ${e}`);
        resp.status(401).send({ "error": "Please authenticate" });
    }
}

/*
method is responsible for processing authentication request
*/
const authenticate = async (email, password) => {
    try {
        // get user by email - should be one as we have uniqueness on email
        const user = await doGetByEmail(email);
        if (!user) {
            throw new Error();
        }
        // compare passwords
        const isMatch = await match(password, user.password);
        if (!isMatch) {
            throw new Error();
        }
        // create token
        const token = jwt.sign({ _id: user._id }, "This is an awesome app");
        user.tokens.push({ token });
        await user.save();

        return token;
    } catch (e) {
        console.log(`Unable to login for ${email} : ${e}`);
        throw new Error("Unable to login");
    }
}

async function doRemoveToken(user, token) {
    try {
        console.log(token)
        user.tokens = user.tokens.filter(tk => {
            console.log(tk);
            return tk.token !== token
        });
        await user.save();
    } catch (e) {
        throw e;
    }
}

async function doClearTokens(user) {
    try {
        user.tokens = [];
        await user.save();
    } catch (e) {
        throw e;
    }
}

module.exports = Object.assign({}, {
    authHook, 
    authenticate,  
    doRemoveToken, 
    doClearTokens
});