# Flow-Zoometry-of-Drosophila
Automatic segmentation and classification of drosophila wing disc phenotype

# Features
![Picture4](https://github.com/Jean-Emmanuel87/Flow-Zoometry-of-Drosophila-/assets/54609010/49fd840e-b2b5-49be-8edf-afede59db566)

## How to use
This repisetory uses an external toobox that can be dowload at this adress :
https://sites.google.com/site/pierrickcoupe/softwares/denoising/mri-denoising/mri-denoising-software
This toolbox is for personal used or adacdemic use only . 
if you use it please cite the paper J. V. Manjon, P. Coupé, A. Buades, D. L. Collins, M. Robles. New Methods for MRI Denoising based on Sparseness and Self-Similarity. Medical Image Analysis, 16(1): 18-27, 2012.

- Step 1 : Put the MRI denoising software in in the folder segmentation_utils.
- Step 2 :  Inside the folder "Raw_data," create subfolders for each phenotype.
 Within each phenotype's folder, create subfolders based on the date. The format chosen for the date should be  YYYYMMDD.
- Step 3 : Insert the raw .h5 data in each corresponding subfolder.
- Step 4 : Go to the main folder and run clean_code_main_workflow1.m
- Step 4 : Single cell spectra are plotted in folder figure
