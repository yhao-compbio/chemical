# !/usr/bin/env Rscript
# created by Yun Hao @MooreLab 2019
# This script contains R functions required for other scripts in the folder.

## This function generates executable shell scripts that will run input commands 
generate.parallel.bash.files <- function(all_commands, N_group, job_name, folder){
	## 0. input arguments 
		# all_commands: a vector of commands that are to be run
		# N_group: number of groups that commands will be split into  
		# job_name: name of job 
		# folder: name of folder where shell scripts will be written 

	## 1. Assign the indices of commands to each group 
	# obtain the number of commands in each group
	N_group_member <- ceiling(length(all_commands) / N_group);
	# obtain upper bound of index for each group 
	upper_bound <- 1:N_group * N_group_member;
	ub_id <- min(which(upper_bound >= length(all_commands)));
	upper_bound <- upper_bound[1:ub_id];
	upper_bound[[ub_id]] <- length(all_commands);
	# obtain lower bound of index for each group 
	lower_bound <- 0:(ub_id-1) * N_group_member + 1;
	# assign commands to each group (lower bound - upper bound)
	command_list <- mapply(function(lb, ub) all_commands[lb:ub], lower_bound, upper_bound, SIMPLIFY = F);
	
	## 2. write commands into executable shell scripts
	# name executable shell scripts by "job_nameX.sh" (X is the index of script)
	setwd(folder);
	c_file_name <- sapply(1:ub_id, function(gn) paste(job_name, gn, ".sh", sep = ""));
	# iterate by script
	write_sub_files <- mapply(function(cl, cfn){
		# write commands into the script
		writeLines(cl, cfn);
		# make the script executable
		system(paste("chmod", "775", cfn, sep=" "));
		return(1);
	},command_list,c_file_name,SIMPLIFY=F);
	
	## 3. write an executable shell script that runs all the scripts above  
	final_command <- sapply(c_file_name,function(cfn) paste("./", folder, cfn," &", sep = ""));
	# name executable shell scripts by "job_name.sh" 
	final_file <- paste(job_name, ".sh", sep = "");
	writeLines(final_command, final_file);
	# make the script executable
	system(paste("chmod","775", final_file, sep = " "));

	return("DONE");
}

## This function checks the quality of computed descriptors based on the proportion of NA's. 
check.descriptors.quality <- function(file_name, na_prop = 0.5){
	## 0. Input arguments 
        	# file_name: name of descriptor file  
		# na_prop: lower bound of the proportion of NA's for a descriptor to be removed 
	
	## 1. Read in descriptor data 	
        descriptor_df <- read.delim(file = file_name, header = T, sep = "\t");
        # number of samples 
	N_sample <- nrow(descriptor_df);

	## 2. Remove NA's in the descriptors   
        # count the number of NA's for each feature 
        feature_na_count <- sapply(colnames(descriptor_df), function(cdd){
                na_len <- sum(is.na(descriptor_df[,cdd]));
                return(na_len);
        });
	# remove columns of which the proportion of NA's is less than na_prop
        feature_id <- which(feature_na_count < N_sample * na_prop);
        descriptor_df <- descriptor_df[,feature_id];
        # remove rows in which NA's still exist
        sample_na <- sapply(1:nrow(descriptor_df), function(ndd) sum(is.na(descriptor_df[ndd,])));
        nna_id <- which(sample_na == 0);
        descriptor_df <- descriptor_df[nna_id, ];
	# remove rows in which Inf's exists 
	sample_rs <- abs(rowSums(descriptor_df));
	inf_id <- which(sample_rs != Inf);
	descriptor_df <- descriptor_df[inf_id, ];	
	        
	return(descriptor_df);
}
