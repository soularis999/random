const NodeCache = require( "node-cache" )
const myCache = new NodeCache( { stdTTL: 100, checkperiod: 120 } )
const uuidv4 = require('uuid/v4')

myCache.on("expired", (key, value) => {
    console.log(`Cache expired ${key}, ${JSON.stringify(value)}`)

    let roomData = myCache.get(value.roomName)
    if(roomData) {
        const index = roomData.findIndex((thisId) => thisId === key);
        if(-1 === index) {
            console.log(`No id for existing message ${roomData} , ${key}. Moving on.`)
        } else {
            roomData.splice(index, 1)
        }
        let result = myCache.set(value.roomName, roomData, 0)
        if(!result) {
            console.log(`Could not save room data back after expiration ${roomName} ${roomData}.`)
        }
    }
});

const getStoredMessages = async (roomName) => {
    let data = []
    let roomData = myCache.get(roomName)
    if(!roomData) {
        return data
    }

    for(var i = roomData.length - 1; i >=0; i--) {
        let message = myCache.get(roomData[i]);
        if(message) {
            data.push(message)
        }
    }
    return data
}

const generateDataMessage = async (data, user) => {
    let id = uuidv4();
    let message = {
        id,
        roomName: user.roomName,
        userName: user.userName,
        message: data.message,
        createDate: new Date().getTime(),
        loc: data.loc
    }
    let roomData = await myCache.get(user.roomName)
    if(!roomData) {
        roomData = []
    }
    roomData.push(id);

    let result = myCache.set(id, message)
    if(!result) {
        throw Error("Could not save message!")
    }

    result = await myCache.set(user.roomName, roomData, 0)
    if(!result) {
        throw Error("Could not save message!")
    }

    return message
}

const _generateTextMessage = (message) => {
    return {
        message,
        createDate: new Date().getTime()
    }
}

const generateNewUserWelcomeMessage = (user) => {
    return _generateTextMessage(`Welcome ${user.userName}!`)
}

const generateNewUserNotificationMessage = (user) => {
    return _generateTextMessage(`A new user ${user.userName} joined ${user.roomName}`)
}

const generateUserLeftMessage = (user) => {
    return _generateTextMessage(`A user ${user.userName} left ${user.roomName}`)
}

const genearateProfaneMessage = (user) => {
    return _generateTextMessage("Profane message not allowed!")
}


module.exports = Object.assign({}, {
    generateDataMessage,
    getStoredMessages,
    genearateProfaneMessage,
    generateNewUserWelcomeMessage,
    generateNewUserNotificationMessage,
    generateUserLeftMessage
});
