'use strict';

const _ = require('lodash');
const yargs = require('yargs');
const prompt = require('prompt');
const repository = require('./repo');
const connect = require('./mongo_connect');

const args = yargs.options({
    s: {
	demand: true,
	alias: 'servers',
	describe: 'Comma delimited list of host/port combinations',
	string:true
    }
}).help().alias('help','h').argv;

args.servers = _.map(_.split(args.servers, ','), function(val) {
    let result = _.split(val, ':');
    return {
	ip: result[0],
	port: result[1]
    };
});
console.log(args.servers);

prompt.start();

async function doList(repo) {
    try {
	const result = await repo.getAllTodos();
	console.log(`Result: ${JSON.stringify(result)}`);
    } catch (e) {
	console.log(e);
    }
    
    doMainPrompt(repo);
}

async function doInsert(todo, expDate, repo) {
    try {
	await repo.addTodo(todo, expDate);
    } catch (e) {
	console.log(e);
    }
    
    doMainPrompt(repo);
}

function insert(repo) {
    var schema = {
	properties: {
	    todo: {
		type: 'string',
		description: "Enter todo",
		required: true
	    },
	    date: {
		type: 'string',
		description: "Enter expiration (mm/dd/yyyy)",
		message: "Has to be equal or greater than today",
		required: true,
		conform: (val) => {
		    var d = new Date(Date.parse(val));
		    var now = new Date();
		    now.setHours(0,0,0,0);
		    
		    console.log(`Now ${now} date ${d}`);
		    return now <= d;
		}
	    }
	}
    };

    prompt.get(schema, (err, result) => {
	doInsert(result.todo, Date.parse(result.date), repo);
    });
}

function doMainPrompt(repo) {
    prompt.get([{name: "action",
		 required: true,
		 description: "Enter action [list, add, remove, q] "
		}],
	(err, result) => {
	    if(err) {
		console.log(`Prompt error: ${err}`);
		doMainPrompt(repo);
	    }

	    switch(result.action){
	    case "list":
		doList(repo);
		break;
	    case "add":
		insert(repo);
		break;
	    case "remove":
		break;
	    case "q":
		process.exit(1);
		// gracefully exit
		break;
	    default:
		console.log(`${result} is not a valid choice`);
		doMainPrompt(repo);
		// error
	    }
    });
}

async function setup() {
    try {
	const client = await connect.connect(args);
	const repo = await repository.connect(client);
	doMainPrompt(repo);
    } catch(e) {
	console.log(`Error establishing connection ${e}`);
    }
}

setup();
