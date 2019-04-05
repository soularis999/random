'use strict';

const bcrypt = require('bcryptjs');
const mongoose = require("mongoose")
const validator = require("validator")

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
    }
})

/*
Middleware to intercept the data on save
can also do validate, remove
*/
userSchema.pre('save', async function (next) {
    const user = this;
    try {
        if (user.isModified('password')) {
            const result = await bcrypt.hash(user.password, 8);
            user.password = result;
        }
        next()
    } catch (e) {
        console.log(`Error setting the hash password on user ${user} ${e}`);
        throw e;
    }
})
const User = mongoose.model('User', userSchema)


async function doSave(name, password, email) {
    try {
        var user = new User({
            "name": name,
            "password": password,
            "email": email
        });
        var result = await user.save();
        console.log(`Saved user ${user.name}`);
        return result
    } catch (e) {
        console.log(`Error in save user ${user.name}`, e);
        throw e;
    }
}

/*
given id and allowed data to be updated the method will update values that are provided and
will return the new, updated structure
Allowed fields: ['name', 'email', 'password']
 */
async function doUpdate(id, data) {
    const updates = Object.keys(data);
    const isAvailableUpdates = updates.every((update) => allowedUpdated.includes(update));

    if (!isAvailableUpdates) {
        throw new Error(`Some fields are not allowed to be updated ${data}`);
    }

    try {
        const user = await doGet(id);
        updates.forEach((update) => {
            user[update] = data[update];
        });

        var result = await user.save();
        console.log(`Saved user ${user.name}`);
        return result
    } catch (e) {
        console.log(`Error in save user ${user.name}`, e);
        throw e;
    }
}

async function doGetAll() {
    try {
        var result = await User.find();
        return result;
    } catch (e) {
        console.log("Error in getting user", e);
        throw e;
    }
}

async function doGet(id) {
    try {
        var result = await User.findById(id);
        return result;
    } catch (e) {
        console.log("Error in getting user", e);
        throw e;
    }
}

async function doDelete(id) {
    try {
        var result = await User.findByIdAndRemove(id);
        return result;
    } catch (e) {
        console.log("Error in deleting user", e);
        throw e;
    }
}


module.exports = Object.assign({}, { doDelete, doGet, doGetAll, doSave, doUpdate });


