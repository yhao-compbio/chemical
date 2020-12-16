# /usr/local/bin/python3.8
# created by Yun Hao @MooreLab 2020
# This script converts 2D sdf file of molecule to 3D sdf file 

## Modules 
import sys
from rdkit import Chem
from rdkit.Chem import AllChem

## Main function
def main(argv):
	
	## 1. Read in molecule structure from SDF file 
	sdf_mols = Chem.SDMolSupplier(argv[1])
	m1 = sdf_mols[0]

	## 2. Covert 2D struture to 3D structure 
	# add hydrogens to the molecule firs 
	mh = Chem.AddHs(m1)	 
	# convert to 3D 
	AllChem.EmbedMolecule(mh, randomSeed = 0xf00d)  
	
	## 3. Output to 3D sdf file 
	print(Chem.MolToMolBlock(mh), file = open(argv[2], 'w+'))

## Call main function
main(sys.argv)

