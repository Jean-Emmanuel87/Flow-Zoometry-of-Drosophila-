function save_data_file(Z,folderPath1,filter)

 [~, baseFileName, ~] = fileparts(filter);
   fileExtension = '.h5'
% Specify a new file name and dataset name for saving the data  
% baseFileName2 = 'D:\project_flying_drosophile\Data_4hits\4hits_'
 fileName1 = [folderPath1 '\' baseFileName  fileExtension];
% % Write Data to the new HDF5 file
 h5create(fileName1,'/dataset_1',size(Z))
 h5write(fileName1,'/dataset_1',Z)    
end