from util.readres import readtpcrun
from util.plot import plotpower,plothtpc,plothtpcstreams,plothtpccomparestreams

def __power1() :
    res = readtpcrun("db2.result0.env1.power.100")
    plotpower("DB2, 100 GB",res)

def __power2() :
    res = readtpcrun("db2.result0.evn2.100.power")
    plotpower("DB2, 100 GB",res)

def __power3() :
    res = readtpcrun("db2.result0.env2.power.1000")
    plotpower("DB2, 1T",res)

    
def __through1() :
    res0 = readtpcrun("db2.result0.env1.through.100")
    res1 = readtpcrun("db2.result1.env1.through.100")
    res2 = readtpcrun("db2.result2.env1.through.100")
    res3 = readtpcrun("db2.result3.env1.through.100")
    plothtpcstreams("DB2,100 GB, Throughput",[res0,res1,res2,res3])

def __through2() :
    res0 = readtpcrun("db2.result0.env2.through.100")
    res1 = readtpcrun("db2.result1.env2.through.100")
    res2 = readtpcrun("db2.result2.env2.through.100")
    res3 = readtpcrun("db2.result3.env2.through.100")
    plothtpcstreams("DB2,100 GB, Throughput",[res0,res1,res2,res3])
        
def __through3() :
    res0 = readtpcrun("db2.result0.env2.through.1000")
    res1 = readtpcrun("db2.result1.env2.through.1000")
    res2 = readtpcrun("db2.result2.env2.through.1000")
    res3 = readtpcrun("db2.result3.env2.through.1000")
    plothtpcstreams("DB2,1T, Throughput",[res0,res1,res2,res3])

def __comparepower1() :
    res0 = readtpcrun("db2.result0.evn2.100.power")
    res1 = readtpcrun("db2.result0.env1.power.100")
    plothtpc("DB2, 100GB, Compare ",[res0,res1],["Z/LinuxOne","X86 commodity"])

def __comparethrough1() :
    res10 = readtpcrun("db2.result0.env1.through.100")
    res11 = readtpcrun("db2.result1.env1.through.100")
    res12 = readtpcrun("db2.result2.env1.through.100")
    res13 = readtpcrun("db2.result3.env1.through.100")
    
    res20 = readtpcrun("db2.result0.env2.through.100")
    res21 = readtpcrun("db2.result1.env2.through.100")
    res22 = readtpcrun("db2.result2.env2.through.100")
    res23 = readtpcrun("db2.result3.env2.through.100")
    plothtpccomparestreams("DB2, 100GB, Compare Throughput",[[res20,res21,res22,res23],[res10,res11,res12,res13]],["Z/LinuxOne","X86 commodity"])
   

def main():
#    __power1()
#  __through1()
#  __power2()
#  __through2()
#  __power3()
#  __through3()
#  __comparepower1()
  __comparethrough1()


if __name__ == "__main__":
    main()