'use strict';

const mongoose = require("mongoose");
const validator = require("validator");
var { ObjectID } = require("mongodb");

var { encrypt } = require('./middleware/encrypt');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/TodoApp');

const allowedUpdated = ["name", "email", "password"];

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        /*
        will add index to email for uniquiness
        */
        unique: true,
        trim: true,
        lowercase: true,
        validate(value) {
            if (!validator.isEmail(value)) {
                throw new Error("Email is wrong");
            }
        }
    },
    password: {
        type: String,
        required: true,
        trim: true
    },
    tokens: [{
        token: {
            type: String,
            required: true
        }
    }]
})

  /*
Middleware to intercept the data on save
can also do validate, remove

has to be a function so this could be bound to user
*/
userSchema.pre('save', async function (next) {
    const user = this;
    try {
        if (user.isModified('password')) {
            const result = await encrypt(user.password);
            console.log(`Adding aftr password on ${user}`);
            user.password = result;
        }
        next();
    } catch (e) {
        console.log(`Error setting the hash password on user ${user} ${e}`);
        throw e;
    }  
});

const User = mongoose.model('User', userSchema)

/*
Given id return back the user object
*/
async function doGet(id) {
    try {
        return await User.findById(id);
    } catch (e) {
        throw e;
    }
}

async function doGetByEmail(email) {
    try {
        return await User.findOne({ email });
    } catch (e) {
        throw e;
    }
}

/*
given id and allowed data to be saved the method will save values that are provided and
will return the new, updated structure
Allowed fields: ['name', 'email', 'password']
 */
async function doAdd(data) {
    validate(data);
    try {
        var user = new User(data);
        return await user.save();
    } catch (e) {
        throw e;
    }
}
/*
given id and allowed data to be updated the method will update values that are provided and
will return the new, updated structure
Allowed fields: ['name', 'email', 'password']
 */
async function doUpdate(user, data) {
    validate(data);
    try {
        const updates = Object.keys(data);
        updates.forEach((update) => {
            user[update] = data[update];
        });

        if(updates.includes("password")) {
            user.tokens = [];
        }

        console.log("HERER");

        return await user.save();
    } catch (e) {
        throw e;
    }
}


async function doDelete(id) {
    try {
        return await User.findByIdAndRemove(id);
    } catch (e) {
        throw e;
    }
}

function validate(data) {
    const updates = Object.keys(data);
    const isAvailableUpdates = updates.every((update) => allowedUpdated.includes(update));

    if (!isAvailableUpdates) {
        throw new Error(`Some fields are not allowed to be updated ${data}`);
    }
}


module.exports = Object.assign({}, {
    doGet,
    doGetByEmail,
    doAdd,
    doUpdate,
    doDelete
});


