'use strict';

const mongoose = require("mongoose");
const validator = require("validator");
var { ObjectID } = require("mongodb");

var { encrypt } = require('./middleware/encrypt');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/TodoApp');

const allowedUpdated = ["name", "email", "password"];
const allowedNoteUpdated = ["name", "value"];

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
    }],
    notes: [{
        note_name: {
            type: String,
            required: true,
            trim: true
        },
        note_text: {
            type: String
        }
    }]
}, {
    timestamps: true
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
            user.password = result;
        }
        next();
    } catch (e) {
        console.log(`Error setting the hash password on user ${user} ${e}`);
        throw e;
    }  
});

/*
Init hook is the only sync hook in mongoose
*/
userSchema.post('init', (user) => {
    try {
        user.index_of_notes = {};
        user.notes.forEach(note => {
            user.index_of_notes[note._id] = note;
        });
    } catch (e) {
        console.log(`Error formatting user ${user}`);
        throw e;
    } 
});

/*
Exposed on user object - has to be function so that we could get this
Method used by JSON.stringify before sending to client
*/
userSchema.methods.toJSON = function() {
    const user = this;
    const temp = user.toObject();

    delete temp.tokens;
    delete temp.password;
    delete temp.__v;

    return temp;
}

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
        const user = new User(data);
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

async function doAddNote(user, data) {
    console.log(`HERE ${data}`);
    validateNote(data);
    try {
        user.tasks.push({name: data.name, value: data.value});
        const result = await user.save();
        console.log(`IN DO ADD TASK ${user} : ${result}`);
        return user;
    } catch (e) {
        throw e;
    }
}

// async function doUpdateNote(user, id, data) {
//     validateNote(data);
//     try {
//         const tasks = user.tasks.filter(task => task.id === id);
//         if(!tasks || 1 != tasks.length()) {
//             throw new Error('No such task');
//         }

//         updates.forEach((update) => {
//             task[update] = data[update];
//         });
//         await user.save();
//         return user;
//     } catch (e) {
//         throw e;
//     }
// }

// async function doDeleteNote(user, id) {
//     validateNote(data);
//     try {
//         const task = user.tasks.filter(task => task.id === id);
//         if(!task) {
//             throw new Error('No such task');
//         }

//         updates.forEach((update) => {
//             task[update] = data[update];
//         });
//         await user.save();
//         return user;
//     } catch (e) {
//         throw e;
//     }
// }

function validate(data) {
    const updates = Object.keys(data);
    const isAvailableUpdates = updates.every((update) => allowedUpdated.includes(update));

    if (!isAvailableUpdates) {
        throw new Error(`Some fields are not allowed to be updated ${data}`);
    }
}

function validateNote(data) {
    const updates = Object.keys(data);
    const isAvailableUpdates = updates.every((update) => allowedNoteUpdated.includes(update));

    if (!isAvailableUpdates) {
        throw new Error(`Some fields are not allowed to be updated ${data}`);
    }
}


module.exports = Object.assign({}, {
    doGet,
    doGetByEmail,
    doAdd,
    doUpdate,
    doDelete,
    doAddNote,
});


