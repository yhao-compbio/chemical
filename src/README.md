# This folder contains source code used by the repository.

## R/python scripts 

+ [`search_compound_sdf.py`](search_compound_sdf.py) searches CHEMBL for 2D/3D SDF files of compounds.

+ [`parse_bindingdb_compounds.R`](parse_bindingdb_compounds.R) parses raw BindingDB data to obtain 2D/3D SDF file of compounds. 

+ [`parse_bindingdb_targets.R`](parse_bindingdb_targets.R) parses raw BindingDB data to obtain compound-target binding affinities. 

+ [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R) compute molecular descriptors and chemical fingerprints, respectively. Specifically, five types of molecular descriptors and ten types of chemical fingerprints are compulted in the two scripts. For detailed information about these chemical properties, please checkthe [rcdk package](https://cran.r-project.org/web/packages/rcdk/rcdk.pdf). [`run_compute_descriptors.R`](run_compute_descriptors.R) and [`run_compute_fingerprints.R`](run_compute_fingerprints.R) generate shell scripts that run the two above scripts. 

+ [`collect_compound_descriptors.R`](collect_compound_descriptors.R) and [`collect_compound_fingerprints.R`](collect_compound_fingerprints.R) collect computed molecular descriptors and chemical fingerprints, respectively, from multiple compounds. 

+ [`combine_descriptors.R`](combine_descriptors.R) combines different types of molecular descriptors into one single file. 

+ [`functions.R`](functions.R) contains R functions required for other scripts in the folder. 
 
## Executable shell scripts

+ [`run/search_compound_sdf_offsides.sh`](run/search_compound_sdf_offsides.sh) runs [`search_compound_sdf.py`](search_compound_sdf.py) on compounds from OFFSIDES.

+ [`run/parse_bindingdb_compounds.sh`](run/parse_bindingdb_compounds.sh) runs [`parse_bindingdb_compounds.R`](parse_bindingdb_compounds.R) on compounds from BindingDB.

+ [`run/parse_bindingdb_targets.sh`](run/parse_bindingdb_targets.sh) runs [`parse_bindingdb_targets.R`](parse_bindingdb_targets.R) on targets from BindingDB.

+ [`run/run_compute_descriptors_offsides.sh`](run/run_compute_descriptors_offsides.sh) and [`run/run_compute_fingerprints_offsides.sh`](run/run_compute_fingerprints_offsides.sh) run [`run_compute_descriptors.R`](run_compute_descriptors.R) and [`run_compute_fingerprints.R`](run_compute_fingerprints.R), respectively, on compounds from OFFSIDES. [`run/run_compute_descriptors_bindingdb.sh`](run/run_compute_descriptors_bindingdb.sh) and [`run/run_compute_fingerprints_bindingdb.sh`](run/run_compute_fingerprints_bindingdb.sh) run [`run_compute_descriptors.R`](run_compute_descriptors.R) and [`run_compute_fingerprints.R`](run_compute_fingerprints.R), respectively, on compounds from BindingDB.

+ [`run/compute_descriptors_offsides.sh`](run/compute_descriptors_offsides.sh) and [`run/compute_fingerprints_offsides.sh`](run/compute_fingerprints_offsides.sh) run [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R), respectively, on compounds from OFFSIDES. [`run/compute_descriptors_bindingdb.sh`](run/compute_descriptors_offsides.sh) and [`run/compute_fingerprints_bindingdb.sh`](run/compute_fingerprints_bindingdb.sh) run [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R), respectively, on compounds from BindingDB.

+ [`run/collect_compound_descriptors_offsides.sh`](run/collect_compound_descriptors_offsides.sh) and [`run/collect_compound_fingerprints_offsides.sh`](run/collect_compound_fingerprints_offsides.sh) run [`collect_compound_descriptors.R`](collect_compound_descriptors.R) and [`collect_compound_fingerprints.R`](collect_compound_fingerprints.R), respectively, on compounds from OFFSIDES. [`run/collect_compound_descriptors_bindingdb.sh`](run/collect_compound_descriptors_bindingdb.sh) and [`run/collect_compound_fingerprints_bindingdb.sh`](run/collect_compound_fingerprints_bindingdb.sh) run [`collect_compound_descriptors.R`](collect_compound_descriptors.R) and [`collect_compound_fingerprints.R`](collect_compound_fingerprints.R), respectively, on compounds from BindingDB.

+ [`run/combine_descriptors_offsides.sh`](run/combine_descriptors_offsides.sh) runs [`combine_descriptors.R`](combine_descriptors.R) on compounds from OFFSIDES. [`run/combine_descriptors_bindingdb.sh`](run/combine_descriptors_bindingdb.sh) runs [`combine_descriptors.R`](combine_descriptors.R) on compounds from BindingDB.


