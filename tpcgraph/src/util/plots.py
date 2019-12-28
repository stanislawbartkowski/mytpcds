from util.readtable import readmd

import matplotlib.pyplot as plt
import numpy as np

def plotcoverage(tablename,title="Query coverage") :
    ta=readmd(tablename) 
    (header,values) = ta.coveragechangetobar()

    plt.figure(figsize=(9, 3))
    plt.bar(header, values)
    for i, v in enumerate(values):
        plt.text(i, 5, str(v) + " %", color='white',ha='center')

    plt.suptitle(title)
    plt.show()

def plotpower(tablename,title="TPC Power Test") :
    ta=readmd(tablename) 
    header,labels,values = ta.powerchangetobar()
    x = np.arange(len(header))  # the label locations
    height = 0.9 # height of the combined bar
    sheight = height / len(labels) # height of the single bar

    fig, ax = plt.subplots()
    startx = x - (height-sheight)/2 # beginning of the combined bar
    for i in range(0,len(values)) :
        v = values[i]
        label = labels[i]
#        ax.barh(startx,v,sheight,label=label)
        ax.barh(startx + (sheight*i),v,sheight,label=label)

    ax.set_xlabel("Time in sec")
    ax.set_title(title)
    ax.set_yticks(x)
    ax.set_yticklabels(header)
    ax.legend()
#    plt.savefig('foo.png')
#    plt.savefig("test.svg",format="svg")
    plt.subplots_adjust(left=0.07, right=0.99, top=0.98, bottom=0.05)
    plt.show()
    #mpld3.show()




