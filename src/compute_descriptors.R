# !/usr/bin/env python
# created by Yun Hao @MooreLab 2019
# This script computes molecular descriptors of input molecules 

## package
library(rcdk);

## 0. Input arguments
Args <- commandArgs(T);
sdf_file	<- Args[1];	# input SDF file
output_file	<- Args[2];	# output file

## 1. Obtain names of molecular descriptors to be computed
# obtain categories
desc_cates <- get.desc.categories();
# iterate by category
desc_names <- lapply(desc_cates, function(dc){
	# obtain names of molecular descriptors that belong to the catetory
	dc_names <- get.desc.names(type = dc);
	# some constitutional descriptors cannot be calculated
	if(dc == "constitutional"){
		not_cal_type <- c("org.openscience.cdk.qsar.descriptors.molecular.AcidicGroupCountDescriptor")
		dc_names <- setdiff(dc_names, not_cal_type)
	}
	# some topological descriptors cannot be calculated
	if(dc == "topological"){
		not_cal_type <- c("org.openscience.cdk.qsar.descriptors.molecular.WeightedPathDescriptor", "org.openscience.cdk.qsar.descriptors.molecular.ChiPathDescriptor", "org.openscience.cdk.qsar.descriptors.molecular.ChiPathClusterDescriptor", "org.openscience.cdk.qsar.descriptors.molecular.ChiClusterDescriptor")
		dc_names <- setdiff(dc_names, not_cal_type)
	}
	return(dc_names);
});

## 2. Compute molecular descriptors
# load molecules  
mols <- load.molecules(sdf_file)[[1]];
# iterate by descriptor
calculate_descriptor <- mapply(function(dn, dc){
	# compute the descriptor	
	descs <- eval.desc(mols, dn, verbose = T);
	# output 
	outname <- paste(output_file, "_descriptor_", dc, ".txt", sep = "");
	writeLines(as.character(descs), outname);
	return(1);
}, desc_names, desc_cates);
