
from enum import Enum
IGNORE = ["Warning: Null", "Elapsed:", "rows)", "rows affected",
          "rows select", "rows selected", "-------", "record(s)"]


class LINE:

    def __init__(self, l, numbers):
        self.l = l
        self.c = 0
        self.out = []
        self.counter = 0
        self.numbers = numbers

    def initf(self):
        self.field = ""

    def convertnumber(self):
        num = float(self.field)
        self.field = format(num, ".2f")

    def addc(self):
        self.field = self.field + self.cc()
        self.inc()

    def addfield(self):
        if self.field == "":
            self.out.append("NULL")
        else:
            if self.numbers != None and self.counter in self.numbers and self.field != "NULL":
                self.convertnumber()
            self.out.append(self.field)
        self.counter = self.counter + 1

    def cc(self):
        return self.l[self.c]

    def isc(self, ch):
        return self.cc() == ch

    def iss(self):
        return self.cc().isspace()

    def istab(self):
        return self.isc('\t')

    def iseol(self):
        return self.isc('\n')

    def inc(self):
        self.c = self.c + 1

    def ignoreonlyspaces(self):
        while not self.eofline() and self.isc(' '):
            self.inc()

    def ignorespaces(self):
        while not self.eofline() and (self.iss() or self.istab() or self.iseol()):
            self.inc()

    def ignorepipes(self):
        while not self.eofline() and self.isc('|'):
            self.inc()

    def eofline(self):
        return self.c >= len(self.l)

    def getfieldtotab(self):
        self.initf()
        while not self.eofline() and not self.istab() and not self.iseol():
            self.addc()
        self.addfield()

    def getfieldtospace(self):
        self.initf()
        while not self.eofline() and not self.istab() and not self.iss():
            self.addc()
        self.addfield()

    def getfieldtopipe(self):
        self.initf()
#        if not self.isc("|") and not self.eofline:
        while not self.eofline() and not self.istab() and not self.isc('|') and not self.iseol():
            self.addc()
        self.inc()
        self.addfield()

    def getfieldtopercent(self):
        self.initf()
        while not self.eofline() and not self.istab() and not self.isc('%') and not self.iseol():
            self.addc()
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


def drawlastline(outfile):
    outfile.write("---------\n")


class ANSTYPE:
    def __init__(self, headerno, ty, numof, sep, headerno2, ty2, numof2, numbers):
        self.headerno = headerno
        self.ty = ty
        if type(numof) == list:
            self.numof = numof
        else:
            self.numof = [numof]

        self.sep = sep
        self.headerno2 = headerno2
        self.ty2 = ty2
        if type(numof2) == list:
            self.numof2 = numof2
        else:
            self.numof2 = [numof2]
        self.numbers = numbers

    def transformline(self, ll, ty):
        ll.ignoreonlyspaces()
        for t in ty:
            if t == TYPEF.IGNORETABS:
                ll.ignorespaces()
            elif t == TYPEF.IGNOREPIPE:
                ll.ignorepipes()
            elif t == TYPEF.TOSPACE:
                ll.getfieldtospace()
            elif t == TYPEF.TOTAB:
                ll.getfieldtotab()
            elif t == TYPEF.TOPIPE:
                ll.getfieldtopipe()
            elif t == TYPEF.ALLTOPERCENT:
                while not ll.eofline():
                    ll.getfieldtopercent()
                    ll.ignorespaces()
            elif t == TYPEF.ALLTOSPACE:
                while not ll.eofline():
                    ll.getfieldtospace()
                    ll.ignorespaces()
            elif t == TYPEF.ALLTOPIPE:
                while not ll.eofline():
                    ll.getfieldtopipe()
                    ll.ignorespaces()
            elif t == TYPEF.ALLTOTAB:
                while not ll.eofline():
                    ll.getfieldtotab()
                    ll.ignorespaces()
            ll.ignorespaces()

    def __answerfile(self, outfile, lines, beg, end, ty, numof):
        maxnum = max(numof)
        ignored = 0

        for i in range(beg, end):
            line = lines[i]
            if line.strip() == '':
                continue
            ignore = False
            for ig in IGNORE:
                if line.rfind(ig) != -1:
                    ignore = True
            if ignore:
                print("ignored="+line)
                ignored = ignored + 1
                continue
            ll = LINE(line, self.numbers)
            self.transformline(ll, ty)
            if not len(ll.out) in numof:
                print("Expected: " + str(numof) + " got:" + str(len(ll.out)))
                print(line)
                print(ll.out)
                assert(False)
            outfile.write('|')
            for f in ll.out:
                outfile.write(f + '|')
            for i in range(len(ll.out), maxnum):
                outfile.write('NULL |')
            outfile.write('\n')
