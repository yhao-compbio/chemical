# !usr/bin/Rscript 
# created by Yun Hao @MooreLab 2019
# This script combines different types of molecular descriptors into one single file. 

## functions
source("src/functions.R");

## 0. Input arguments
Args <- commandArgs(T);
combine_input	<- Args[1];	# name of input file that specifies molecular descriptor files to be combined, along with the descriptor types
na_ratio	<- Args[2];	# lower bound of the proportion of NA's for a descriptor to be removed  
combine_output	<- Args[3];	# name of output file  

## 1. Obtain descriptor file names and descriptor types 
input_df <- read.delim(file = combine_input, header = T, sep = "\t");
# descriptor file names
feature_types <- as.character(input_df$feature_type);
# descriptor types 
feature_files <- as.character(input_df$file);

## 2.Perform quality control on the dataset
# Checks the quality of computed descriptors based on the proportion of NA's  
na_ratio <- as.numeric(na_ratio);
data_df_list <- lapply(feature_files, function(ff) check.descriptors.quality(ff, na_ratio)); 
# Add descriptor type as prefix of column names 
data_df_list <- mapply(function(ddl, ft){
	colnames(ddl) <- sapply(colnames(ddl), function(cd) paste(ft, cd, sep = "_"));
	return(ddl);
}, data_df_list, feature_types, SIMPLIFY = F);
# Select descriptors with complete data 
sample_list <- lapply(data_df_list, rownames);
samples <- unlist(sample_list);
sample_table <- table(samples);
inter_samples <- names(sample_table)[which(sample_table == length(feature_types))];
data_df_list <- lapply(data_df_list, function(ddl) ddl[inter_samples,]);
combine_df <- do.call(cbind, data_df_list);

## 3. Output combined descriptors 
write.table(combine_df, file = combine_output, sep = "\t", row.names = T, col.names = T, quote = F);

