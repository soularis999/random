'use strinct';

const {MongoClient, ObjectID} = require('mongodb');

MongoClient.connect('mongodb://localhost:27017/TodoApp', (err, client) => {
    if(err) {
	console.log(`Unabe to connect to mongo ${err}`);
	return;
    }
    console.log('Connected to mongo');

    const db = client.db('TodoApp');
    db.collection('Todos').insertOne({
	text: 'Something to do',
	completed: false
    }, (err, result) => {
	if(err) {
	    console.log(`Error writing the item ${err}`);
	    return;
	}
	console.log(JSON.stringify(result));
    });

    db.collection('Users').insertOne({
	name: 'Dmitriy',
	age: 38,
	location: 'Chicago'
    }, (err, result) => {
	if(err) {
	    console.log(`Error writing the item ${err}`);
	    return;
	}
	console.log(JSON.stringify(result));
    });

    db.collection('Todos').find().toArray().then((docs) => {
	console.log('Todos:');
	console.log(JSON.stringify(docs, undefined, 2));
    }, (err) => {
	console.log('Not working', err);
    });

    db.collection('Todos').find({"completed": true}).toArray().then((docs) => {
	console.log(JSON.stringify(docs, undefined, 2));
    });

    // delete many
    db.collection('Todos').deleteMany({text: 'Something to do'}).then(function(result) {
	console.log(result);
    });

    db.collection('Todos').insertOne({
	text: 'Something to do',
	completed: false
    }, (err, result) => {
	if(err) {
	    console.log(`Error writing the item ${err}`);
	    return;
	}
	console.log(JSON.stringify(result));
    });

    // find one and update
    db.collection('Todos').findOneAndUpdate({
	_id: ObjectID("5c110a85e00fbb8e17cae1d5")
    }, {
	$set: {
	    completed: true
	}
    }, {
	returnOriginal: false
    });
    
    // delete one
    db.collection('Todos').deleteOne({text: 'Something to do'}).then(function(result) {
	console.log(result);
    });

    db.collection('Todos').insertOne({
	text: 'Something to do',
	completed: false
    }, (err, result) => {
	if(err) {
	    console.log(`Error writing the item ${err}`);
	    return;
	}
	console.log(JSON.stringify(result));
    });
    
    // find one and delete
    db.collection('Todos').findOneAndDelete({completed: false}).then(function(result) {
	console.log(result);
    });
    
    client.close();
});
