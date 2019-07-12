const users = []
const idToUser = {}
const userToIDs = {}

const addUser = (id, userName, roomName) => {
    // clean data
    userName = userName.trim().toLowerCase()
    roomName = roomName.trim().toLowerCase()

    if(!userName || !roomName) {
        throw new Error("Username and room are required!")
    }

    let user = users.find((user) => {
        return user.userName === userName && user.roomName == roomName
    })

    if(undefined === user) {
        console.log(`New user for ${userName} and ${roomName}`)
        user = {
            userName, 
            roomName
        }
        users.push(user)
    } else {
        console.log(`Existing user for ${userName} and ${roomName} = ${JSON.stringify(user)}`)
    }

    idToUser[id] = user
    const ids = userToIDs[user]
    if(!ids) {
        userToIDs[user] = [id]
    } else {
        ids.push(id)
    }

    return user
}

const removeUser = (id) => {
    const storedUser = idToUser[id]
    if(!storedUser) {
        return
    }
    delete idToUser[id]

    const ids = userToIDs[storedUser]
    const index = ids.findIndex((thisId) => thisId === id);
    if(-1 === index) {
        console.log(`Something odd, no id for existing user ${storedUser} , ${id}. Moving on.`)
    } else {
        ids.splice(index, 1)
    }

    if(0 == ids.length) {
        const index = users.findIndex((user) => {
            return user.userName === storedUser.userName 
                && user.roomName == storedUser.roomName
        });
        if(-1 === index) {
            return
        }
        users.splice(index, 1)
    }
    return storedUser
}

const getUser = ((id) => {
    return idToUser[id]
})

const getUsersInRoom = ((roomName) => {
    roomName = roomName.trim().toLowerCase()

    if(!roomName) {
        throw new Error("Room is required!")
    }

    return users.filter(user => user.roomName === roomName)
})

module.exports = Object.assign({}, {
    addUser,
    removeUser,
    getUser,
    getUsersInRoom
});