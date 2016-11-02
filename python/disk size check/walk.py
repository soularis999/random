import os.path
import os

DIR = "c:/"
# half a gig
THRESHOLD = 1024 * 1024 * 512

def getDirSize(dir):
  dir_size = 0
  file_ct = 0
  folder_ct = 0
  
  for (path, dirs, files) in os.walk(dir):
    file_ct += len(files)
    folder_ct += len(dirs)
    
    for file in files:
      try:
        dir_size += os.path.getsize(os.path.join(path, file))
      except WindowsError, info:
        pass
        #print info 
        
  return (dir, dir_size, file_ct, folder_ct)
  
def getListOfDirsOverSize(dir, size):
  list = []
  for mydir in os.listdir(dir):
    mydir = os.path.join(dir, mydir)
    if os.path.isdir(mydir):
      #print size
      dirinfo = getDirSize(mydir)
      if(dirinfo[1] > size):
        list += getListOfDirsOverSize(mydir, size)
      	list.append(dirinfo)
  return list


text = "Dir name:%s : %i Mb"
results = getListOfDirsOverSize(DIR, THRESHOLD)

for val in results:
  print text % (val[0], val[1] / (1024 * 1024))
