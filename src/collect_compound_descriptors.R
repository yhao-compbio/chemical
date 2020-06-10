# !usr/bin/Rscript 
# created by Yun Hao @MooreLab 2019
# This script collects computed molecular descriptors from multiple compounds.

## package
library(rcdk);

## 0. Input arguments
Args		<- commandArgs(T);
input_folder	<- Args[1];	# input folder of all descriptor files
feature_type	<- Args[2];	# descriptor type
output_folder	<- Args[3];	# output folder

## 1. Obtain names of compound files that belong to the feature type
# list all files in the folder
all_files <- list.files(input_folder);
# obtain the compound name, feature type from file name 
af_info <- mapply(function(af){
	af_s <- strsplit(af, "_")[[1]];
	as_len <- length(af_s);
	# compound name
	af_compound <- paste(af_s[1:(as_len-2)], collapse = "_");
	# feature type
	af_feature_type <- strsplit(af_s[[as_len]], ".txt")[[1]][[1]];
	return(c(af_compound, af_feature_type));
}, all_files);
# select files of the feature type 
ft_file_id <- which(af_info[2,] == feature_type);
# obtain all input file names 
ft_files <- sapply(all_files[ft_file_id], function(afffi) paste(input_folder, afffi, sep =""));
# obtain all compound names
ft_compounds <- af_info[1, ft_file_id];

## 2. Read in computed descriptors
#
ft_files_fp <- mapply(function(ff){
	ff_fp <- readLines(ff);
	ff_fp <- as.numeric(ff_fp);
	return(ff_fp);
}, ft_files);
ft_files_fp <- t(ft_files_fp);
# get descriptor names of the feature type 
dc_names <- get.desc.names(type = feature_type);
# exclude some constitutional descriptors that were not computed
if(feature_type == "constitutional"){
	not_cal_type <- c("org.openscience.cdk.qsar.descriptors.molecular.AcidicGroupCountDescriptor")
	dc_names <- setdiff(dc_names, not_cal_type)
}
# exclude some topological descriptors that were not computed
if(feature_type == "topological"){
	not_cal_type <- c("org.openscience.cdk.qsar.descriptors.molecular.WeightedPathDescriptor", "org.openscience.cdk.qsar.descriptors.molecular.ChiPathDescriptor", "org.openscience.cdk.qsar.descriptors.molecular.ChiPathClusterDescriptor", "org.openscience.cdk.qsar.descriptors.molecular.ChiClusterDescriptor")
	dc_names <- setdiff(dc_names, not_cal_type)
}
# add colnames (descriptor name) and rownames (compound names)
smiles <- c('CCC');
mols <- sapply(smiles, parse.smiles);
mol_desc <- eval.desc(mols, dc_names, verbose = F);
colnames(ft_files_fp) <- colnames(mol_desc);
rownames(ft_files_fp) <- ft_compounds;

## 3. Output collected descriptors 
op_file <- paste(output_folder, "_descriptor_", feature_type, ".tsv", sep = "");
write.table(ft_files_fp, op_file, sep = "\t", col.names = T, row.names = T, quote = F);


