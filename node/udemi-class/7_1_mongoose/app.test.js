const request = require('supertest');
const expect = require('expect');
const app = require('./app');
const {Todo} = require('./db/mongoose');

beforeEach(async () => {
    await Todo.deleteMany({});
});


describe('Testing post of todos', () => {
    
    test('post valid todo', async () => {
	var response = await request(app).post("/todos").send({text: "This is a test 123"});
	expect(response.statusCode).toBe(200);
	expect(response.body.text).toBe("This is a test 123");

	var todos = await Todo.find();

	expect(todos.length).toBe(1);
	expect(todos[0].text).toBe("This is a test 123");
    });

    test('post invalid todo', async () => {
	var response = await request(app).post("/todos").send({});
	expect(response.statusCode).toBe(400);
	console.log(`Failed response ${JSON.stringify(response)}`);

	var todos = await Todo.find();
	expect(todos.length).toBe(0);
    });
});

describe('Testing get all of todos', () => {
    test('should get all', async () => {
	await Todo.insertMany([{text: "First item"}, {text: "Second item"}]);
	
	var response = await request(app).get("/todos").send({});
	expect(response.statusCode).toBe(200);
	console.log(response.body);
	expect(response.body.length).toBe(2);
	expect(response.body[0].text).toBe("First item");
	expect(response.body[1].text).toBe("Second item");
    });

    test('should get all from empty', async () => {
	var response = await request(app).get("/todos").send({});
	expect(response.statusCode).toBe(200);
	console.log(response.body);
	expect(response.body.length).toBe(0);
    });
});

describe('Testing get one todos', () => {
    test('should get one', async () => {
	let result = await Todo.insertMany([{text: "First item"}, {text: "Second item"}]);

	var response = await request(app).get(`/todos/${result[0]._id}`).send({});
	expect(response.statusCode).toBe(200);
	/*
	  Had to do this because the _id from mongo is ObjectID object and not a string
	 */
	expect(response.body._id).toEqual(`${result[0]._id}`);
	expect(response.body.text).toEqual(`${result[0].text}`);
    });

    test('should get none for wrong id', async () => {
	let result = await Todo.insertMany([{text: "First item"}, {text: "Second item"}]);

	var response = await request(app).get(`/todos/5c5e0bd13d86d262f5000000`).send({});
	expect(response.statusCode).toBe(404);
	expect(response.body).toEqual({});
    });

    test('should get none for incorrect id format', async () => {
	let result = await Todo.insertMany([{text: "First item"}, {text: "Second item"}]);

	var response = await request(app).get(`/todos/5c5`).send({});
	expect(response.statusCode).toBe(404);
	expect(response.body).toEqual({});
    });
});

describe('Test delete one todo', () => {
    test('should remove todo', async () => {
	let result = await Todo.insertMany([{text: "First item"}, {text: "Second item"}]);
	
	let response = await request(app).delete(`/todos/${result[0]._id}`).send({});
	expect(response.statusCode).toBe(200);
	expect(response.body._id).toEqual(`${result[0]._id}`);
	expect(response.body.text).toEqual(`${result[0].text}`);
    });

    test('should delete none for wrong id', async () => {
	let result = await Todo.insertMany([{text: "First item"}, {text: "Second item"}]);

	var response = await request(app).delete(`/todos/5c5e0bd13d86d262f5000000`).send({});
	expect(response.statusCode).toBe(404);
	expect(response.body).toEqual({});
    });

    test('should delete none for incorrect id format', async () => {
	let result = await Todo.insertMany([{text: "First item"}, {text: "Second item"}]);

	var response = await request(app).delete(`/todos/5c5`).send({});
	expect(response.statusCode).toBe(404);
	expect(response.body).toEqual({});
    });
});
