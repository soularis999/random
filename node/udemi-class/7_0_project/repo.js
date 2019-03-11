// repo.js
'use strict';

// repo holding client info
const repo = (client) => {

    const db = client.db('TodoApp');
    const todoCollection = db.collection('Todos');

    // returns all todos
    // {id, todo, expDate}
    // optional expDate filter will let only quering for dates above
    // provided date - usefull for removing expired
    const getAllTodos = (expDate = null) => {
	return new Promise((resolve, error) => {
	    const todos = [];
	    const query = {};
	    if(expDate) {
		query["expDate"] = {
		    $gt: expDate.getTime()
		};
	    }

	    const cursor = todoCollection.find(query);
	    const addTodo = (todo) => {
		todos.push(todo);
	    };
	    const sendTodo = (err) => {
		if (err) {
		    error(new Error(`Error fetching todos: ${err}`));
		}
		resolve(todos);
	    };
	    cursor.forEach(addTodo, sendTodo);
	});
    };

    // add todo
    // Returs: the id of todo
    const addTodo = (todo, expDate) => {
	return new Promise((resolve, error) => {
	    todoCollection.insertOne({
		text:todo,
		completed:false,
		expData: expDate
	    }, (err, result) => {
		if(err) {
		    error(new Error(`Error inserting todos: ${todo}`));
		    return;
		}
		resolve(result);
	    });
	});
    };

    // remove todo by id
    // Return: NA
    const removeTodo = (id) => {
	return new Promise((resolve, error) => {
	    
	});
    };

    return Object.create({
	getAllTodos,
	addTodo,
	removeTodo
    });
};

const connect = (client) => {
    return new Promise((resolve, error) => {
	if(!client) {
	    error(new Error('Could not connect to DB'));
	}
	try {
	    resolve(repo(client));
	} catch(e) {
	    error(new Error('Could not setup DB connection',e));
	}
    });
};

// this only exports a connected repo
module.exports = Object.assign({}, {connect});
