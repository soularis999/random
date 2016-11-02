#!/bin/python

POSITION_FROM=25
POSITION_TO=49
FILE_NAME="C:/tmp/sync"
FILE_NAME_DUP="C:/tmp/sync.dup"
             
if __name__ == "__main__":
  # read all the items to array
  f = open(FILE_NAME, "r")
  dic = {}
  count = 0
  while True:      
    line = f.readline()
    if line == "":
      break
    txt = line[POSITION_FROM:POSITION_TO]
   
    # check if we already used this item before
    if dic.has_key(txt) == False:
      # create array for each item
      dic[txt] = []
    
    dic[txt].append(count)
    
    count += 1
  f.close()

  f = open(FILE_NAME_DUP, "w")
  for key, values in dic.iteritems():
    if len(values) > 1:
      f.write("Item %s dup in positions %s\n" % (key, ",".join(["%s" % el for el in values])))
  
  f.close()
