
ROWSSELECTED="rows selected"
ROWS="rows)"

from enum import Enum

class LINE:

    def __init__(self,l) :
        self.l = l
        self.c = 0
        self.out = []

    def initf(self) :
        self.field = ""

    def addc(self) :
        self.field = self.field + self.cc()
        self.inc()

    def addfield(self) :
        if self.field == "" : self.out.append("NULL")
        else : self.out.append(self.field)
    
    def cc(self) :
        return self.l[self.c]

    def isc(self,ch) :
        return self.cc() == ch

    def iss(self) :
        return self.cc().isspace()

    def istab(self) :
        return self.isc('\t')

    def iseol(self) :
        return self.isc('\n')

    def inc(self) :
        self.c = self.c + 1

    def ignoreonlyspaces(self) :
        while not self.eofline() and self.isc(' ') : self.inc()

    def ignorespaces(self) :
        while not self.eofline() and (self.iss() or self.istab() or self.iseol()) : self.inc()

    def eofline(self) :
        return self.c >= len(self.l)

    def getfieldtotab(self) :
        self.initf()
        while not self.eofline() and not self.istab() : self.addc()
        self.addfield()

    def getfieldtospace(self) :
        self.initf()
        while not self.eofline() and not self.istab() and not self.iss() : self.addc()
        self.addfield()

    def getfieldtopipe(self) :
        self.initf()
        if not self.isc("|") :
          while not self.eofline() and not self.istab() and not self.isc('|') and not self.iseol() : self.addc()
        self.inc()
        self.addfield()

class TYPEF(Enum):
    TOSPACE = 1
    TOTAB = 2
    ALLTOSPACE = 3
    ALLTOPIPE = 4
    ALLTOTAB = 5

class ANSTYPE :
    def __init__(self,headerno,ty,numof):
        self.headerno = headerno
        self.ty = ty
        self.numof = numof

    def transformline(self,ll) :
        ll.ignoreonlyspaces()
        for t in self.ty :
            if t == TYPEF.TOSPACE : ll.getfieldtospace()
            elif t == TYPEF.TOTAB : ll.getfieldtotab()
            elif t == TYPEF.ALLTOSPACE :
                while not ll.eofline() :
                    ll.getfieldtospace()
                    ll.ignorespaces()
            elif t == TYPEF.ALLTOPIPE :
                while not ll.eofline() :
                    ll.getfieldtopipe()
                    ll.ignorespaces()
            elif t == TYPEF.ALLTOTAB :
                while not ll.eofline() :
                    ll.getfieldtotab()
                    ll.ignorespaces()
            ll.ignorespaces()
    
    def doanswerfile(self,infile,out) :

        with open(infile, 'r') as ansfile :
            lines = ansfile.readlines()

        with open(out,'w') as outfile :
            for i in range(self.headerno,len(lines)) :
                line = lines[i]
                if line.strip() == '' : continue
                if line.rfind(ROWSSELECTED) != -1 : continue
                if line.rfind(ROWS) != -1 : continue
                ll = LINE(line)
                self.transformline(ll)
                if self.numof != len(ll.out) :
                    print("Expected: " + str(self.numof) + " got:" + str(len(ll.out)))
                    print(line)
                    print(ll.out)
                    assert(False)
                outfile.write('|')
                for f in ll.out : outfile.write(f + '|')
                outfile.write('\n')
            outfile.write("---------")


INPUTDIR="/home/sbartkowski/work/v2.13.0rc1/answer_sets"
OUTPUTDIR="/home/sbartkowski/work/mytpcds/qualifres"

# 5_NULLS_FIRST.ans

LISTOFRES=[
    ("1.ans","query1.res",2,1,[TYPEF.ALLTOSPACE]),
    ("2.ans","query2.res",2,8,[TYPEF.ALLTOSPACE]),
    ("3.ans","query3.res",2 ,4,[TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOSPACE]),
    ("4.ans","query4.res",2 ,4,[TYPEF.ALLTOSPACE]),
    ("5_NULLS_FIRST.ans","query5.res",1 ,5,[TYPEF.ALLTOPIPE]),
# manual:("5_NULLS_LAST.ans","query5_null.res",1 ,5,[TYPEF.ALLTOPIPE]),  
    ("6_NULLS_FIRST.ans","query6.res",2 ,2,[TYPEF.ALLTOSPACE]),  
    ("7.ans","query7.res",1 ,5,[TYPEF.ALLTOPIPE]),
    ("8.ans","query8.res",2 ,2,[TYPEF.ALLTOSPACE]),
    ("9.ans","query9.res",2 ,5,[TYPEF.ALLTOSPACE]),
    ("10.ans","query10.res",2 ,14,[TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),

    ("12.ans","query12.res",2,7,[TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
]



#INPUT="/home/sbartkowski/work/v2.13.0rc1/answer_sets/12.ans"
#ANS12 = [TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.ALLNUMBER]
#WRITE="/tmp/res/query12.res"

def runone(l) :
    INPUT = INPUTDIR+ "/" + l[0]
    WRITE = OUTPUTDIR + "/" + l[1]
    headersno = l[2]
    nof = l[3]
    ans = l[4]
    print(INPUT + " => " + WRITE)
    a = ANSTYPE(headersno,ans,nof)
    a.doanswerfile(INPUT,WRITE)

def main () :
    for l in LISTOFRES : runone(l)

#main()
runone(LISTOFRES[9])
