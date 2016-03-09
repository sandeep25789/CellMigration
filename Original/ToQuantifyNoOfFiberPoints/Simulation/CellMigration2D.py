
import sys
from os import environ
from os import getcwd
import string

sys.path.append(environ["PYTHON_MODULE_PATH"])

import CompuCellSetup

sim,simthread = CompuCellSetup.getCoreSimulationObjects()
            
# add extra attributes here
            
CompuCellSetup.initializeSimulationObjects(sim,simthread)
# Definitions of additional Python-managed fields go here
        
#Add Python steppables here
steppableRegistry=CompuCellSetup.getSteppableRegistry()
        
from CellMigration2DSteppables import CellMigration2DSteppable
steppableInstance=CellMigration2DSteppable(sim,_frequency=1)
steppableRegistry.registerSteppable(steppableInstance)

# from CellMigration2DSteppables import VolumeParamSteppable
# volumeParamSteppable=VolumeParamSteppable(sim,1)
# steppableRegistry.registerSteppable(volumeParamSteppable)

# from CellMigration2DSteppables import MitosisSteppable
# mitosisSteppable=MitosisSteppable(sim,1)
# steppableRegistry.registerSteppable(mitosisSteppable)

# from CellMigration2DSteppables import IdFieldVisualizationSteppable
# idFieldVisualizationSteppable=IdFieldVisualizationSteppable(sim,3000000000)
# steppableRegistry.registerSteppable(idFieldVisualizationSteppable)

# from CellMigration2DSteppables import CellMotilitySteppable
# cellMotilitySteppable=CellMotilitySteppable(sim,1)
# steppableRegistry.registerSteppable(cellMotilitySteppable)

# from CellMigration2DSteppables import MMPSecretionSteppable
# mmpSecretionSteppable=MMPSecretionSteppable(sim,1)
# steppableRegistry.registerSteppable(mmpSecretionSteppable)

# from CellMigration2DSteppables import ECMDegradationSteppable
# ecmDegradationSteppable=ECMDegradationSteppable(sim,1)
# steppableRegistry.registerSteppable(ecmDegradationSteppable)

# from CellMigration2DSteppables import RemoveOverCompressedCellsSteppable
# removeOverCompressedCellsSteppable=RemoveOverCompressedCellsSteppable(sim,10)
# steppableRegistry.registerSteppable(removeOverCompressedCellsSteppable)

# from CellMigration2DSteppables import PolarityEvolutionSteppable
# polarityEvolutionSteppable=PolarityEvolutionSteppable(sim,10)
# steppableRegistry.registerSteppable(polarityEvolutionSteppable)

CompuCellSetup.mainLoop(sim,simthread,steppableRegistry)
        
        
