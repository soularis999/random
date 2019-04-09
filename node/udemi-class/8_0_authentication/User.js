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
            const result = await bcrypt.hash(user.password, 8);
            user.password = result;
        }
        next()
    } catch (e) {
        console.log(`Error setting the hash password on user ${user} ${e}`);
        throw e;
    }
});

/*
The method that can be added right to schema
*/
userSchema.statics.findByCredentials = async (emailVal, passwordVal) => {
    try {
        const user = await User.findOne({ email: emailVal });
        if (!user) {
            throw new Error('Unable to login');
        }

        const isMatch = await bcrypt.compare(passwordVal, user.password);

        if (!isMatch) {
            throw new Error('Unable to login');
        }

        return user;
    } catch (e) {
        throw new Error("Critical error " + e);
    }
};

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
        throw e;
    }
}

async function findByCredentials(email, password) {
    try {
        const user = await User.findByCredentials(email, password);
        return user;
    } catch (e) {
        throw e;
    }
}

async function doSaveToken(user, token) {
    try {
        user.tokens.push({token});
        user.save();
    } catch (e) {
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
        throw e;
    }
}

async function doGetAll() {
    try {
        var result = await User.find();
        return result;
    } catch (e) {
        throw e;
    }
}

async function doGet(id) {
    try {
        var result = await User.findById(id);
        return result;
    } catch (e) {
        throw e;
    }
}

async function doDelete(id) {
    try {
        var result = await User.findByIdAndRemove(id);
        return result;
    } catch (e) {
        throw e;
    }
}


module.exports = Object.assign({}, { 
    doDelete, doGet, doGetAll, doSave, doUpdate, findByCredentials, doSaveToken});


