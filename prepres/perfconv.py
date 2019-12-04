import os.path
import types
import logging

logging.basicConfig(level=logging.DEBUG)
logg = logging.getLogger('perfconv')

exec(open("./param.py").read())

STREAMNO=4
EXPECTEDSIZE=99

SEP1='|'
SEP2='|'

OUTPUT='/tmp/outres'

def isTuple(x) : return isinstance(x, tuple)

def flatten(T):
    if not isTuple(T): return (T,)
    elif len(T) == 0: return ()
    else: return flatten(T[0]) + flatten(T[1:]) 

def readfile(fname) :
    with open(fname) as f:
        lines = f.read().splitlines()
    res = []
    for e in lines :
        fields = e.split(SEP1)
        if len(fields) < 3 : continue
        tu = (fields[1],fields[2])
        res.append(tu)
    if len(res) != EXPECTEDSIZE :
        logg.error("%s - number of result lines %u does not match expected number %u",fname,len(res),EXPECTEDSIZE)
        raise Exception()
    return res

def aggrpower(res,p) :
    out = []
    for i in range(0,len(res)) :
        newt = (res[i],p[i][1])
        out.append(flatten(newt))
    return out

def writeoutput(res) :
    with open(OUTPUT,'w') as f :
        for e in res :
            next = False
            for fie in e : 
                if next : f.write(' ')
                f.write(fie.strip())
                f.write(' ' + SEP2)
                next = True
            f.write('\n')

def produceres(f1,f2,f3) :
    logg.info(f1)
    pow1 = readfile(f1)
    logg.info(f2)
    pow2 = readfile(f2)
    logg.info(f3)
    pow3 = readfile(f3)
    logg.info("Aggregate")

    return aggrpower(aggrpower(pow1,pow2),pow3)

def producepower() :
    res = produceres(INPUT1,INPUT2,INPUT3)
    writeoutput(res)

def prods(s,e,no) :
    re = e[no].replace('FAILED','FL')
    if s != '' : s = s + ' '
    return s + re

def combineres(res) :
    output = []
    numof = len(res[0])
    for i in range(0,numof) :
        k = ()
        s1 = ''
        s2 = ''
        s3 = ''
        for r in res :
            k = k + (r[i][0].replace('query','q'),)
            s1 = prods(s1,r[i],1)
            s2 = prods(s2,r[i],2)
            s3 = prods(s3,r[i],3)
        k = k + (s1,s2,s3)

        output.append(k)
    return output


def rangestreams() :
    l = ()
    for i in range(0,STREAMNO) : 
        c = chr(ord('0') + i)
        l = l + (produceres(INPUT1+c,INPUT2+c,INPUT3+c),)
    return l

def producethroughput() :
    o = combineres(rangestreams())
    print(o)
    writeoutput(o)


if RUN == 'power' : producepower()
else : producethroughput()