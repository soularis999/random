const express = require('express');
const hbs = require('hbs');

var app = express();

// will register directory where the partial templates hbs files will be
// located. The partial templates will be reused by main pages
hbs.registerPartials(__dirname + '/views/partials/');

// Defines the view engine to delegate to handlebar
app.set('view engine', 'hbs');
// defines location of static html files
app.use(express.static(__dirname + '/public'));

// the api - to intercept the requests
app.use((req, res, next) => {
    var now = new Date().toString();
    console.log(`before: ${now}: ${req.method} ${req.path}`);
    next();
    console.log(`after: ${now}: ${req.method} ${req.url}`);
});

app.use((req, res, next) => {
    console.log(req.query);
    if(req.query.block) {
	res.render("error.hbs");
    } else {
	next();
    }
});

// Register helpers that will be called during template execution in footer
hbs.registerHelper("getCurrentYear", () => {
    return new Date().getFullYear()
});
// register helper used in header to change the value to upper case
hbs.registerHelper("screamIt", (text) => {
    return text.toUpperCase();
});

// simple html output
app.get('/', (request, response) => {
    response.send("<h1>hello!!!</h1>");
});

// simple json output
app.get('/json', (request, response) => {
    response.send({
	name: "Test",
	value: 123
    });
});

// using templates with handlebar to delegate to about.hbs file in view
app.get('/about', (request, response) => {
    response.render("about.hbs", {
	pageTitle: "About Page"
    });
});

var port = process.env.PORT || 3000;

// listen on port 3000
app.listen(port, () => {
    console.log(`Running on port ${port}`);
});