#        outfile.write("---------\n")
        # print("ignored=" + str(ignored))

    def doanswerfile(self, infile, out):

        with open(infile, 'r') as ansfile:
            lines = ansfile.readlines()

        with open(out, 'w') as outfile:
            if self.sep == None:
                self.__answerfile(outfile, lines, self.headerno,
                                  len(lines), self.ty, self.numof)
                drawlastline(outfile)
                return
            nexti = -1
            for i in range(self.headerno, len(lines)):
                line = lines[i]
                if line.find(self.sep) == 0:
                    nexti = i
                    break

            if nexti == -1:
                print("Cannot find " + self.sep + " in " + infile)
                assert(False)
            self.__answerfile(outfile, lines, self.headerno,
                              nexti, self.ty, self.numof)
            drawlastline(outfile)
            self.__answerfile(outfile, lines, nexti+self.headerno2,
                              len(lines), self.ty2, self.numof2)
            drawlastline(outfile)


INPUTDIR = "/home/sbartkowski/work/mytpcds/answer_sets"
OUTPUTDIR = "/home/sbartkowski/work/mytpcds/qualifres"

# 5_NULLS_FIRST.ans

NUMBERS = {
    "query10.res": {3, 5, 7, 9, 11, 13},
    "query12.res": {4, 5, 6},
    "query13.res": {0},
    "query14_null.res": {4, 5, 10, 11},
    "query16.res": {0},
    "query17.res": {3, 4, 7, 8, 11, 12},
    "query18.res": {4, 5, 6, 7, 8, 9, 10},
    "query20_null.res": {4, 5, 6},
    "query26.res": {1, 2, 4},
    "query27_null.res": {3},
    "query28.res": {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17},
    "query29.res": {4, 5, 6},
    "query34_null.res": {5},
    "query35_null.res": {4, 7, 9, 12, 14, 17},
    "query36_null.res": {0, 4},
    "query38.res": {0},
    "query44.res": {0},
    "query48.res": {0},
    "query49.res": {2, 3, 4},
    "query50.res": {10, 11, 12, 13, 14},
    "query52.res": {3},
    "query54.res": {1},
    "query56_null.res": {1},
    "query6_null.res": {1},
    "query60.res": {1},
    "query62_null.res": {3,4,5,6},
    "query64.res": {12, 13, 20},
    "query65_null.res": {3, 4},
    "query67_null.res": {8,9},
    "query68_null.res": {6},
    "query69.res": {3, 5, 7},
    "query70.res": {0,4},
    "query72_null.res": {4, 5},
    "query73.res": {5},
    "query75.res": {6,7,8,9},
    "query76_null.res": {5, 6},
    "query77_null.res": {2, 3, 4},
    "query78.res": {4, 7, },
    "query79_null.res": {4},
    "query80_null.res": {2, 3, 4},
    "query81.res": {13, 15},
    "query85.res": {1},
    "query86_null.res": {4},
    "query87.res": {0},
    "query88.res": {0, 1, 2, 3, 4, 5, 6, 7},
    "query94.res": {0},
    "query95.res": {0},
    "query96.res": {0},
    "query97.res": {0,1,2},
    "query98_null.res": {5},
    "query99_null.res": {3,4,5}
}

