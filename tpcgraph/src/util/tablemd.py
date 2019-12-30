
class TABLEMD :

    def __split(self,line) :
        ls = line.split("|")
        re = []
        for l in ls : re.append(l.strip())
        # remove the first column, always empty
        # check first column if empty
        if re[0] == "" : return re[1:]
        else: return re

    def __transform(self,header,content) :
        self.header = self.__split(header)
        no = len(self.header)
        self.content = []
        for l in content :
            li = self.__split(l)
            if no != len(li) :
                raise Exception(l + "  Expected numer of column:" + str(no) + ", got:" + str(len(li)))
            self.content.append(li)

    def __init__(self,attr,header,content) :
        self.attr = attr
        self.__transform(header,content)

    def coveragechangetobar(self) :
        """ Changes the data into bar, percentage of coverage
            Args: no args
            Returns: 
                tuple: (header,values)
                header : ["Hive","SparkSQL","BigSQL"]
                values : [67,97,99]

        """ 
        # remove the first column, query
        header = self.header[1:]
        values = [0 for j in range(0,len(header))]
        # ignore first column, query name
        for i in range(0,len(self.content)) :
            for j in range(0,len(header)) :
                # ignore first column, query name
                # skip FAILED, FL     
                cell = self.content[i][j+1]
                if cell.find("F") == -1 : values[j] = values[j] + 1
        # transform to percentage * 100
        for i in range(0,len(values)) :
            values[i] = round((values[i] * 100.00) / len(self.content),2)
        return (header,values)

    def __createlist(self,header,gencell,genzeros,transline) :
        """ Changes the data into horizontal bar, power results
            Args: no args
            Returns: 
                tuple: (header,labels,values)
                header : ["query1","query2","query3" ... ]
                labels : [["Hive","SparkSQL","BigSQL"]
                values : [[gencell or zeors,97,99,....],[45,88,99,.....],[23,45,23.....]]
        """ 
        # remove the first column, query
        labels = header[1:]
        zeros = genzeros(labels)
        values = [ [] for i in range(0,len(labels)) ]
        headers = []
        for lr in self.content :
            l = transline(lr)
            headers.append(l[0]) # query name in the first column
            for j in range(1,len(header)) :
                cell = l[j]
                if cell.find("F") == -1 and cell.find("T") == -1  : values[j-1].append(gencell(cell))
                else : values[j-1].append(zeros)
        return headers,labels,values

    def powerchangetobar(self) :
        """ Changes the data into horizontal bar, power results
            Args: no args
            Returns: 
                tuple: (header,labels,values)
                header : ["query1","query2","query3" ... ]
                labels : [["Hive","SparkSQL","BigSQL"]
                values : [[67,97,99,....],[45,88,99,.....],[23,45,23.....]]
        """ 
        return self.__createlist(self.header,lambda c : int(c),lambda label : 0, lambda lr : lr)

    # local methods for lamba putchangetobar

    def __trans(self,lr) :
        return [ lr[0] + ' ' + lr[1] + ' ' + lr[2] + ' ' + lr[3],lr[4],lr[5],lr[6]]
        
    def putchangetobar(self) :
        """ Changes the data into horizontal bar, throughput results
            Args: no args
            Returns: 
                tuple: (header,labels,values)
                header : ["query1 query54 q23 q18","query2 q11 q22 q33","query3 q67 q23 q78" ... ]
                labels : [["Hive","SparkSQL","BigSQL"]
                values : [[[67,34,77,88] ,[97,11,33,55],[99,11,23,56],....],[[45 ..],[88..],[99..],.....],[[23 ..],[45 ..],[23 ..].....]]
        """ 
        return self.__createlist(self.__trans(self.header),
                                 lambda c : [int(v.strip()) for v in c.split(' ')],
                                 lambda label : [ 0 for i in range(0,len(label))],
                                 lambda lr : self.__trans(lr)
                                 )
