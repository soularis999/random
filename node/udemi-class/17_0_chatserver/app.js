'use strict'

const express = require('express')
const http = require('http')
const socketio = require('socket.io')
const Filter = require('bad-words')
const hbs = require('hbs')
const {
    generateDataMessage,
    getStoredMessages,
    genearateProfaneMessage,
    generateNewUserNotificationMessage, 
    generateNewUserWelcomeMessage,
    generateUserLeftMessage
} = require('./util/message')
const {
    addUser, 
    removeUser, 
    getUser, 
    getUsersInRoom} = require('./util/user')

const app = express()
const server = http.createServer(app)
const sio = socketio(server)

/**
 * connection is a keyword for subscribing to events on connection
 */
sio.on('connection', async (socket) => {
    console.log("New web socket connection")

    socket.on("join", join)
    socket.on("disconnect", disconnect)
    // message submittion
    socket.on("message-request", submitMessage)
});

async function join({userName, roomName}, callback) {
    let id = this.id
    try {
        const user = addUser(id, userName, roomName)
        console.log("user joined", user, id)

        await sio.to(user.roomName).emit("message", generateNewUserNotificationMessage(user))
        await this.join(user.roomName)
        await sio.to(user.roomName).emit("users", {
            roomName: user.roomName,
            users: getUsersInRoom(user.roomName)
        })

        await callback(generateNewUserWelcomeMessage(user))
        
        let messages = await getStoredMessages(user.roomName)
        this.emit('message-replay', messages)
    } catch(e) {
        console.log("ERROR,USER_JOIN,", id, userName, roomName, e);
        return callback({ e })
    }
}

async function disconnect() {
    let id = this.id

    try {
        let user = removeUser(id)
        if(user) {
            await sio.to(user.roomName).emit("message", generateUserLeftMessage(user))
            await sio.to(user.roomName).emit("users", {
                roomName: user.roomName,
                users: getUsersInRoom(user.roomName)
            })
        }
    } catch(e) {
        console.log("ERROR,USER_DISCONNECT", id, e)
    }
}

async function submitMessage(data, callback) {
    try {
        console.log("Submit message: ", data)
        let filter = new Filter()
        if(filter.isProfane(data.message)) {
            return await callback(genearateProfaneMessage())
        }

        let user = getUser(this.id)
        let message = await generateDataMessage(data, user);
        console.log("MESSAGE,",message, user)
        await sio.to(user.roomName).emit("message", message)
        return callback()
    } catch(e) {
        console.log("ERROR,MESSAGE_SUBMIT", data, e);
        return callback({ e })
    }
}

app.use((req, res, next) => {
    if(req.path == "/") {
        res.render("index.hbs")
        return;
    }

    let re = /\/(.*\.hbs)/g
    let result = re.exec(req.path)
    if(!result) {
        next()
        return
    }
    console.log(result)
    res.render(result[1]);
});

// will register directory where the partial templates hbs files will be
// located. The partial templates will be reused by main pages
hbs.registerPartials(__dirname + '/views/partials');

// Defines the view engine to delegate to handlebar
app.set('view engine', 'hbs');

// defines location of static html files                                                             
app.use(express.static(__dirname + '/static'));

module.exports = server;