LISTOFRES = [
    ("1.ans", "query1.res", 2, 1, [TYPEF.ALLTOSPACE]),
    ("2.ans", "query2.res", 2, 8, [TYPEF.ALLTOSPACE]),  # 1

    ("3.ans", "query3.res", 2, 4, [
     TYPEF.TOSPACE, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOSPACE]),  # 2

    ("4.ans", "query4.res", 2, 4, [TYPEF.ALLTOSPACE]),

    ("5_NULLS_FIRST.ans", "query5.res", 1, 5, [TYPEF.ALLTOPIPE]),

    ("5_NULLS_LAST.ans", "query5_null.res", 1,
     5, [TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),  # 5

    ("6_NULLS_FIRST.ans", "query6.res", 2, 2, [TYPEF.ALLTOSPACE]),

    ("6_NULLS_LAST.ans", "query6_null.res", 2, 2, [TYPEF.ALLTOSPACE]),  # 7

    ("7.ans", "query7.res", 1, 5, [TYPEF.ALLTOPIPE]),

    ("8.ans", "query8.res", 2, 2, [TYPEF.ALLTOSPACE]),

    ("9.ans", "query9.res", 2, 5, [TYPEF.ALLTOSPACE]),  # 10

    ("10.ans", "query10.res", 2, 14, [TYPEF.TOSPACE, TYPEF.TOSPACE,
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 11

    ("11.ans", "query11.res", 2, [1, 3, 4], [TYPEF.ALLTOSPACE]),

    ("12.ans", "query12.res", 2, 7, [
     TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 13

    ("13.ans", "query13.res", 2, 4, [
     TYPEF.IGNORETABS, TYPEF.ALLTOSPACE]),  # 14

    ("14_NULLS_FIRST.ans", "query14.res", 2, 6, [
     TYPEF.ALLTOPIPE], "CHANN|", 2, 12, [TYPEF.ALLTOPIPE]),  # 15

    ("14_NULLS_LAST.ans", "query14_null.res", 2, 6, [
     TYPEF.ALLTOSPACE], "CHANN", 2, 12, [TYPEF.ALLTOSPACE]),  # 16

    ("15_NULLS_FIRST.ans", "query15.res", 2, 2, [TYPEF.ALLTOSPACE]),
    ("15_NULLS_LAST.ans", "query15_null.res", 2, 2, [TYPEF.ALLTOTAB]),

    ("16.ans", "query16.res", 2, 3, [
     TYPEF.IGNORETABS, TYPEF.ALLTOSPACE]),  # 19

    ("17.ans", "query17.res", 2, 15, [TYPEF.ALLTOPIPE]),  # 20

    ("oracle18.res", "query18.res", 0, 11,
     [TYPEF.IGNOREPIPE, TYPEF.ALLTOPIPE]),  # 21

    ("19.ans", "query19.res", 2, 5, [
     TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB]),  # 22

    ("20_NULLS_FIRST.ans", "query20.res", 2, 7, [
     TYPEF.TOPIPE, TYPEF.TOPIPE, TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),

    ("20_NULLS_LAST.ans", "query20_null.res", 2, 7, [
     TYPEF.TOSPACE, TYPEF.TOPIPE, TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),  # 24

    ("21_NULLS_FIRST.ans", "query21.res", 1, 4, [TYPEF.ALLTOPIPE]),

    ("21_NULLS_LAST.ans", "query21_null.res",
     1, 4, [TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),

    ("22_NULLS_FIRST.ans", "query22.res", 3, 5, [TYPEF.ALLTOPIPE]),
    ("22_NULLS_LAST.ans", "query22_null.res", 2, 5, [TYPEF.ALLTOPIPE]),

    ("23_NULLS_FIRST.ans", "query23.res", 2, 1, [
     TYPEF.ALLTOSPACE], "C_LAST_NAME", 2, 3, [TYPEF.ALLTOSPACE]),

    ("23_NULLS_LAST.ans", "query23_null.res", 2, 1, [
     TYPEF.ALLTOSPACE], "C_LAST_NAME", 2, 3, [TYPEF.ALLTOSPACE]),  # 30

    ("24.ans", "query24.res", 4, 4, [
     TYPEF.ALLTOSPACE], "C_LAST_NAME", 2, 4, [TYPEF.ALLTOSPACE]),

    ("25.ans", "query25.res", 2, 7, [
     TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),

    ("26.ans", "query26.res", 2, 5, [TYPEF.ALLTOSPACE]),  # 33

    ("27_NULLS_FIRST.ans", "query27.res", 2, 6, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),

    ("27_NULLS_LAST.ans", "query27_null.res", 2, 7, [
     TYPEF.TOPIPE, TYPEF.TOPIPE, TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),  # 35

    ("28.ans", "query28.res", 2, 18, [TYPEF.ALLTOSPACE]),  # 36

    ("29.ans", "query29.res", 2, 7, [TYPEF.ALLTOPIPE]),  # 37

    ("30.ans", "query30.res", 2, 13, [TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB,
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 38

    ("31.ans", "query31.res", 2, 6, [TYPEF.ALLTOTAB]),
    ("32.ans", "query32.res", 2, 1, [TYPEF.ALLTOSPACE]),  # 40
    ("33.ans", "query33.res", 2, 2, [TYPEF.IGNORETABS, TYPEF.ALLTOTAB]),  # 41

    ("34_NULLS_FIRST.ans", "query34.res", 2, 6, [TYPEF.ALLTOSPACE]),

    ("34_NULLS_LAST.ans", "query34_null.res", 2, 6, [TYPEF.ALLTOSPACE]),  # 43

    ("35_NULLS_FIRST.ans", "query35.res", 2,
     17, [TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 44

    ("35_NULLS_LAST.ans", "query35_null.res", 2, 18, [
     TYPEF.TOSPACE, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 45

    ("36_NULLS_FIRST.ans", "query36.res", 1, 5, [TYPEF.ALLTOPIPE]),

    ("36_NULLS_LAST.ans", "query36_null.res",
     2, 5, [TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 47

    ("37.ans", "query37.res", 2, 3, [TYPEF.TOSPACE, TYPEF.ALLTOTAB]),

    ("38.ans", "query38.res", 2, 1, [TYPEF.TOSPACE]),  # 49

    ("39.ans", "query39.res", 1, 10, [
     TYPEF.ALLTOPIPE], "W_WAREHOUSE_SK", 1, 10, [TYPEF.ALLTOPIPE]),  # 50

    ("40.ans", "query40.res", 2, 4, [TYPEF.ALLTOSPACE]),
    ("41.ans", "query41.res", 2, 1, [TYPEF.ALLTOSPACE]),
    ("42.ans", "query42.res", 2, 4, [TYPEF.ALLTOSPACE]),
    ("43.ans", "query43.res", 1, 9, [TYPEF.ALLTOPIPE]),

    ("44.ans", "query44.res", 1, 3, [
     TYPEF.IGNORETABS, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 55

    ("45.ans", "query45.res", 4, 3, [TYPEF.ALLTOPIPE]),

    ("46_NULLS_FIRST.ans", "query46.res", 2, 7, [TYPEF.ALLTOPIPE]),  # 57

    ("46_NULLS_LAST.ans", "query46_null.res", 2, 7, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 58
    ("47.ans", "query47.res", 2, 10, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),

    ("48.ans", "query48.res", 2, 1, [
     TYPEF.IGNORETABS, TYPEF.ALLTOSPACE]),  # 60

    ("49.ans", "query49.res", 2, 5, [TYPEF.ALLTOSPACE]),  # 61

    ("50.ans", "query50.res", 2, 15, [TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOTAB,
     TYPEF.TOTAB, TYPEF.TOPIPE, TYPEF.TOPIPE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 62

    ("51.ans", "query51.res", 2, 6, [
     TYPEF.IGNORETABS, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),
    ("52.ans", "query52.res", 2, 4, [
     TYPEF.TOSPACE, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 64

    ("53.ans", "query53.res", 1, 3, [TYPEF.ALLTOPIPE]),

    ("54.ans", "query54.res", 2, 3, [TYPEF.ALLTOSPACE]),  # 66

    ("55.ans", "query55.res", 2, 3, [TYPEF.TOSPACE, TYPEF.ALLTOTAB]),

    ("56_NULLS_FIRST.ans", "query56.res", 2, [1, 2], [TYPEF.ALLTOSPACE]),

    ("56_NULLS_LAST.ans", "query56_null.res", 2, 2, [TYPEF.ALLTOSPACE]),  # 69

    ("57.ans", "query57.res", 2, 9, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 70
    ("58.ans", "query58.res", 2, 8, [TYPEF.ALLTOSPACE]),
    ("59.ans", "query59.res", 2, 10, [TYPEF.ALLTOSPACE]),
    ("60.ans", "query60.res", 2, 2, [TYPEF.ALLTOSPACE]),  # 73
    ("61.ans", "query61.res", 2, 3, [TYPEF.ALLTOSPACE]),

    ("62_NULLS_FIRST.ans", "query62.res", 2, 8, [
     TYPEF.TOPIPE, TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),

    ("62_NULLS_LAST.ans", "query62_null.res", 2,
     8, [TYPEF.TOPIPE, TYPEF.ALLTOTAB]),  # 76

    ("63.ans", "query63.res", 1, 3, [TYPEF.ALLTOPIPE]),  # 77

    ("64.ans", "query64.res", 2, 21, [TYPEF.ALLTOPIPE]),  # 78

    ("65_NULLS_FIRST.ans", "query65.res", 2, 6, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 79
    ("65_NULLS_LAST.ans", "query65_null.res", 2, 6, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 80
    ("66_NULLS_FIRST.ans", "query66.res", 1, 44, [TYPEF.ALLTOPIPE]),
    ("66_NULLS_LAST.ans", "query66_null.res", 2, 44, [
     TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 82
     
    ("67_NULLS_FIRST.ans", "query67.res", 2, 10, [TYPEF.ALLTOPIPE]),

    ("67_NULLS_LAST.ans", "query67_null.res", 2, 10, [TYPEF.ALLTOTAB]),  # 84

    ("68_NULLS_FIRST.ans", "query68.res", 2, 8, [TYPEF.ALLTOPIPE]),

    ("68_NULLS_LAST.ans", "query68_null.res", 2, 8, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 86

    ("69.ans", "query69.res", 2, 8, [TYPEF.TOSPACE, TYPEF.TOSPACE,
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 87

    ("70.ans", "query70.res", 2, 5, [
     TYPEF.TOSPACE, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 88

    ("71_NULLS_FIRST.ans", "query71.res", 2, 5, [TYPEF.ALLTOPIPE]),

    ("71_NULLS_LAST.ans", "query71_null.res",
     1, [4, 5], [TYPEF.ALLTOPIPE]),  # 90

    ("72_NULLS_FIRST.ans", "query72.res", 2, 6, [TYPEF.ALLTOTAB]),  # 91

    ("72_NULLS_LAST.ans", "query72_null.res", 2, 6, [TYPEF.ALLTOTAB]),  # 92

    ("73.ans", "query73.res", 2, 6, [TYPEF.ALLTOSPACE]),  # 93

    ("74.ans", "query74.res", 2, 3, [TYPEF.TOSPACE, TYPEF.ALLTOTAB]),

    ("75.ans", "query75.res", 2, 10, [TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB,
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.ALLTOSPACE]), #95

    ("76_NULLS_FIRST.ans", "query76.res", 1, [6, 7], [TYPEF.ALLTOPIPE]),

    ("76_NULLS_LAST.ans", "query76_null.res", 1, 7, [
     TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 97

    ("77_NULLS_FIRST.ans", "query77.res",
     2, 5, [TYPEF.TOTAB, TYPEF.ALLTOSPACE]),

    ("77_NULLS_LAST.ans", "query77_null.res",
     2, 5, [TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 99

    ("78.ans", "query78.res", 2, 10, [TYPEF.ALLTOPIPE]),  # 100

    ("79_NULLS_FIRST.ans", "query79.res", 1, [5, 6], [TYPEF.ALLTOPIPE]),

    ("79_NULLS_LAST.ans", "query79_null.res", 1, 6, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 102

    ("80_NULLS_FIRST.ans", "query80.res", 5, 5, [TYPEF.ALLTOPIPE]),

    ("80_NULLS_LAST.ans", "query80_null.res",
     2, 5, [TYPEF.TOPIPE, TYPEF.ALLTOSPACE]),  # 104

    ("81.ans", "query81.res", 2, 16, [TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB,
     TYPEF.TOPIPE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 105

    ("82.ans", "query82.res", 2, 3, [TYPEF.TOSPACE, TYPEF.ALLTOTAB]),
    ("83.ans", "query83.res", 2, 8, [TYPEF.ALLTOSPACE]),
    ("84.ans", "query84.res", 2, 2, [TYPEF.ALLTOPIPE]),

    ("85.ans", "query85.res", 2, 4, [TYPEF.ALLTOTAB]),  # 109

    ("86_NULLS_FIRST.ans", "query86.res", 1, 5, [TYPEF.ALLTOPIPE]),  # 110

    ("86_NULLS_LAST.ans", "query86_null.res",
     1, 5, [TYPEF.TOSPACE, TYPEF.ALLTOTAB]),  # 111

    ("87.ans", "query87.res", 2, 1, [TYPEF.ALLTOTAB]),  # 112

    ("88.ans", "query88.res", 2, 8, [TYPEF.ALLTOTAB]),  # 113

    ("89.ans", "query89.res", 2, 8, [
     TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOSPACE, TYPEF.ALLTOTAB]),

    ("90.ans", "query90.res", 2, 1, [TYPEF.ALLTOTAB]),

    ("91.ans", "query91.res", 2, 4, [TYPEF.TOSPACE, TYPEF.ALLTOTAB]),

    ("92.ans", "query92.res", 2, 1, [TYPEF.ALLTOTAB]),

    ("93_NULLS_FIRST.ans", "query93.res", 1, 2, [TYPEF.ALLTOPIPE]),

    ("93_NULLS_LAST.ans", "query93_null.res",
     1, 2, [TYPEF.IGNORETABS, TYPEF.ALLTOTAB]),

    ("94.ans", "query94.res", 2, 3, [TYPEF.IGNORETABS, TYPEF.ALLTOTAB]),  # 120

    ("95.ans", "query95.res", 2, 3, [TYPEF.IGNORETABS, TYPEF.ALLTOTAB]),  # 121

    ("96.ans", "query96.res", 2, 1, [TYPEF.ALLTOTAB]),  # 122

    ("97.ans", "query97.res", 1, 3, [TYPEF.ALLTOPIPE]),  # 123

    ("98_NULLS_FIRST.ans", "query98.res", 2, 7, [TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.ALLTOSPACE], "I_ITEM_ID", 2, 7, [
     TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 124

    ("98_NULLS_LAST.ans", "query98_null.res", 2, 7, [TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.ALLTOSPACE], "I_ITEM_ID", 2, 7, [
     TYPEF.TOSPACE, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.TOTAB, TYPEF.ALLTOSPACE]),  # 125

    ("99_NULLS_FIRST.ans", "query99.res", 1, 8, [TYPEF.ALLTOPIPE]),  # 126

    ("99_NULLS_LAST.ans", "query99_null.res",
     2, 8, [TYPEF.TOPIPE, TYPEF.ALLTOTAB])  # 127




    #    ("18_NULLS_FIRST.ans","query18.res",1 ,11,[TYPEF.ALLTOPIPE]),
    #    ("18_NULLS_LAST.ans","query18_null.res",2 ,11,[TYPEF.TOSPACE,TYPEF.ALLTOPIPE]),
]

# answer 17 - modified
# 18_NULLS_LAST : tabs
# query 12: two lines, books without preceding tabs


# INPUT="/home/sbartkowski/work/v2.13.0rc1/answer_sets/12.ans"
#ANS12 = [TYPEF.TOSPACE,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.TOTAB,TYPEF.ALLNUMBER]
# WRITE="/tmp/res/query12.res"

def runone(l):
    INPUT = INPUTDIR + "/" + l[0]
    WRITE = OUTPUTDIR + "/" + l[1]
    headersno = l[2]
    nof = l[3]
    ans = l[4]

    sep = None
    headersno2 = None
    nof2 = None
    ans2 = None
    if len(l) > 5:
        sep = l[5]
        headersno2 = l[6]
        nof2 = l[7]
        ans2 = l[8]

    print(INPUT + " => " + WRITE)
    # numbers conversion
    ares = l[1]
    s = ares.split(".")
    aresnull = s[0] + "_null." + s[1]
    if ares in NUMBERS :
        numbers = NUMBERS[ares]
        print("Apply number conversion : {0}".format(numbers))
    elif aresnull in NUMBERS :
        numbers = NUMBERS[aresnull]
        print("Apply number conversion : {0}".format(numbers))
    else:
        numbers = None
    a = ANSTYPE(headersno, ans, nof, sep, headersno2, ans2, nof2, numbers)
    a.doanswerfile(INPUT, WRITE)


def main():
    for l in LISTOFRES:
        runone(l)


main()
#runone(LISTOFRES[11])
