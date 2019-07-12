
const generateDataMessage = (data, user) => {
    return {
        userName: user.userName,
        message: data.message,
        createDate: new Date().getTime(),
        loc: data.loc
    }
}

const generateTextMessage = (message) => {
    return {
        message,
        createDate: new Date().getTime()
    }
}

const generateNewUserWelcomeMessage = (user) => {
    return generateTextMessage(`Welcome ${user.userName}!`)
}

const generateNewUserNotificationMessage = (user) => {
    return generateTextMessage(`A new user ${user.userName} joined ${user.roomName}`)
}

const generateUserLeftMessage = (user) => {
    return generateTextMessage(`A user ${user.userName} left ${user.roomName}`)
}

module.exports = Object.assign({}, {
    generateDataMessage,
    generateTextMessage,
    generateNewUserWelcomeMessage,
    generateNewUserNotificationMessage,
    generateUserLeftMessage
});