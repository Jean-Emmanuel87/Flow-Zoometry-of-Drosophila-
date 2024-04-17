
datasetName = '/dataset_1';
data = {};

codeDir_mod = pwd;

% Specify the main folder containing phenotype folders
main_folder_path = fullfile(codeDir_mod,'..\Segmented_data1');
% List of phenotypes to include in training
target_phenotypes = {'noncancer', '4hit'};

% Loop through each target phenotype
for phen_idx = 1:length(target_phenotypes)
    phenotype_name = target_phenotypes{phen_idx};
    
    % Specify the path to the current phenotype folder
    phenotype_folder_path = fullfile(main_folder_path, phenotype_name);

    % Get a list of all items in the phenotype folder
    phenotype_contents = dir(phenotype_folder_path);
    
    % Loop through each item in the phenotype folder
    for item_idx = 1:length(phenotype_contents)
        % Skip if not a directory or if it's '.' or '..'
        if ~phenotype_contents(item_idx).isdir || strcmp(phenotype_contents(item_idx).name, '.') || strcmp(phenotype_contents(item_idx).name, '..')
            continue;
        end
        
        % Get the name of the item
        item_name = phenotype_contents(item_idx).name;
        
        % Specify the path to the current item
        item_path = fullfile(phenotype_folder_path, item_name);
        
        % Check if the item is a date folder
        if isfolder(item_path)
            % Get a list of HDF5 files within the date folder
            h5_files = dir(fullfile(item_path, '*.h5'));
            
            % Loop through each HDF5 file within the date folder
            for h5_idx = 1:length(h5_files)
                % Load the binary mask from the HDF5 file
                h5_file_name = h5_files(h5_idx).name;
                full_h5_file_path = fullfile(item_path, h5_file_name);
                binary_mask = h5read(full_h5_file_path, datasetName);
                
                % Extract features from the binary mask (e.g., using regionprops3)
                features = extract_features(binary_mask);
                
                % Append the data to the cell array
                data_row = {phenotype_name, item_name, '', h5_file_name, features}; % No subfolder info
                data = [data; data_row];
            end
            
            % Check for subfolders 'b1', 'b2', or 'b3' within the date folder
            subfolders = dir(fullfile(item_path, 'b*'));
            for subfolder_idx = 1:length(subfolders)
                subfolder_name = subfolders(subfolder_idx).name;
                
                % Get a list of HDF5 files within the subfolder
                h5_files = dir(fullfile(item_path, subfolder_name, '*.h5'));
                
                % Loop through each HDF5 file within the subfolder
                for h5_idx = 1:length(h5_files)
                    % Load the binary mask from the HDF5 file
                    h5_file_name = h5_files(h5_idx).name;
                    full_h5_file_path = fullfile(item_path, subfolder_name, h5_file_name);
                    binary_mask = h5read(full_h5_file_path, datasetName);
                    
                    % Extract features from the binary mask (e.g., using regionprops3)
                    features = extract_features(binary_mask);
                    
                    % Append the data to the cell array
                    data_row = {phenotype_name, item_name, subfolder_name, h5_file_name, features}; % Include subfolder info
                    data = [data; data_row];
                end
            end
        end
    end
end

% Initialize variables to store phenotype, date, subfolder, h5_file, and features
phenotype = {};
date = {};
subfolder = {};
h5_file = {};
features = [];

% Loop through data to extract phenotype, date, subfolder, h5_file, and features
for i = 1:size(data, 1)
    phenotype{i} = data{i, 1}; % Extract phenotype
    date{i} = data{i, 2}; % Extract date
    subfolder{i} = data{i, 3}; % Extract subfolder
    h5_file{i} = data{i, 4}; % Extract HDF5 file name
    features = [features; data{i, 5}]; % Concatenate features
end

% Define variable names for features
variable_names = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18','F19','F20','F21','F22','F23','F24','F25','F26','F27','F28','F29','F30'};

% Create a table for features
features_table = array2table(features, 'VariableNames', variable_names);

% Convert phenotype, date, subfolder, and h5_file to cell arrays
phenotype_table = cell2table(phenotype', 'VariableNames', {'Phenotype'});
date_table = cell2table(date', 'VariableNames', {'Date'});
subfolder_table = cell2table(subfolder', 'VariableNames', {'Subfolder'});
h5_file_table = cell2table(h5_file', 'VariableNames', {'H5_File'});

% Combine all tables
table_data = [phenotype_table, date_table, subfolder_table, h5_file_table, features_table];

% Write the table to a CSV file
csv_file_path = 'data_for modeling.csv'; % Specify the path to the