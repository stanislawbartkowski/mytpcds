import urllib.request

from util.tablemd import TABLEMD

PAGE="https://github.com/stanislawbartkowski/mytpcds/wiki/TPC-DS-BigData-results.md"

# including space
TABLELABEL="<tablelabel "
TABLE="table"
LISTOFATTRS=[TABLE]

def __lookfor(l,ter) :
   i = -1
   for ch in ter :
      ii = l.find(ch)
      if ii == -1 : continue
      if i == -1 : i = ii
      elif ii < i : i = ii
   return i

def tablefound(l,tablename) :
   i = l.find(TABLELABEL)
   if i == -1 : return None
   # after table marker
   ll = l[i + len(TABLELABEL):]
   # attribute map
   attr = {}
   while True : 
      ll = ll.lstrip()
      if ll == "" : break
      iclose = ll.find('>')
      iend = __lookfor(ll,' =')
      if iend == -1 : break
      # > found
      if iclose != -1 and iclose < iend : break
      # get attribute name
      name = ll[0:iend].lstrip()
      if name == "" : break
      if not name in LISTOFATTRS : raise Exception(name + " : incorrect attribute")
      ll = ll[iend:].lstrip()
      if ll == "" : break
      ieq = ll.find('=')
      if ieq == -1 : break
      ll = ll[ieq+1:].lstrip()
      if ll == "" : break
      if ll[0] == '"' : ll = ll[1:]
      iend = __lookfor(ll,'>"/')
      if iend == -1 : break
      val = ll[:iend]
      if val == "" : break
      # attribute
      attr[name] = val
      ll = ll[iend:].lstrip()
      if ll[0] == '"' : ll=ll[1:]   
      if ll == "" or ll[0] == '>' or ll[0] == '/': break
      if ll[0] == '"' : ll=ll[1:]   
      if ll == "" : break
   if TABLE in attr and attr[TABLE] == tablename: return attr
   return None

class READMD() :

    def __init__(self,lines) :
      self.lines = lines
      self.i = 0

    def __numof(self,l) :
      i = 0
      no = 0
      while l[i:].find('|') != -1 :
         no = no + 1
         l = l[l[i:].find('|')+1:]
      return no

    def __createtable(self,a) :
      firstl = None
      ignore = False
      ta = []
      while True :
         self.i = self.i + 1
         if self.i >= len(self.lines) : break
         l = self.lines[self.i]
         no = self.__numof(l)
         if no > 0 :
            if ignore :
               ignore = False
               continue             
            if firstl == None : 
               firstl = l
               ignore = True
               continue
            ta.append(l)
         else :
            if firstl : break
        
      return TABLEMD(a,firstl,ta)

    def go(self,name) :
      for self.i in range(0,len(self.lines)) :
         l = self.lines[self.i]
         a = tablefound(l,name)
         if a != None : return self.__createtable(a)
      return None
         

def __readmdwiki() :
   response = urllib.request.urlopen(PAGE, timeout = 5)
   data = response.read()     
   return data.decode('utf-8').splitlines()

def readmd(tablename) :
    lines=__readmdwiki()
    C = READMD(lines)
    return C.go(tablename)

