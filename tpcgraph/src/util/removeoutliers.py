from scipy import stats

TRESHOLD=3
VTOOHIGH=14440

def oldremoveoutliers(header,values) :
    cvalues = []
    for v in values : cvalues.extend(v)
    zz = stats.zscore(cvalues)
    for i in range(0,len(zz)) :
        if abs(zz[i]) > TRESHOLD : 
            ii = int(i / len(values[0])) # div
            jj = i % len(values[0]) # mod
            # h = header[jj]
            values[ii][jj] = 0

def __removeoutliers(header,values) :
    no = -1
    for v in values :
        no = no + 1
        zz = stats.zscore(v)
        for i in range(0,len(zz)) :
            z = zz[i]
            h = header[i]
            if h.startswith('q58') or h.startswith('q63') or h.startswith('q98') :
                i = 0

            if abs(zz[i]) > TRESHOLD : 
                v[i] = 0


# remove some nonrealistic numbers
# requieres investigation
def removeoutliers(header,values) :
    no = 0
    for v in values :
        no = no + 1
        for i in range(0,len(v)) :
            if v[i] > VTOOHIGH : v[i] = 0
