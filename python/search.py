#
# text search
#
import sys
import os.path

def showUsage():
	print "Usage: search str_to_search path"

def printFile(file, location):
  print "%s : %s" % (file, ",".join(map(lambda i: "%d" % (i), location)))	
	
def checkFile(str, filename):
  location = None
  count = 1
  f = open(filename, "r")
  while True:
    line = f.readline()
    if line == "":
      break
      
    offset = line.find(str)
    if offset > -1:
      location = (count, offset)
      break
    count = count + 1

  f.close()
  
  if location != None:
  	printFile(filename, location)
  
def checkFiles(arg, dirname, names):
  for filename in names:
    filename = os.path.join(dirname, filename)
    if os.path.isdir(filename):
      continue
    checkFile(arg, filename)
  
if __name__=="__main__":
  if len(sys.argv) < 3:
    showUsage()
    sys.exit(1)
    
  str = sys.argv[1]
  path = sys.argv[2]
  
  if os.path.isdir(path) == False:
		showUsage()
		sys.exit(2)
		
  os.path.walk(path, checkFiles, str)
  
  sys.exit(0)