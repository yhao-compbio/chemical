# !/usr/bin/env python
# created by Yun Hao @MooreLab 2019
# This script computes chemical fingerprints of input molecules  

## package
library(rcdk);

## 0. Input arguments
Args		<- commandArgs(T);
sdf_file	<- Args[1];	# input SDF file
output_file	<- Args[2];	# output file

## 1. Specify names of chemical fingerprints to be computed  
# molecular descriptors 
fp_types <- c("standard", "extended", "graph", "hybridization", "maccs", "estate", "pubchem", "kr", "shortestpath", "circular");

## 2. Compute chemical fingerprints
# load molecules  
mols <- load.molecules(sdf_file)[[1]];
# iterate by fingerprint type 
calculate_fingerprint <- sapply(fp_types, function(ft){
	# compute fingerprint bit
	fps <- get.fingerprint(mols, type = ft);
	if(length(fps) > 0){
		# convert bit to full vector
		N_bit <- fps@nbit
		bits <- fps@bits
		fp_vec <- rep(0, N_bit)
		fp_vec[bits] <- 1	
        	# output
		outname <- paste(output_file, "_fingerprint_", ft, ".txt", sep = "")
		writeLines(as.character(fp_vec), outname)
		return(1)
	}
	else	return(0)
});
