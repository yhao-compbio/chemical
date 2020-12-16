# !usr/bin/Rscript 
# created by Yun Hao @MooreLab 2020
# This script generates commands lines to run 'convert_2d_to_3d.py'.

## 1. Obtain 2D files to be computed 
# obtain all structure files  
all_files <- list.files("data/offsides_compounds/sdf_manual/");
# obtain 2D sdf files 
d2_id <- sapply(all_files, function(af) length(strsplit(af, "Structure2D_")[[1]]));
d2_files <- all_files[d2_id == 2];
d2_mols <- sapply(d2_files, function(df) strsplit(df, "Structure2D_")[[1]][[2]]);
# obtain 3D sd files (molecules with known 3D structure)
d3_id <- sapply(all_files, function(af) length(strsplit(af, "Conformer3D_")[[1]]));
d3_files <- all_files[d3_id == 2];
d3_mols <- sapply(d3_files, function(df) strsplit(df, "Conformer3D_")[[1]][[2]]);
# fine molecules of which the 3D structure needs to be computed 
query_mols <- setdiff(d2_mols, d3_mols);

## 2. Generate commands and output 
query_commands <- sapply(query_mols, function(qm){
	ip_file <- paste("data/offsides_compounds/sdf_manual/Structure2D_", qm, sep = ""); 
	op_file <- paste("data/offsides_compounds/sdf_manual_3d/Conformer3D_", qm, sep = "");
	cm <- paste("/usr/local/bin/python3.8", "src/convert_2d_to_3d.py", ip_file, op_file, sep = " ");
	return(cm);
});
writeLines(query_commands, "src/run/convert_2d_to_3d.sh");
