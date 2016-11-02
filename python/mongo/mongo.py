#!/usr/bin/env python

import simplejson
import datetime

from pymongo import Connection
from pymongo import ASCENDING, DESCENDING
from multiprocessing import Pool

NUM_RUNS=1
DATABASE = "dtest"
COLLECTION = "dtestcol"
DATE_TIME_INDEX = "date_-1_name_1"

class Holder:
	def __init__(self):
		self.id = 0
		self.name = "test"
		self.createdate = datetime.datetime.utcnow()
		self.items = []
		
	def get_name(self):
		return self.name
		
	def set_name(self, name):
		self.name = name
		
	def get_id(self):
		return self.id
		
	def set_id(self, id):
		self.id = id

	def set_createdate(self, createdate):
		this.createdate = createdate
	
	def get_createdate(self):
		return self.createdate
	
	def set_items(self, items):
		self.items = items
	
	def get_items(self):
		return self.items
	
def getCon():
	#create connection
	c = Connection()
	print c.database_names()
	
	# create database if does not exist
	d = c[DATABASE]
	print d.collection_names()
	
	# create collection - a.k table
	cl = d[COLLECTION]
	
	return (c,cl)
	
def insert(pname):
	(c,cl) = getCon()
	try:
		for i in range(NUM_RUNS):
			id = "insert%s%s"%(pname, i)
			hl = Holder()
			hl.id = id
			hl.name = "Test%s"%(id)
			hl.items = ["aaa","bbb","ccc"]
			
			# create json from doc
			# save is an update and insert at same time
			# if object does not exist - it will insert otherwise update
			# if we know it's insert we should probably use insert so it would not
			# check if id exists
			print cl.insert(toJson(hl))
	finally:
		c.disconnect()
		
def insertandupdate(pname):
	(c,cl) = getCon()
	
	try:
		for i in range(NUM_RUNS):
			id = "insertandupdate%s%s"%(pname, i)
			hl = Holder()
			hl.id = id
			hl.name = "Test%s"%(id)
			hl.items = ["aaa","bbb","ccc"]
			
			# create json from doc
			# save is an update and insert at same time
			# if object does not exist - it will insert otherwise update
			# if we know it's insert we should probably use insert so it would not
			# check if id exists
			print "inserting with ID: %s"%(id)
			id = cl.save(toJson(hl))
			print "Returned ID %s"%(id)
			
			val = cl.find_one({"_id":id})
			print "Found value %s by id %s"%(val, id)
			if val is None:
				raise Exception("value for id %s not found"%(id))
				 
			val["name"] = val["name"] + "aaa"
			cl.save(val)
			
			val = cl.find_one({"_id":id})
			print val
			if val is None:
				raise Exception("value for id %s not found"%(id))
	finally:
		c.disconnect()
		
def remove():
	(c,cl) = getCon()
	try:
		for item in cl.find():
			print "removing %s"%(item)
			cl.remove(item)
			# cl.remove({"_id":item._id})
			
		if cl.find().count() > 0:
			err = "Should have been deleted %s" % (cl.find().count())
			raise Exception(err)
	finally:
		c.disconnect()
		
def setupIndex():
	(c,cl) = getCon()
	
	# get index info for the collection
	print "Index info %s"%(cl.index_information())
	
	if DATE_TIME_INDEX in cl.index_information():
		print "dropping index %s"%(DATE_TIME_INDEX)
		cl.drop_index(DATE_TIME_INDEX)
	
	indexid = cl.create_index([("date", DESCENDING), ("name", ASCENDING)])
	print "Creating index %s"%(indexid)
	
	# get index info for the collection
	print "Index info %s"%(cl.index_information())

def toJson(obj):
	# to create a primary key you can use _id otherwise the _id will be added to object
	return {"_id":obj.id, "name":obj.name, "date":obj.createdate, "items":obj.items}

setupIndex()

pool = Pool(5)
pool.map(insert, ["t1","t2","t3","t4","t5"])

remove()
