from typing import List
from util.mytype import RUNRESULT, TPCRUN
import matplotlib.pyplot as plt
import numpy as np

__MINANNOTGAP: int = 20
__MAXANNOTGAP: int = 40


def __transform(res: List[TPCRUN]):
    labels: List[str] = [str(res[i].querynum) for i in range(len(res))]
    values: List[int] = [
        res[i].sec if res[i].result == RUNRESULT.PASSED else 0
        for i in range(len(res))
    ]
    result: List[RUNRESULT] = [res[i].result for i in range(len(res))]
    return (labels, values, result)


def __genlabel(i: int, values: List[int], results: List[RUNRESULT]) -> str:
    label: str = (str(values[i])
                  if results[i] == RUNRESULT.PASSED else results[i].name)
    return label


def __calcgap(i: int, v: List[int]) -> float:
    ann: int = v[i] / 50
    return min(max(__MINANNOTGAP, ann), __MAXANNOTGAP)


def __plotpower(title: str, labels: List[str], values: List[int],
                results: List[RUNRESULT]):

    x = 0.5 + np.arange(len(labels))
    y = values

    # plot
    fig, ax = plt.subplots()
    ax.set_title(title)
    ax.set_ylabel("Time in sec")
    ax.set_xlabel("Queries")

    ax.bar(x, y, width=1, edgecolor="white", linewidth=0.7)
    for i in range(len(values)):
        label: str = __genlabel(i, values, results)
        ann: int = __calcgap(i, values)
        ax.annotate(label, (i + 0.8, values[i] + ann),
                    xycoords='data',
                    rotation=90,
                    rotation_mode="anchor",
                    size=8)

    ax.set(xlim=(0, len(labels)), xticks=x)
    ax.set_xticklabels(labels,
                       rotation=90,
                       rotation_mode="anchor",
                       va='center')

    plt.show()


def __gentick(i: int, labels: List[List[str]]) -> str:
    res: str = None
    for l in labels:
        res = l[i] if res is None else res + "/" + l[i]
    return res


def __plothbar(title: str, labels: List[List[str]], values: List[List[int]],
               results: List[List[RUNRESULT]], legend: List[str]):

    fig, ax = plt.subplots()
    ax.set_xlabel("Time in sec")
    ax.set_title(title)
    ax.set_ylabel("Queries")
    ax.invert_yaxis()
    no: int = len(values[0])

    x: List[int] = np.arange(no)  # the label locations
    height: float = 0.9  # height of the combined bar
    sheight: float = height / len(legend)  # height of the single bar
    startx: List[float] = x - (height -
                               sheight) / 2  # beginning of the combined bar

    for i in range(len(legend)):
        l: List[str] = labels[i]
        v: List[int] = values[i]
        r: List[RUNRESULT] = results[i]
        y: List[float] = startx + (sheight * i)
        ax.barh(y, v, sheight, label=legend[i])
        for k in range(len(v)):
            label: str = __genlabel(k, v, r)
            ann: int = __calcgap(k, v)
            ax.annotate(label, (v[k] + ann, y[k]),
                        xycoords='data',
                        size=6,
                        va='center')

    ax.legend(legend)
    ticks: List[str] = [__gentick(i, labels) for i in range(no)]
    ax.set_yticks(x)
    ax.set_yticklabels(ticks, size=6, va='center')
    plt.subplots_adjust(left=0.07, right=0.99, top=0.96, bottom=0.05)
    plt.margins(y=0)

    plt.show()


def plotpower(title: str, res: List[TPCRUN]):
    labels, values, result = __transform(res)

    __plotpower(title, labels, values, result)


def plothtpc(title: str, res: List[List[TPCRUN]], streams: List[str]):
    labels: List[List[str]] = []
    values: List[List[int]] = []
    results: List[List[RUNRESULT]] = []

    for i in range(len(res)):
        l, v, r = __transform(res[i])
        labels.append(l)
        values.append(v)
        results.append(r)

    __plothbar(title, labels, values, results, streams)


def plothtpcstreams(title: str, res: List[List[TPCRUN]]):
    plothtpc(title, res, ["Stream 0", "Stream 1", "Stream 2", "Stream 3"])

def plothtpccomparestreams(title: str, res: List[List[List[TPCRUN]]], labels: List[str]):
    assert(len(res) == len(labels))

    # create labels from first    
    labs: List[List[str]] = []
    t : List[List[TPCRUN]]  = res[0]
    for i in range(len(t)):
        l, _ , _ = __transform(t[i])
        labs.append(l)

    values: List[List[int]] = []
    results: List[List[RUNRESULT]] = []
    # cumulate the results
    for i in range(len(labels)):
        re : List[List[TPCRUN]] = res[i]
        vv : List[int] = None
        rr : List[RUNRESULT] = None
        for rese in re :
            _, v, r = __transform(rese)
            if vv is None :
                vv = v
                rr = r
            else :
                for i in range(len(vv)) :
                    if rr[i] != RUNRESULT.TIMEOUT:
                        if r[i] == RUNRESULT.FAILED : rr[i] = RUNRESULT.FAILED
                        elif r[i] == RUNRESULT.TIMEOUT : rr[i] = RUNRESULT.TIMEOUT
                    if rr[i] == RUNRESULT.PASSED :
                        vv[i] += v[i]
                    else : vv[i] = 0
        values.append(vv)
        results.append(rr)
    
    __plothbar(title, labs, values, results, labels)

    
    
                    
                        
            
            
        
        
        
        
        
            
            
    
    
    
        
    
        
