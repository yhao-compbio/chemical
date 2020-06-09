# !/usr/bin/env python
# created by Yun Hao @MooreLab 2019
# This script search CHEMBL for 2D/3D SDF files of compounds  

## Module 
import sys
import numpy as np
from chembl_webresource_client.new_client import new_client
from chembl_webresource_client.utils import utils

## Main function 
def main(argv):
	## Input argument
		# argv 1: input file that contains compound names 
		# argv 2: output folder 
	
	## 0. Read in all compound names 
	compound_name = np.loadtxt(argv[1], dtype = 'str', delimiter = '\n')
	compound_len = len(compound_name)
	
	## 1. Search CHEMBL for 2D/3D SDF files
	# set search format (SDF)
	molecule = new_client.molecule
	molecule.set_format('sdf')
	# iterate by compound 
	for i in range(0, compound_len):
		# obtain the compound name 
		ic = compound_name[i]
		# search CHEMBL
		res = molecule.search(ic)
		res_len = len(res)
		# Compound does not exist in CHEMBL 
		if res_len == 0:
			continue
		# Compound does existin CHEMBL, but does not have annotations
		elif res[0] is None:
			continue
		# Compound has annotation in CHEMBL
		else:
			# get rid of ' ' or '/' in the compound name (if exists)
			ic_join = '_'.join(ic.split())
			ic_join = ic_join.replace('/','')
			# write 2D SDF file (output file name: compound_name.2D.sdf) 
			op_file1 = argv[2] + ic_join + '.2D.sdf'
			with open(op_file1, 'w') as output:
				output.write(res[0])
				output.write('$$$$\n')
			# write 3D SDF file (output file name: compound_name.3D.sdf)
			op_file2 = argv[2] + ic_join + '.3D.sdf'
			with open(op_file2, 'w') as output:
				res_3D = utils.ctab23D(res[0])
				output.write(res_3D)
				output.write('$$$$\n')
	
	return 1


## Call main function
main(sys.argv)
