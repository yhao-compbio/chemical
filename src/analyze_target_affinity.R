# !usr/bin/Rscript 
# created by Yun Hao @MooreLab 2020
# This script analyzes and visualizes comparison of compound-target binding affinity data between pairs of pharmaceutical setting and pairs of non-pharmaceutical setting

## 0. Input arguments
Args		<- commandArgs(T);
binding_file	<- Args[1];		# file name of compound-target binding affinity dataset
measure_type	<- Args[2];		# type of binding affinity measurement
plot_file	<- Args[4];		# prefix of plot file
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

## 3. Analyze distribution of binding affinity
# compute percentile statistics of binding affinity 
tar_binding_measure <- drug_target_binding[, measure_type];
all_binding_measure <- binding_data[, measure_type];
measure_med <- quantile(tar_binding_measure, 0.5);
measure_25 <- quantile(tar_binding_measure, 0.25);
measure_75 <- quantile(tar_binding_measure, 0.75);
tar_density <- density(tar_binding_measure);
all_density <- density(all_binding_measure);
y_upper <- max(c(max(tar_density$y), max(all_density$y)));
# make histagram of binding affinity measurement
pdf(paste(plot_file, "_distribution_compare.pdf", sep = ""), width = 6, height = 6, family = "Helvetica");
par(cex.lab = 2, cex.axis = 2, cex.main = 2);
par(mar = c(5,5,3,5));
hist(tar_binding_measure, breaks = 20, main = measure_type, xlab = "Values", ylab = "Counts", xlim = c(2, 12));
abline(v = measure_25, lty = 2, lwd = 2, col = "red");
abline(v = measure_med, lty = 2, lwd = 2, col = "red");
abline(v = measure_75, lty = 2, lwd = 2, col = "red");
par(new = T);
plot(tar_density, col = "red", xaxt = "n", yaxt = "n", axes = F, ylab = "", xlab = "", main = "", xlim = c(2, 12), ylim = c(0, y_upper), lwd = 2);
lines(all_density, col = "blue", lwd = 2);
axis(side = 4);
mtext("Denstiy", side = 4, line = 3, cex = 2);
legend("topleft", c("drug-target", "all"), col = c("red", "blue"), lty = 1, lwd = 2, cex = 1, bty = "n", ncol = 1, xpd = T);
dev.off();
