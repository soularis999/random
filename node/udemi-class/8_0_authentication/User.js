'use strict';

const mongoose = require("mongoose")
const validator = require("validator")

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/TodoApp');

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

userSchema.pre('save', async function(next) {
    console.log(`saving ${this}`)
    next()
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

async function doUpdate(id, name=null, password=null, email=null) {
    try {
        var user = User.findById(id);
        if(name) {
            user.name = name;
        }
        if(password) {
            user.password = password
        }
        if(email) {
            user.email = email
        }
        
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
        return await User.findById(id);
    } catch (e) {
        console.log("Error in getting user", e);
        throw e;
    }
}

async function doDelete(id) {
    try {
        return await User.findByIdAndRemove(id);
    } catch (e) {
        console.log("Error in deleting user", e);
        throw e;
    }
}


module.exports = Object.assign({}, { doDelete, doGet, doGetAll, doSave });


