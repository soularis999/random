const express = require('express');

var app = express();

app.get("/", (req, resp) => {
    resp.send("Hello");
});

app.get("/users", (req, resp) => {
    let users = [];
    users[0] = {name: "test1", age: 123};
    resp.send(users);
});

app.listen(3000);

module.exports.app = app;
