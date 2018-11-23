const util = require('./util');

describe('Util tests', () => {
    test('should add two numbers', () => {
	expect(util.add(33, 11)).toBe(44);
    });

    test('async add two numbers', (done) => {
	util.addAsync(4,3,(sum) => {
	    expect(sum).toBe(7);
	    done();
	});
    });
});

const request = require('supertest');
var app = require('./server').app;

test('express get method', (done) => {
    request(app).
	get('/').
	expect(200).
	expect('Hello').
	end(done);
});

test('express get method that fails', (done) => {
    request(app).
	get('/test').
	expect(404).
	end(done);
});

test('express get method for user', (done) => {
    request(app).
	get('/users').
	expect(200).
	expect((resp) => {
	    expect(resp.body).toContainEqual({
		name: "test1",
		age: 123
	    });
	}).
	end(done);
});


