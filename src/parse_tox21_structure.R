# !/usr/bin/env python
# created by Yun Hao @MooreLab 2019
# This script parses chemical structure data of tox21 compounds to compute chemical fingerprints 

## package
library(rcdk);

## 0. Input arguments
structure_file	<- "~/project/tox_data/downloads/tox21/tox21_10k_library_info.tsv";
output_file	<- "data/tox21_compounds/fingerprint_combined/tox21_compounds";

## 1. Obtain chemical structure of tox21 compounds 
# read in tox21 compound library file, extract columns that contain pubchem ID and SMILES 
library_df <- read.delim(file = structure_file, sep = "\t", header = T);
structure_df <- unique(library_df[, c("PUBCHEM_CID", "SMILES")]);
# parse SMILES character
library_mols <- parse.smiles(structure_df$SMILES);
library_len <- sapply(library_mols, length);
library_id <- which(library_len > 0);
library_mols <- library_mols[library_id];
# process pubchem CIDs
mol_names <- sapply(structure_df$PUBCHEM_CID[library_id], function(sdpc) paste("CID", sdpc, sep = "_"));

## 2. Specify names of chemical fingerprints to be computed  
# 10 types of fingerprints 
fp_types <- c("standard", "extended", "graph", "hybridization", "maccs", "estate", "pubchem", "shortestpath", "circular");

## 3. Compute chemical fingerprints
# iterate by fingerprint type 
calculate_fingerprint <- sapply(fp_types, function(ft){
	mol_fp <- mapply(function(lim){
		# compute fingerprint bit
		fps <- get.fingerprint(lim, type = ft);
		# convert bit to full vector
		N_bit <- fps@nbit;
		bits <- fps@bits;
		fp_vec <- rep(0, N_bit);
		fp_vec[bits] <- 1;
		return(fp_vec);
	}, library_mols);
	mol_fp <- t(mol_fp);
	rownames(mol_fp) <- mol_names;
	colnames(mol_fp) <- sapply(1:ncol(mol_fp), function(nmf) paste("FP", nmf, sep = ""));
        # output computed fingerprints 
	outname <- paste(output_file, "_fingerprint_", ft, ".tsv", sep = "");
	write.table(mol_fp, file = outname, sep = "\t", col.names = T, row.names = T, quote = F);	
	return(1);
});
