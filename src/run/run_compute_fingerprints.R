# !/usr/bin/env python
# created by Yun Hao @MooreLab 2019
# This script generates shell scripts that compute chemical fingerprints of compounds

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
# select 2D files (required to compute chemical fingerprints)
all_2d_files <- all_files[which(all_files_info[2,] == "2D")];
# obtain all input file names 
all_2d_files <- sapply(all_2d_files, function(a2f) paste(sdf_file_folder, a2f, sep = ""));
# generate all output file names 
all_2d_names <- all_files_info[1,which(all_files_info[2,] == "2D")];
output_files <- sapply(all_2d_names, function(a2n) paste(output_file_folder, a2n, sep = ""));

## 2. Generate commands for jobs 
commands <- mapply(function(a2f, of){
	command <- paste("Rscript", "src/compute_fingerprints.R", a2f, of, sep = " ");
	return(command);
}, all_2d_files, output_files);
# write shell scripts for jobs
generate.parallel.bash.files(commands, 10, job_name, "src/run/");
