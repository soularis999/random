from datetime import datetime 
import string 
import random
import logging

FORMAT = "%(asctime)-15s %(clientip)s %(user)-8s %(message)s"
logging.basicConfig(format=FORMAT, level="DEBUG")
log = logging.getLogger()

""" tree class to simulate the tree functionality """
class Tree:
 
 def __init__(self, value):
   self.value = value
   self.leftNode = None
   self.rightNode = None
 
 def getValue(self):
   return self.value
   
 def getLeftNode(self):
   return self.leftNode
 
 def setLeftNode(self, leftNode):
   self.leftNode = leftNode
 
 def getRightNode(self):
   return self.rightNode
  
 def setRightNode(self, rightNode):
   self.rightNode = rightNode
   


""" First calculation where we iterate over both arrays and
check wich item in first array is not in second array """
def cal1(list1, list2):
  if list1 == None or list2 == None: return []
  
  newList = [];
  for x in list1:
    flag = True
    for z in list2:
      if x == z:
        flag = False
        break
        
    if flag == True: newList.append(x)
  
  return newList

""" Second calculation where we create a tree out of the second list
and traverse the tree to find if items in list 1 are in tree """
def cal2(list1, list2):
  if list1 == None or list2 == None: return []
  
  newList = [];
  root = toTree(list2)
  for item in list1:
    if isInTree(item, root) == False:
      newList.append(item)
      log.debug("returned false for " + "%i"%(item))
    else:
      log.debug("returned true for " + "%i"%(item))
  
  return newList

""" Third calculation where we create a hashtable out of list 2 and
check if items in list 1 are in hash table """
def cal3(list1, list2):
  if list1 == None or list2 == None: return []
  
  newList = []
  numList = {};
  for item in list2:
    numList[item] = item

  log.debug(numList)
  
  for i in list1:
    if i not in numList:
      newList.append(i)
      
  return newList




def toTree(lst):
  if lst == None or len(lst) == 0: return None
  root = Tree(lst[0])
  for i in range(len(lst)):
    if(i > 0):
      doTraverce(lst[i], root)

  toString(root)
  return root
  
def doTraverce(item, root):
  if(item == None or root == None): return
  if(root.getValue() >= item):
    if(root.getLeftNode() == None):
      root.setLeftNode(Tree(item))
    else:
      doTraverce(item, root.getLeftNode())
  else:
    if(root.getRightNode() == None):
      root.setRightNode(Tree(item))
    else:
      doTraverce(item, root.getRightNode())
      
def toString(tree, count=0, name="center"):
  if tree == None: return
  toString(tree.getLeftNode(), count+1, "left")
  log.debug("Value: %i with id: %i and name: %s"%(tree.getValue(), count, name))
  toString(tree.getRightNode(), count+1, "right")
  
def isInTree(item, root):
  if item == None:
    log.debug("Item is null")
    return False
    
  if root == None:
    log.debug("Item %i and root null" % (item))
    return False
    
  log.debug("Item %i and root %i" % (item, root.getValue()))
  
  if(root.getValue() == item): return True
  elif(root.getValue() > item):
      return isInTree(item, root.getLeftNode())
  else:
      return isInTree(item, root.getRightNode())
 




NUM_ITEMS = 10000
NUM_ITEMS_LESS = 20

if __name__ == "__main__":
  list1 = []
  list2 = []
  ct = 0
  for i in range(NUM_ITEMS):
    it = random.randint(1, 1000000)
    list1.append(it);
    if(ct < NUM_ITEMS-NUM_ITEMS_LESS):
      list2.append(it)
    ct = ct + 1
    
  start = datetime.now().microsecond
  list3 = cal1(list1, list2)
  print "List: %s; time takes: %i"%(",".join( map( str, list3 ) ), (datetime.now().microsecond - start))
  
  start = datetime.now().microsecond
  list3 = cal2(list1, list2)
  print "List: %s; time takes: %i"%(",".join( map( str, list3 ) ), (datetime.now().microsecond - start))

  start = datetime.now().microsecond
  print start
  list3 = cal3(list1, list2)
  print "List: %s; time takes: %i"%(",".join( map( str, list3 ) ), (datetime.now().microsecond - start))