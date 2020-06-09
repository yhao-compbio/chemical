# This folder contains source code used by the repository.

## R/python scripts 

+ [`search_compound_sdf.py`](search_compound_sdf.py) searches CHEMBL for 2D/3D SDF files of compounds.

+ [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R) compute molecular descriptors and chemical fingerprints, respectively. [`run_compute_descriptors.R`](run_compute_descriptors.R) and [`run_compute_fingerprints.R`](run_compute_fingerprints.R) generate shell scripts that run the two above scripts. 

+ [`collect_compound_descriptors.R`](collect_compound_descriptors.R) and [`collect_compound_fingerprints.R`](collect_compound_fingerprints.R) collect computed molecular descriptors and chemical fingerprints, respectively, from multiple compounds. 

+ [`combine_descriptors.R`](combine_descriptors.R) combines different types of molecular descriptors into one single file. 

+ [`functions.R`](functions.R) contains R functions required for other scripts in the folder. 
 
## Executable shell scripts

+ [`run/search_compound_sdf_offsides.sh`]()

+ [`run/run_compute_descriptors_offsides.sh`](run/run_compute_descriptors_offsides.sh) and [`run/run_compute_fingerprints_offsides.sh`](run/run_compute_fingerprints_offsides.sh) run [`run_compute_descriptors.R`](run_compute_descriptors.R) and [`run_compute_fingerprints.R`](run_compute_fingerprints.R), respectively, on the OFFSIDES dataset.  

+ [`run/compute_descriptors_offsides.sh`](run/compute_descriptors_offsides.sh) and [`run/compute_fingerprints_offsides.sh`](run/compute_fingerprints_offsides.sh) run [`compute_descriptors.R`](compute_descriptors.R) and [`compute_fingerprints.R`](compute_fingerprints.R), respectively, on the OFFSIDES dataset. 

+ [`run/collect_compound_descriptors_offsides.sh`](run/collect_compound_descriptors_offsides.sh) and [`run/collect_compound_fingerprints_offsides.sh`](run/collect_compound_fingerprints_offsides.sh) run [`collect_compound_descriptors.R`](collect_compound_descriptors.R) and [`collect_compound_fingerprints.R`](collect_compound_fingerprints.R), respectively, on the OFFSIDES dataset.

+ [`run/combine_descriptors_offsides.sh`](run/combine_descriptors_offsides.sh) runs [`combine_descriptors.R`](combine_descriptors.R) on the OFFSIDES dataset.


