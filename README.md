# Flow-Zoometry-of-Drosophila
Automatic segmentation and classification of drosophila wing disc phenotype

# Features
![Picture4](https://github.com/Jean-Emmanuel87/Flow-Zoometry-of-Drosophila-/assets/54609010/49fd840e-b2b5-49be-8edf-afede59db566)

## How to use
This repisetory uses an external toobox that can be dowload at this adress :
https://sites.google.com/site/pierrickcoupe/softwares/denoising/mri-denoising/mri-denoising-software
This toolbox is for personal used or adacdemic use only . 
if you use it please cite the paper J. V. Manjon, P. Coupé, A. Buades, D. L. Collins, M. Robles. New Methods for MRI Denoising based on Sparseness and Self-Similarity. Medical Image Analysis, 16(1): 18-27, 2012.

Step 1: Organize MRI Denoising Software

Load the MRI denoising software. 
Move this software into the segmentation_utils folder. 

Step 2: Organize Raw Data by Phenotype and Date

Inside Raw_data, create subfolders named after each phenotype you are studying (e.g., phenotype1, phenotype2, etc.).
Within each phenotype subfolder, create further subfolders organized by the date the data was collected. The folders should be named with a date in the format YYYYMMDD (e.g., 20240417 for April 17, 2024).

Step 3: Insert Raw Data

Obtain the raw data files, which should be in the .h5 format.
Place each .h5 file into the corresponding subfolder within the appropriate phenotype and date. The file structure should be accurate to ensure that the workflow script can locate and process the data correctly.

Step 4: Run Main Workflow Script

Run the clean_code_main_workflow1.m script located in main. 
The script will process each .h5 file in the Raw_data folder, performing the following tasks:
Segmentation of the wing disc for each larva.
Classification of the phenotype (whether it's a 4hit or noncancer case).


Note : matlab toolbox dependancy : Image Processing Toolbox & Parallel Computing Toolbox   & Statistics and Machine Learning Toolbox  
