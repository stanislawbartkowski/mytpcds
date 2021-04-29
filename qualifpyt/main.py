
IGNORE=["Warning: Null","Elapsed:","rows ","rows)","rows selected","-------","record(s)"]

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

    def ignorepipes(self) :
        while not self.eofline() and self.isc('|') : self.inc()

    def eofline(self) :
        return self.c >= len(self.l)

    def getfieldtotab(self) :
        self.initf()
        while not self.eofline() and not self.istab() and not self.iseol(): self.addc()
        self.addfield()

    def getfieldtospace(self) :
        self.initf()
        while not self.eofline() and not self.istab() and not self.iss() : self.addc()
        self.addfield()

    def getfieldtopipe(self) :
        self.initf()
#        if not self.isc("|") and not self.eofline:
        while not self.eofline() and not self.istab() and not self.isc('|') and not self.iseol() : self.addc()
        self.inc()
        self.addfield()

    def getfieldtopercent(self) :
        self.initf()
        while not self.eofline() and not self.istab() and not self.isc('%') and not self.iseol() : self.addc()
        self.inc()
        self.addfield()

class TYPEF(Enum):
    TOSPACE = 1
    TOTAB = 2
    ALLTOSPACE = 3
    ALLTOPIPE = 4
    ALLTOTAB = 5
    IGNORETABS = 6
    IGNOREPIPE = 7
    TOPIPE = 8
    ALLTOPERCENT = 9

class ANSTYPE :
    def __init__(self,headerno,ty,numof,sep,headerno2,ty2,numof2):
        self.headerno = headerno
        self.ty = ty
        if type(numof) == list : self.numof = numof
        else : self.numof = [numof]

        self.sep = sep
        self.headerno2 = headerno2
        self.ty2 = ty2
        if type(numof2) == list : self.numof2 = numof2
        else : self.numof2 = [numof2]

    def transformline(self,ll,ty) :
        ll.ignoreonlyspaces()
        for t in ty :
            if t == TYPEF.IGNORETABS :ll.ignorespaces()
            elif t == TYPEF.IGNOREPIPE : ll.ignorepipes()
            elif t == TYPEF.TOSPACE : ll.getfieldtospace()
            elif t == TYPEF.TOTAB : ll.getfieldtotab()
            elif t == TYPEF.TOPIPE: ll.getfieldtopipe()
            elif t == TYPEF.ALLTOPERCENT :
                while not ll.eofline() :
                    ll.getfieldtopercent()
                    ll.ignorespaces()
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

    def __answerfile(self,outfile,lines,beg,end,ty,numof) :
        maxnum = max(numof)

        for i in range(beg,end) :
            line = lines[i]
            if line.strip() == '' : continue
            ignore = False
            for ig in IGNORE :
              if line.rfind(ig) != -1 : ignore = True
            if ignore : continue
            ll = LINE(line)
            self.transformline(ll,ty)
            if not len(ll.out) in numof :
                print("Expected: " + str(numof) + " got:" + str(len(ll.out)))
                print(line)
                print(ll.out)
                assert(False)
            outfile.write('|')
            for f in ll.out : outfile.write(f + '|')
            for i in range(len(ll.out),maxnum) : outfile.write('NULL |')
            outfile.write('\n')
        outfile.write("---------\n")

    
    def doanswerfile(self,infile,out) :

        with open(infile, 'r') as ansfile :
            lines = ansfile.readlines()

        with open(out,'w') as outfile :
            if self.sep == None: 
              self.__answerfile(outfile,lines,self.headerno,len(lines),self.ty,self.numof)
              return
            nexti = -1
            for i in range(self.headerno,len(lines)) :
                line = lines[i]
                if line.find(self.sep) == 0 : 
                    nexti = i
                    break

            if nexti == -1 :
                print ("Cannot find " + self.sep + " in " + infile)
                assert(False)
            self.__answerfile(outfile,lines,self.headerno,nexti,self.ty,self.numof)
            self.__answerfile(outfile,lines,nexti+self.headerno2,len(lines),self.ty2,self.numof2)

