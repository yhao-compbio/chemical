# !usr/bin/Rscript 
# created by Yun Hao @MooreLab 2019
# This script parses raw BindingDB data to obtain 2D/3D SDF file of compounds.   

## function  
library(parallel);

## 0. Input arguments 
Args		<- commandArgs(T);
dimension	<- Args[1];     # 2D/3D

## 1. Read in BindingDB
# obtain input file name 
input_file_name <- paste("downloads/BindingDB/BindingDB_All_terse_", dimension, ".sdf", sep = "");
bindingdb_lines <- readLines(input_file_name);

## 2. Obtain compound name/ID 
# obtain compound bindingdb monomer ID 
monomer_id <- which(bindingdb_lines %in% "> <BindingDB MonomerID>") + 1;
compound_ids <- bindingdb_lines[monomer_id];
# obtain compound name 
name_id <- which(bindingdb_lines %in% "> <BindingDB Ligand Name>") + 1;
compound_names <- bindingdb_lines[name_id];
N_compound <- length(compound_ids);
# last line of each compound SDF 
block_id <- which(bindingdb_lines %in% "$$$$");
# first line of each compound SDF 
begin_line_id <- c(0, block_id[1:(N_compound - 1)]) + 1;

## 3. Write compound SDF files
# iterate by compound 
compound_write <- mcmapply(function(bli, bi, ci){
	# range of the compound SDF lines
	c_lines <- bindingdb_lines[bli:bi];
	# write to output file
	out_name <- paste("data/bindingdb_compounds/sdf/", ci, ".", dimension, ".sdf", sep = "");
	writeLines(c_lines, out_name);
	
	return(1);
}, begin_line_id, block_id, compound_ids, mc.cores = 10);

## 4. Write compound name ~ monomer ID mapping file 
# output as a data frame (column 1: monomer ID, column 2: compound name) 
names_df <- data.frame(compound_ids, compound_names);
colnames(names_df) <- c("compound_bindingdb_id", "compound_name");
out_map_name <- paste("data/bindingdb_compounds/bindingdb_", dimension, "_map.tsv", sep = "");
write.table(names_df, out_map_name, sep = "\t", col.names = T, row.names = F, quote = F);

