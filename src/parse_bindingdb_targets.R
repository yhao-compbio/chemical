# !usr/bin/Rscript 
# created by Yun Hao @MooreLab 2019
# This script parses raw BindingDB data to obtain compound-target binding affinities. 

## function 
library(parallel);
source("src/functions.R");

## 0. Input arguments 
binding_file	<- "downloads/bindingdb/BindingDB_All.tsv";
id_map_file	<- "downloads/uniprot/uniprot-filtered-organism%3A%22Homo+sapiens+%28Human%29+%5B9606%5D%22+AND+review--.tab";
output_file	<- "data/bindingdb_targets/bindingdb_human_targets";

## 1. Read in ligand-target interation data from BindingDB
#  
binding_df <- read.delim(file = binding_file, header = T, sep = "\t");
# select relevant columns 
col_ss <- c("UniProt..SwissProt..Primary.ID.of.Target.Chain", "BindingDB.MonomerID", "Ki..nM.", "IC50..nM.", "Kd..nM.", "EC50..nM.");
binding_df1 <- binding_df[,col_ss];
colnames(binding_df1) <- c("target_uniprot_id", "ligand_bindingdb_id", "ki", "ic50", "kd", "ec50");

## 2. Perform quality control on ligand/target names
# read in all human proteins from Uniprot (only keep the targets in human genome) 
uniprot_df <- read.delim(file = id_map_file, header = T, sep = "\t");
all_human_proteins <- as.character(uniprot_df$Entry);
target_names <- as.character(binding_df1$target_uniprot_id);
ahp_id <- which(target_names %in% all_human_proteins);
binding_df1 <- binding_df1[ahp_id,];
# remove data entrties with missing ligand name
ligand_names <- as.character(binding_df1$ligand_bindingdb_id);
nna_id <- which(ligand_names != "");
binding_df1 <- binding_df1[nna_id,];

## 3. Group entries by measurement type, then process each group separately 
measure_types <- c("ki", "ic50", "kd", "ec50");
measure_names <- c("pKi", "pIC50", "pKd", "pEC50");
# iterate by measurement type
measure_type_affinities <- mapply(function(mt, mn){
	## 3.1 Perform quality control on the measurement type 
	# extract the meansurement column
	binding_df2 <- binding_df1;
	measure_col <- as.character(binding_df2[,mt]);
	measure_col <- as.numeric(measure_col);
	binding_df2[,mt] <- measure_col;
	# remove missing/irregular measurements
	nna_id <- which(is.na(binding_df2[,mt]) == F); 
	binding_df2 <- binding_df2[nna_id,];
	# remove irregular measurements
	nzero_id <- which(binding_df2[,mt] != 0);
        binding_df2 <- binding_df2[nzero_id,];
	# compute p-measurement 
	binding_df2[,mt] <- -log(binding_df2[,mt], base = 10) + 9;

	## 3.2 Group entries by target, then process each group separately
	# obtain all/unique target names 
	measure_targets <- as.character(binding_df2$target_uniprot_id);
	unique_measure_targets <- unique(measure_targets);
	# iterate by target 
	measure_target_affinity <- mclapply(unique_measure_targets, function(umt){
		# obtain all ligand iteration for the target
		umt_id <- which(measure_targets %in% umt);
		umt_df <- binding_df2[umt_id,];
		# obtain all/unique ligand names 
		umt_ligands <- as.character(umt_df$ligand_bindingdb_id);
		unique_umt_ligands <- unique(umt_ligands);
		# iterate by ligand 
		ligand_affinities <- sapply(unique_umt_ligands, function(uul){
			uul_id <- which(umt_ligands %in% uul);
			# when more than one entry is available, compute the average measurement
			affinity <- mean(umt_df[uul_id, mt], na.rm = F);
			return(affinity);
		});
		# output in data frame format (column 1: target name, column 2: ligand name, column 3: binding affinity)
		umt_output <- data.frame(rep(umt, length(unique_umt_ligands)), unique_umt_ligands, round(ligand_affinities, 3));
		colnames(umt_output) <- c("target_uniprot_id", "compound_bindingdb_id", mn);
		
		return(umt_output);
	}, mc.cores = 10);

	## 3.3 Output combined results of all targets 
	# combine results of all targets 
	measure_affinity <- do.call(rbind, measure_target_affinity);
	# output
 	output_file_name <- paste(output_file , "_", mn, ".tsv", sep = "");
	write.table(measure_affinity, output_file_name, sep = "\t", quote = F, row.names = F, col.names = T);
	
	return(1);

}, measure_types, measure_names, SIMPLIFY = F);