INPUTDIR="/home/sbartkowski/work/mytpcds/answer_sets"
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
    ("6_NULLS_LAST.ans","query6_null.res",2 ,2,[TYPEF.ALLTOSPACE]),  
    ("7.ans","query7.res",1 ,5,[TYPEF.ALLTOPIPE]),
    ("8.ans","query8.res",2 ,2,[TYPEF.ALLTOSPACE]),
    ("9.ans","query9.res",2 ,5,[TYPEF.ALLTOSPACE]),
    ("10.ans","query10.res",2 ,14,[TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("11.ans","query11.res",2 ,[1,3,4],[TYPEF.ALLTOSPACE]),
    ("12.ans","query12.res",2,[6,7],[TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("13.ans","query13.res",2,4,[TYPEF.IGNORETABS,TYPEF.ALLTOSPACE]),
    ("14_NULLS_FIRST.ans","query14.res",2 ,6,[TYPEF.ALLTOPIPE],"CHANN|",2,12,[TYPEF.ALLTOPIPE]),  
    ("14_NULLS_LAST.ans","query14_null.res",2 ,[4,5,6],[TYPEF.ALLTOSPACE],"CHANN",2,12,[TYPEF.ALLTOSPACE]),  
    ("15_NULLS_FIRST.ans","query15.res",2,2,[TYPEF.ALLTOSPACE]),
    ("15_NULLS_LAST.ans","query15_null.res",2,2,[TYPEF.ALLTOTAB]),
    ("16.ans","query16.res",2,3,[TYPEF.IGNORETABS,TYPEF.ALLTOSPACE]),
    ("17.ans","query17.res",2,15,[TYPEF.ALLTOPIPE]),
    ("oracle18.res","query18.res",0,11,[TYPEF.IGNOREPIPE,TYPEF.ALLTOPIPE]),
    ("19.ans","query19.res",2,5,[TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB]),
    ("20_NULLS_FIRST.ans","query20.res",2,7,[TYPEF.TOPIPE,TYPEF.TOPIPE,TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),
    ("20_NULLS_LAST.ans","query20_null.res",2,7,[TYPEF.TOSPACE,TYPEF.TOPIPE,TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),
    ("21_NULLS_FIRST.ans","query21.res",1,4,[TYPEF.ALLTOPIPE]),
    ("21_NULLS_LAST.ans","query21_null.res",1,4,[TYPEF.TOPIPE,TYPEF.ALLTOSPACE]),
    ("22_NULLS_FIRST.ans","query22.res",3,5,[TYPEF.ALLTOPIPE]),
    ("22_NULLS_LAST.ans","query22_null.res",2,5,[TYPEF.ALLTOPIPE]),
    ("23_NULLS_FIRST.ans","query23.res",2 ,1,[TYPEF.ALLTOSPACE],"C_LAST_NAME",2,3,[TYPEF.ALLTOSPACE]),  
    ("23_NULLS_LAST.ans","query23_null.res",2 ,1,[TYPEF.ALLTOSPACE],"C_LAST_NAME",2,3,[TYPEF.ALLTOSPACE]),  
    ("24.ans","query24.res",4 ,4,[TYPEF.ALLTOSPACE],"C_LAST_NAME",2,4,[TYPEF.ALLTOSPACE]),  
    ("25.ans","query25.res",2 ,7,[TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),  
    ("26.ans","query26.res",2 ,5,[TYPEF.ALLTOSPACE]),  
    ("27_NULLS_FIRST.ans","query27.res",2 ,6,[TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("27_NULLS_LAST.ans","query27_null.res",2 ,6,[TYPEF.TOPIPE,TYPEF.TOPIPE,TYPEF.ALLTOSPACE]),
    ("28.ans","query28.res",2 ,17,[TYPEF.ALLTOSPACE]),
    ("29.ans","query29.res",2 ,7,[TYPEF.ALLTOPIPE]),
    ("30.ans","query30.res",2 ,13,[TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("31.ans","query31.res",2 ,6,[TYPEF.ALLTOTAB]),
    ("32.ans","query32.res",2 ,1,[TYPEF.ALLTOSPACE]),
    ("33.ans","query33.res",2 ,2,[TYPEF.IGNORETABS,TYPEF.ALLTOTAB]),
    ("34_NULLS_FIRST.ans","query34.res",2 ,6,[TYPEF.ALLTOSPACE]),
    ("34_NULLS_LAST.ans","query34_null.res",2 ,6,[TYPEF.ALLTOSPACE]),
    ("35_NULLS_FIRST.ans","query35.res",2 ,17,[TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("35_NULLS_LAST.ans","query35_null.res",2 ,17,[TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("36_NULLS_FIRST.ans","query36.res",1 ,5,[TYPEF.ALLTOPIPE]),
    ("36_NULLS_LAST.ans","query36_null.res",2 ,5,[TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("37.ans","query37.res",2 ,3,[TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("38.ans","query38.res",2 ,1,[TYPEF.TOSPACE]),
    ("39.ans","query39.res",1 ,10,[TYPEF.ALLTOPIPE],"W_WAREHOUSE_SK",1,10,[TYPEF.ALLTOPIPE]),  
    ("40.ans","query40.res",2 ,4,[TYPEF.ALLTOSPACE]),
    ("41.ans","query41.res",2 ,1,[TYPEF.ALLTOSPACE]),
    ("42.ans","query42.res",2 ,4,[TYPEF.ALLTOSPACE]),
    ("43.ans","query43.res",1 ,9,[TYPEF.ALLTOPIPE]),
    ("44.ans","query44.res",1 ,3,[TYPEF.IGNORETABS,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("45.ans","query45.res",4 ,3,[TYPEF.ALLTOPIPE]),
    ("46_NULLS_FIRST.ans","query46.res",2 ,7,[TYPEF.ALLTOPIPE]),
    ("46_NULLS_LAST.ans","query46_null.res",2 ,7,[TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("47.ans","query47.res",2 ,10,[TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("48.ans","query48.res",2 ,1,[TYPEF.IGNORETABS,TYPEF.ALLTOSPACE]),
    ("49.ans","query49.res",2 ,5,[TYPEF.ALLTOSPACE]),
    ("50.ans","query50.res",2 ,14,[TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOPIPE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("51.ans","query51.res",2 ,6,[TYPEF.IGNORETABS,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("52.ans","query52.res",2 ,4,[TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("53.ans","query53.res",1 ,3,[TYPEF.ALLTOPIPE]),
    ("54.ans","query54.res",2 ,3,[TYPEF.ALLTOSPACE]),
    ("55.ans","query55.res",2 ,3,[TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("56_NULLS_FIRST.ans","query56.res",2 ,[1,2],[TYPEF.ALLTOSPACE]),
    ("56_NULLS_LAST.ans","query56_null.res",2 ,2,[TYPEF.ALLTOSPACE]),
    ("57.ans","query57.res",2 ,9,[TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("58.ans","query58.res",2 ,8,[TYPEF.ALLTOSPACE]),
    ("59.ans","query59.res",2 ,10,[TYPEF.ALLTOSPACE]),
    ("60.ans","query60.res",2 ,2,[TYPEF.ALLTOSPACE]),
    ("61.ans","query61.res",2 ,3,[TYPEF.ALLTOSPACE]),
    ("62_NULLS_FIRST.ans","query62.res",2 ,8,[TYPEF.TOPIPE,TYPEF.TOPIPE,TYPEF.ALLTOSPACE]),
    ("62_NULLS_LAST.ans","query62_null.res",2 ,8,[TYPEF.TOPIPE,TYPEF.ALLTOTAB]),
    ("63.ans","query63.res",1 ,3,[TYPEF.ALLTOPIPE]),
    ("64.ans","query64.res",2 ,21,[TYPEF.ALLTOPIPE]),
    ("65_NULLS_FIRST.ans","query65.res",2 ,6,[TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("65_NULLS_LAST.ans","query65_null.res",2 ,6,[TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("66_NULLS_FIRST.ans","query66.res",1 ,44,[TYPEF.ALLTOPIPE]),
    ("66_NULLS_LAST.ans","query66_null.res",2 ,44,[TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("67_NULLS_FIRST.ans","query67.res",2 ,10,[TYPEF.ALLTOPIPE]),
    ("67_NULLS_LAST.ans","query67_null.res",2 ,10,[TYPEF.ALLTOTAB]),
    ("68_NULLS_FIRST.ans","query68.res",2 ,8,[TYPEF.ALLTOPIPE]),
    ("68_NULLS_LAST.ans","query68_null.res",2 ,8,[TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("69.ans","query69.res",2 ,8,[TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("70.ans","query70.res",2 ,5,[TYPEF.TOSPACE,TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("71_NULLS_FIRST.ans","query71.res",2 ,5,[TYPEF.ALLTOPIPE]),
    ("71_NULLS_LAST.ans","query71_null.res",2 ,[4,5],[TYPEF.ALLTOPIPE]),
    ("72_NULLS_FIRST.ans","query72.res",2 ,6,[TYPEF.ALLTOTAB]),
    ("72_NULLS_LAST.ans","query72_null.res",2 ,6,[TYPEF.ALLTOTAB]),
    ("73.ans","query73.res",2 ,6,[TYPEF.ALLTOSPACE]),
    ("74.ans","query74.res",2 ,3,[TYPEF.TOSPACE,TYPEF.ALLTOTAB]),
    ("75.ans","query75.res",2 ,10,[TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("76_NULLS_FIRST.ans","query76.res",1 ,[6,7],[TYPEF.ALLTOPIPE]),
    ("76_NULLS_LAST.ans","query76_null.res",1 ,7,[TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("77_NULLS_FIRST.ans","query77.res",2 ,5,[TYPEF.TOTAB,TYPEF.ALLTOSPACE]),
    ("77_NULLS_LAST.ans","query77_null.res",2 ,5,[TYPEF.TOTAB,TYPEF.ALLTOSPACE]),


#    ("18_NULLS_FIRST.ans","query18.res",1 ,11,[TYPEF.ALLTOPIPE]),  
#    ("18_NULLS_LAST.ans","query18_null.res",2 ,11,[TYPEF.TOSPACE,TYPEF.ALLTOPIPE]),  
]   

# answer 17 - modified
# 18_NULLS_LAST : tabs
# query 12: two lines, books without preceding tabs


#INPUT="/home/sbartkowski/work/v2.13.0rc1/answer_sets/12.ans"
#ANS12 = [TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.ALLNUMBER]
#WRITE="/tmp/res/query12.res"

def runone(l) :
    INPUT = INPUTDIR+ "/" + l[0]
    WRITE = OUTPUTDIR + "/" + l[1]
    headersno = l[2]
    nof = l[3]
    ans = l[4]

    sep = None
    headersno2 = None
    nof2 = None
    ans2 = None
    if len(l) > 5 :
      sep = l[5]
      headersno2 = l[6]
      nof2 = l[7]
      ans2 = l[8]

    print(INPUT + " => " + WRITE)
    a = ANSTYPE(headersno,ans,nof,sep,headersno2,ans2,nof2)
    a.doanswerfile(INPUT,WRITE)

def main () :
    for l in LISTOFRES : runone(l)

#main()
runone(LISTOFRES[98])
