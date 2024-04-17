function data = processH5Files(item_path, datasetName, phenotype_name, item_name, data, subfolder_name)
    if nargin < 6
        subfolder_name = ''; % Default to empty if not provided
    end
    
    if isfolder(item_path)
        % Get a list of HDF5 files within the folder
        h5_files = dir(fullfile(item_path, '*.h5'));
        
        % Loop through each HDF5 file
        for h5_idx = 1:length(h5_files)
            h5_file_name = h5_files(h5_idx).name;
            full_h5_file_path = fullfile(item_path, h5_file_name);
            binary_mask = h5read(full_h5_file_path, datasetName);
            
            % Extract features from the binary mask
            features = extract_features(binary_mask);
            
            % Append the data to the cell array
            data_row = {phenotype_name, item_name, subfolder_name, h5_file_name, features};
            data = [data; data_row];
        end
        
        % If processing a main folder, check for subfolders and recurse
        if nargin < 6
            subfolders = dir(fullfile(item_path, 'b*'));
            for subfolder_idx = 1:length(subfolders)
                if subfolders(subfolder_idx).isdir && ~strcmp(subfolders(subfolder_idx).name, '.') && ~strcmp(subfolders(subfolder_idx).name, '..')
                    subfolder_path = fullfile(item_path, subfolders(subfolder_idx).name);
                    data = processH5Files(subfolder_path, datasetName, phenotype_name, item_name, data, subfolders(subfolder_idx).name);
                end
            end
        end
    end
end