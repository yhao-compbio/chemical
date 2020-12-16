# !/usr/bin/env python
# created by Yun Hao @MooreLab 2019
# This script generates shell scripts that compute molecular descriptors of compounds

## functions
source("src/functions.R");

## 0. Input arguments
Args			<- commandArgs(T);
job_name		<- Args[1];	# name of output shell scripts
sdf_file_folder		<- Args[2];	# folder of SDF file 
output_file_folder	<- Args[3];	# output folder

## 1. Obtain names of input files
# list all files in the folder
all_files <- list.files(sdf_file_folder);
# obtain the compound name, 2D/3D from file name  
all_files_info <- mapply(function(af){
	af_s <- strsplit(af, ".", fixed = T)[[1]];
	af_len <- length(af_s);
	# compound name
	af_name <- af_s[[1]];
	# 2D or 3D
	af_id <- af_s[[af_len-1]];
	return(c(af_name, af_id));
}, all_files, SIMPLIFY = T);
# select 3D files (required to compute molecular descriptors)
all_3d_files <- all_files[which(all_files_info[2,] == "3D")];
# obtain all input file names 
all_3d_files <- sapply(all_3d_files, function(a3f) paste(sdf_file_folder, a3f, sep = ""));
# generate all output file names 
all_3d_names <- all_files_info[1,which(all_files_info[2,] == "3D")];
output_files <- sapply(all_3d_names, function(a3n) paste(output_file_folder, a3n, sep = ""));

## 2. Generate commands for jobs 
commands <- mapply(function(a3f, of){
	command <- paste("Rscript", "src/compute_descriptors.R", a3f, of, sep = " ");
	return(command);
}, all_3d_files, output_files);
# write shell scripts for jobs
generate.parallel.bash.files(commands, 10, job_name, "src/run/");
