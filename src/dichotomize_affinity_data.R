# !usr/bin/Rscript 
# created by Yun Hao @MooreLab 2020
# This script dichotomizes compound-target pairs into two groups: ones with binding affinity above the specified threshold and ones with binding affinity below the specified threshold

## 0. Input arguments
Args		<- commandArgs(T);
binding_file	<- Args[1];			# file name of compound-target binding affinity dataset
measure_type	<- Args[2];			# type of binding affinity measurement
quantile_cut	<- as.numeric(Args[3]);		# quantile threshold of binding affinity (value above the threshold will be converted to 1, below the threshold will be converted to 0)
output_file	<- Args[4];			# prefix of output data file
# 
target_file	<- "downloads/drugbank/uniprot\ links.csv";
map_file	<- "data/bindingdb_compounds/bindingdb_2D_map.tsv";

## 1. Read in data files
# read in compound-target binding affinity data
binding_data <- read.delim(file = binding_file, sep = "\t", header = T);
binding_data$compound_target <- mapply(function(x, y) paste(x, y, sep = "@"), binding_data$compound_bindingdb_id, as.character(binding_data$target_uniprot_id));
# read in drug ~ target mapping data
drug_target <- read.csv(file = target_file);
drug_target$Name <- tolower(drug_target$Name)
# read in compound name ~ ID map 
compound_map <- read.delim(file = map_file, sep = "\t", header = T);
compound_name_list <- lapply(as.character(compound_map$compound_name), function(cmcn) strsplit(cmcn, "::")[[1]]);
compound_name_len <- sapply(compound_name_list, length);
compound_id_list <- mapply(function(x, y) rep(x, y), compound_map$compound_bindingdb_id, compound_name_len);
all_compound_map <- data.frame(unlist(compound_id_list), unlist(compound_name_list));
colnames(all_compound_map) <- c("bindingdb_id", "Name");
all_compound_map$Name <- tolower(all_compound_map$Name);

## 2. Perform ID mapping to obtain drug-target binding affinity data
drug_target_map <- merge(drug_target, all_compound_map, by = "Name");
drug_target_map$compound_target <- mapply(function(x, y) paste(x, y, sep = "@"), drug_target_map$bindingdb_id, as.character(drug_target_map$UniProt.ID));
drug_target_binding <- merge(binding_data, drug_target_map, by = "compound_target");
drug_target_binding <- unique(drug_target_binding[,c("compound_target", "target_uniprot_id", "compound_bindingdb_id", measure_type)]);

## 3. Dichotomize binding affinity values based on specified quantile threshold 
measure_cut <- quantile(drug_target_binding[, measure_type], quantile_cut);
measure_binary <- as.integer(binding_data[, measure_type] > measure_cut);
output_df <- data.frame(binding_data$target_uniprot_id, binding_data$compound_bindingdb_id, measure_binary);
colnames(output_df) <- c("target_uniprot_id", "compound_bindingdb_id", measure_type);
write.table(output_df, file = paste(output_file, "_", quantile_cut, "_binary.tsv", sep = ""), sep = "\t", col.names = T, row.names = F, quote = F);
