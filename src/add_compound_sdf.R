# !/usr/bin/env Rscript
# created by Yun Hao @MooreLab 2019
# This script searches, computes, and re-organizes 2D/3D sdf files for compounds that are missing from CHEMBL.
 
## 0. Input arguments 
offsides_file		<- "~/project/tox_data/downloads/offsides/OFFSIDES.csv.xz";
offsides_chembl_fd	<- "data/offsides_compounds/sdf/";
map_file		<- "data/bindingdb_compounds/bindingdb_2D_map.tsv";
bindingdb_sdf_fd	<- "data/bindingdb_compounds/sdf/";
add_sdf_fd		<- "data/offsides_compounds/sdf_add/";
missing_output		<- "data/offsides_compounds/still_missing_compounds";
manual_sdf_fd		<- "data/offsides_compounds/sdf_manual/";
manual_3d_sdf_fd	<- "data/offsides_compounds/sdf_manual_3d/";

## 1. Obtain offsides compounds without structure data from CHEMBL
# read in offsides compounds
offsides <- read.csv(file = offsides_file);
all_offside_compounds <- unique(offsides$drug_concept_name);
all_offside_compounds <- tolower(all_offside_compounds);
# read in chembl compounds 
all_chembl_files <- list.files(offsides_chembl_fd);
all_compound_names <- sapply(all_chembl_files, function(acf) strsplit(acf, ".", fixed = T)[[1]][[1]]);
all_compound_names <- unique(all_compound_names);
all_compound_names <- sapply(all_compound_names, function(acn){
	acn_s <- strsplit(acn, "_", fixed = T)[[1]];
	return(paste(acn_s, collapse = " "));
});
all_compound_names <- tolower(all_compound_names);
# identify missing compounds 
missing_compounds <- setdiff(all_offside_compounds, all_compound_names);

## 2. Obtain 2d/3d sdf files of missing compounds  
# read in compound name ~ ID map 
compound_map <- read.delim(file = map_file, sep = "\t", header = T);
compound_name_list <- lapply(as.character(compound_map$compound_name), function(cmcn) strsplit(cmcn, "::")[[1]]);
compound_name_len <- sapply(compound_name_list, length);
compound_id_list <- mapply(function(x, y) rep(x, y), compound_map$compound_bindingdb_id, compound_name_len);
all_compound_map <- data.frame(unlist(compound_id_list), unlist(compound_name_list));
colnames(all_compound_map) <- c("bindingdb_id", "Name");
all_compound_map$Name <- tolower(all_compound_map$Name);
all_compound_map <- unique(all_compound_map);
# match names of missing compounds to BindingDB IDs 
missing_id <- which(all_compound_map$Name %in% missing_compounds);
missing_map <- all_compound_map[missing_id,];
mm_compounds <- unique(missing_map$Name);
mm_ids <- sapply(mm_compounds, function(mc){
	mc_id <- which(missing_map$Name %in% mc)[[1]];
	return(missing_map$bindingdb_id[[mc_id]]);
});
# copy files that contain 2d/3d files of missing compounds to target folder
missing_file_cp <- mapply(function(mi, mc){
	# obtain names of source 2d/3d sdf files to be copied  
	source_2d_file <- paste(bindingdb_sdf_fd, mi, ".2D.sdf", sep = "");
	source_3d_file <- paste(bindingdb_sdf_fd, mi, ".3D.sdf", sep = ""); 
	# obtain names of target 2d/3d sdf files
	mc_s <- strsplit(mc, " ", fixed = T)[[1]];
	target_name <- paste(mc_s, collapse = "_");
	target_2d_file <- paste(add_sdf_fd, target_name, ".2D.sdf", sep = "");
	target_3d_file <- paste(add_sdf_fd, target_name, ".3D.sdf", sep = "");
	# copy files 
	system(paste("cp", source_2d_file, target_2d_file, sep = " "));
	system(paste("cp", source_3d_file, target_3d_file, sep = " "));
	return(1);
}, mm_ids, mm_compounds);
# identify compounds that are still missing (will manually search for sdf files for these compounds) 
still_missing_compounds <- setdiff(missing_compounds, mm_compounds);
writeLines(still_missing_compounds, paste(missing_output, ".txt", sep = "")); 

## 3. Search from PubChem for 2D/3D structure of compounds that are still missing, then convert 2D structure to 3D for compounds with missing 3D sdf files 
# done manually 

## 4. Copy added files to the same folder and rename them with formal compound names  
# read in compound name ~ PubChem CID map  
missing_map <- read.delim(file = paste(missing_output, "_map.tsv", sep = ""), header = T, sep = "\t");
d2_id <- which(missing_map$X2d != "");
missing_map <- missing_map[d2_id,];
# match formal compound names with corresponding CIDs   
compound_names <- sapply(missing_map$compound, function(mmc){
	# remove ',', '.', '(', and ')'
	mmc_s <- strsplit(mmc, "", fixed = T)[[1]];
	c_id <- which(mmc_s %in% c(",", ".", "(", ")"));
	o_id <- setdiff(1:length(mmc_s), c_id);
	mmc_s <- mmc_s[o_id];
	# substitue ' ' with '_'
	mmc <- paste(mmc_s, collapse = "");
	mmc_s <- strsplit(mmc, " ", fixed = T)[[1]];
	mmc_p <- paste(mmc_s, collapse = "_");
	return(mmc_p);
});
compound_cids <- sapply(missing_map$X2d, function(mmx) strsplit(mmx, "Structure2D_", fixed = T)[[1]][[2]]);
names(compound_names) <- compound_cids;
# copy 2d PubChem sdf files to target folder 
copy_2d <- mapply(function(cn, mmx){
	source_file <- paste(manual_sdf_fd, mmx, sep = "");
	target_file <- paste(add_sdf_fd, cn, ".2D.sdf", sep = "");
	system(paste("cp", source_file, target_file, sep = " "));
	return(1);
}, compound_names, missing_map$X2d);
# copy 3d PubChem sdf files to target folder 
d3_id <- which(missing_map$X3d != "");
copy_3d <- mapply(function(cn, mmx){
	source_file <- paste(manual_sdf_fd, mmx, sep = "");
	target_file <- paste(add_sdf_fd, cn, ".3D.sdf", sep = "");
	system(paste("cp", source_file, target_file, sep = " "));
	return(1);
}, compound_names[d3_id], missing_map$X3d[d3_id]);
# copy computed 3d sdf files to target folder 
all_d3_files <- list.files(manual_3d_sdf_fd);
copy_c3d <- mapply(function(adf){
	adf_s <- strsplit(adf, "Conformer3D_", fixed = T)[[1]][[2]];
	cn <- compound_names[[adf_s]];
	source_file <- paste(manual_3d_sdf_fd, adf, sep = "");
	target_file <- paste(add_sdf_fd, cn, ".3D.sdf", sep = "");
	system(paste("cp", source_file, target_file, sep = " "));
	return(1);
}, all_d3_files);

