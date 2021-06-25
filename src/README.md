# This folder contains source code used by the repository.

## R/python scripts 

+ [`search_compound_sdf.py`](search_compound_sdf.py) searches CHEMBL for 2D/3D SDF files of compounds.

+ [`add_compound_sdf.R`](add_compound_sdf.R) searches, computes, and re-organizes 2D/3D sdf files for compounds that are missing from CHEMBL. 

+ [`convert_2d_to_3d.py`](convert_2d_to_3d.py) converts 2D sdf file of molecule to 3D sdf file. [`run_convert_2d_to_3d.R`](run_convert_2d_to_3d.R) generate shell script that run the above script.

+ [`parse_bindingdb_compounds.R`](parse_bindingdb_compounds.R) parses raw BindingDB data to obtain 2D/3D SDF file of compounds. 

+ [`parse_bindingdb_targets.R`](parse_bindingdb_targets.R) parses raw BindingDB data to obtain compound-target binding affinities. 

+ [`analyze_target_affinity.R`](analyze_target_affinity.R) analyzes and visualizes comparison of compound-target binding affinity data between pairs of pharmaceutical setting and pairs of non-pharmaceutical setting.

+ [`dichotomize_affinity_data.R`](dichotomize_affinity_data.R) dichotomizes compound-target pairs into two groups: ones with binding affinity above the specified threshold and ones with binding affinity below the specified threshold.

+ [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R) compute molecular descriptors and chemical fingerprints, respectively. Specifically, five types of molecular descriptors and ten types of chemical fingerprints are compulted in the two scripts. For detailed information about these chemical properties, please check the [rcdk package](https://cran.r-project.org/web/packages/rcdk/rcdk.pdf). [`run/run_compute_descriptors.R`](run/run_compute_descriptors.R) and [`run/run_compute_fingerprints.R`](run/run_compute_fingerprints.R) generate shell scripts that run the two above scripts. 

+ [`collect_compound_descriptors.R`](collect_compound_descriptors.R) and [`collect_compound_fingerprints.R`](collect_compound_fingerprints.R) collect computed molecular descriptors and chemical fingerprints, respectively, from multiple compounds. 

+ [`combine_descriptors.R`](combine_descriptors.R) combines different types of molecular descriptors into one single file. 

+ [`parse_tox21_structure.R`](parse_tox21_structure.R) parses chemical structure data of tox21 compounds to compute chemical fingerprints.  

+ [`functions.R`](functions.R) contains R functions required for other scripts in the folder. 
 
## Executable shell scripts

+ [`run/search_compound_sdf_offsides.sh`](run/search_compound_sdf_offsides.sh) runs [`search_compound_sdf.py`](search_compound_sdf.py) on compounds from OFFSIDES.

+ [`run/convert_2d_to_3d.sh`](run/convert_2d_to_3d.sh) runs [`convert_2d_to_3d.py`](convert_2d_to_3d.py) on added compounds from OFFSIDES (the ones with missing structure data from CHEMBL).

+ [`run/parse_bindingdb_compounds.sh`](run/parse_bindingdb_compounds.sh) runs [`parse_bindingdb_compounds.R`](parse_bindingdb_compounds.R) on compounds from BindingDB.

+ [`run/parse_bindingdb_targets.sh`](run/parse_bindingdb_targets.sh) runs [`parse_bindingdb_targets.R`](parse_bindingdb_targets.R) on targets from BindingDB.

+ [`run/analyze_target_affinity.sh`](run/analyze_target_affinity.sh) runs [`analyze_target_affinity.R`](analyze_target_affinity.R) on compound-target binding affinity data from BindingDB.

+ [`run/dichotomize_affinity_data.sh`](run/dichotomize_affinity_data.sh) runs [`dichotomize_affinity_data.R`](dichotomize_affinity_data.R) on compound-target binding affinity data of four distinct measurements.

+ [`run/run_compute_descriptors_offsides.sh`](run/run_compute_descriptors_offsides.sh) and [`run/run_compute_fingerprints_offsides.sh`](run/run_compute_fingerprints_offsides.sh) run [`run/run_compute_descriptors.R`](run/run_compute_descriptors.R) and [`run/run_compute_fingerprints.R`](run/run_compute_fingerprints.R), respectively, on compounds from OFFSIDES. [`run/run_compute_descriptors_offsides_add.sh`](run/run_compute_descriptors_offsides_add.sh) and [`run/run/run_compute_descriptors_offsides_add.sh`](run/run/run_compute_descriptors_offsides_add.sh) run [`run/run_compute_descriptors.R`](run/run_compute_descriptors.R) and [`run/run_compute_fingerprints.R`](run/run_compute_fingerprints.R), respectively, on added compounds from OFFSIDES (the ones with missing structure data from CHEMBL). [`run/run_compute_descriptors_bindingdb.sh`](run/run_compute_descriptors_bindingdb.sh) and [`run/run_compute_fingerprints_bindingdb.sh`](run/run_compute_fingerprints_bindingdb.sh) run [`run/run_compute_descriptors.R`](run/run_compute_descriptors.R) and [`run/run_compute_fingerprints.R`](run/run_compute_fingerprints.R), respectively, on compounds from BindingDB.

+ [`run/compute_descriptors_offsides.sh`](run/compute_descriptors_offsides.sh) and [`run/compute_fingerprints_offsides.sh`](run/compute_fingerprints_offsides.sh) run [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R), respectively, on compounds from OFFSIDES. [`run/compute_descriptors_offsides_add.sh`](run/compute_descriptors_offsides_add.sh) and [`run/compute_fingerprints_offsides_add.sh`](run/compute_fingerprints_offsides_add.sh) run [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R), respectively, on added compounds from OFFSIDES (the ones with missing structure data from CHEMBL). [`run/compute_descriptors_bindingdb.sh`](run/compute_descriptors_offsides.sh) and [`run/compute_fingerprints_bindingdb.sh`](run/compute_fingerprints_bindingdb.sh) run [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R), respectively, on compounds from BindingDB.

+ [`run/collect_compound_descriptors_offsides.sh`](run/collect_compound_descriptors_offsides.sh) and [`run/collect_compound_fingerprints_offsides.sh`](run/collect_compound_fingerprints_offsides.sh) run [`collect_compound_descriptors.R`](collect_compound_descriptors.R) and [`collect_compound_fingerprints.R`](collect_compound_fingerprints.R), respectively, on compounds from OFFSIDES. [`run/collect_compound_descriptors_bindingdb.sh`](run/collect_compound_descriptors_bindingdb.sh) and [`run/collect_compound_fingerprints_bindingdb.sh`](run/collect_compound_fingerprints_bindingdb.sh) run [`collect_compound_descriptors.R`](collect_compound_descriptors.R) and [`collect_compound_fingerprints.R`](collect_compound_fingerprints.R), respectively, on compounds from BindingDB.

+ [`run/combine_descriptors_offsides.sh`](run/combine_descriptors_offsides.sh) runs [`combine_descriptors.R`](combine_descriptors.R) on compounds from OFFSIDES. [`run/combine_descriptors_bindingdb.sh`](run/combine_descriptors_bindingdb.sh) runs [`combine_descriptors.R`](combine_descriptors.R) on compounds from BindingDB.

