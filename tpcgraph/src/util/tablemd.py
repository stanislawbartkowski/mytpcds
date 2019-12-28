
class TABLEMD :

    def __split(self,line) :
        ls = line.split("|")
        re = []
        for l in ls : re.append(l.strip())
        # remove the first column, always empty
        return re[1:]

    def __transform(self,header,content) :
        self.header = self.__split(header)
        no = len(self.header)
        self.content = []
        for l in content :
            li = self.__split(l)
            if no != len(li) :
                raise Exception(l + " expected numer of column:" + no + ", got:" + len(len(li)))
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
        values = []
        # ignore first column, query name
        for j in range(0,len(header)) : values.append(0)
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

    def powerchangetobar(self) :
        """ Changes the data into horizontal bar, power results
            Args: no args
            Returns: 
                tuple: (header,labels,values)
                header : ["query1","query2","query3" ... ]
                labels : [["Hive","SparkSQL","BigSQL"]
                values : [[67,97,99,....],[45,88,99,.....],[23,45,23.....]]
        """ 
        # remove the first column, query
        labels = self.header[1:]
        values = []
        header = []
        for i in range(0,len(labels)) : values.append([])
        for l in self.content :
            header.append(l[0]) # query name in the first column
            for j in range(1,len(self.header)) :
                cell = l[j]
                if cell.find("F") == -1 and cell.find("T") == -1  : values[j-1].append(int(cell)) 
                else : values[j-1].append(0)
        return header,labels,values
