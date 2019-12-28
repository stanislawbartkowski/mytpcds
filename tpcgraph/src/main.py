from util.readtable import readmd

import matplotlib.pyplot as plt
import matplotlib
import numpy as np
import mpld3
# from basic_units import cm, inch

from util.plots import plotcoverage,plotpower

def readtest() :
   ta=readmd("1") 
   (header,values) = ta.coveragechangetobar()
   print(header,values)

   plt.figure(figsize=(9, 3))
   plt.bar(header, values)
   for i, v in enumerate(values):
      plt.text(i, 5, str(v) + " %", color='white',ha='center')

   plt.suptitle('Query coverage')
   plt.show()

def read1() :
#   plotcoverage("1","Query coverage")
   plotpower("1","Query coverage")

def read2test() :
   ta=readmd("1") 
   header,labels,values = ta.powerchangetobar()
   print(header,labels,values)

# ==================================   

def autolabel(ax,rects):

    """Attach a text label above each bar in *rects*, displaying its height."""
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')


def plottest1() :
   labels = ['G1', 'G2', 'G3', 'G4', 'G5','G6','G7','G8']
   men_means = [20, 34, 30, 35, 27,45,5,23]
   women_means = [25, 32, 34, 20, 25,8,5,17]
   nextw = [2, 3, 36, 15, 17,12,5,12]

   scores = [men_means,women_means,nextw]

   x = np.arange(len(labels))  # the label locations
   height = 0.9  # the width of the bars
   sheight = height / len(scores)

   fig, ax = plt.subplots()
#   fig.set_figheight(len(labels) * len(scores) * (width + space) * fig.dpi)
#   fig.set_figheight(99 * len(scores) * (height + space))
   
   startx = x - (height-sheight)/2 
   
   for i in range(0,len(scores)) :
#      ax.barh(startx + (sheight * i), scores[i], sheight, label=str(i))
      ax.barh(startx + (sheight * i), scores[i], sheight, label=str(i))
#   rects1 = ax.barh(x - width/2, men_means, width, label='Men')
#   rects2 = ax.barh(x + width/2, women_means, width, label='Women')

   # Add some text for labels, title and custom x-axis tick labels, etc.
   ax.set_xlabel('Scores')
   ax.set_title('Scores by group and gender')
   ax.set_yticks(x)
   ax.set_yticklabels(labels)
#   ax.yaxis.set_units(inch)
   #ax.autoscale_view()
   ax.legend()

   #autolabel(ax,rects1)
   #autolabel(ax,rects2)

   #fig.tight_layout()

#   plt.show()
   mpld3.show()


# ------------------------------   


def plottest() :
   names = ['group_a', 'group_b', 'group_c']
   values = [1, 10, 100]

   plt.figure(figsize=(9, 3))

   #plt.subplot(131)
   plt.bar(names, values)
   #plt.subplot(132)
   #plt.scatter(names, values)
   #plt.subplot(133)
   #plt.plot(names, values)
   plt.suptitle('Categorical Plotting')
   for i, v in enumerate(values):
      plt.text(i, 5, str(v) + " %", color='white',ha='center')
   plt.show()

def plottest2() :
# Fixing random state for reproducibility
   np.random.seed(19680801)


   plt.rcdefaults()
   fig, ax = plt.subplots()

   # Example data
   people = ('Tom', 'Dick', 'Harry', 'Slim', 'Jim')
   y_pos = np.arange(len(people))
   performance = 3 + 10 * np.random.rand(len(people))
   error = np.random.rand(len(people))

   ax.barh(y_pos, performance, xerr=error, align='center')
   ax.set_yticks(y_pos)
   ax.set_yticklabels(people)
   ax.invert_yaxis()  # labels read top-to-bottom
   ax.set_xlabel('Performance')
   ax.set_title('How fast do you want to go today?')

   plt.show()   

#plottest()   
read1()
#plottest1()
#plottest2()

#read2test()
