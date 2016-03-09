from PySteppables import *
from PySteppablesExamples import MitosisSteppableBase
import CompuCell
import sys
from random import uniform
from random import expovariate 
import math
from math import sqrt

class CellMigration2DSteppable(SteppableBasePy):    
    def __init__(self,_simulator,_frequency=1):
        SteppableBasePy.__init__(self,_simulator,_frequency)

    def start(self):
	pass
    def step(self,mcs):        
        totalFibers = 0
        for x,y,z in self.everyPixel():
             cell=self.cellField[x,y,z]
             if(cell and cell.type==3):
			totalFibers += 1
                        print totalFibers
        fileName='totalFibers.csv'
        try:
            fileHandle,fullFileName=self.openFileInSimulationOutputDirectory(fileName,"a")
        except IOError:
            print "Could not open file ", fileName," for writing. "
            return
        print >>fileHandle,totalFibers
        fileHandle.close()
        
        
    def finish(self):
        # Finish Function gets called after the last MCS
	pass