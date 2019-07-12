const user = require('../util/user.js');

describe('testing user interaction', () => {
    test('test add, delete and get user', () => {

        let udata = user.addUser(123, "testUser1", "test Room")

        expect(udata.userName).toBe("testuser1")
        expect(udata.roomName).toBe("test room")

        let udata2 = user.addUser(125, "testUser1", "test Room")
        expect(udata2).toBe(udata)

        let udata3 = user.addUser(125, "testuser1", "test Room")
        expect(udata3).toBe(udata)

        let udata4 = user.addUser(125, "Testuser1", "Test room")
        expect(udata4).toBe(udata)

        expect(user.getUser(125)).toBe(udata)
        expect(user.getUser(123)).toBe(udata)

        expect(user.removeUser(123)).toBe(udata)

        expect(user.getUser(125)).toBe(udata)
        expect(user.getUser(123)).toBeUndefined()

        expect(user.removeUser(125)).toBe(udata)

        expect(user.getUser(125)).toBeUndefined()
        expect(user.getUser(123)).toBeUndefined()
    })

    test('test bad input for add user', () => {
        expect(() => {
            user.addUser(10, null, "test")
        }).toThrow()

        expect(() => {
            user.addUser(10, "Test", null)
        }).toThrow()
    });

    test('test users', () => {
        let users = user.getUsersInRoom("test")
        expect(users).toHaveLength(0)

        let uData = user.addUser(125, "Testuser1", "test")
        users = user.getUsersInRoom("test")

        expect(users).toHaveLength(1)
        expect(users).toContain(uData)

        let uData2 = user.addUser(126, "Testuser2", "TesT")
        users = user.getUsersInRoom("test")

        expect(users).toHaveLength(2)
        expect(users).toContain(uData)
        expect(users).toContain(uData2)

        let uData3 = user.addUser(126, "Testuser2", "TesT2")
        users = user.getUsersInRoom("test")
        let users2 = user.getUsersInRoom("test2")
        
        expect(users).toHaveLength(2)
        expect(users).toContain(uData)
        expect(users).toContain(uData2)
        expect(users2).toContain(uData3)

        expect(() => {
            user.getUsersInRoom()
        }).toThrow()
    });
})