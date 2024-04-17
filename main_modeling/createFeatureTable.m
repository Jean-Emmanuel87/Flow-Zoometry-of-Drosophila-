function table_data = createFeatureTable(main_folder_path, datasetName, target_phenotypes, savePath)
    % Initialize the cell array to store the data
    data = {};
    
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
            
            % Process HDF5 files in the current directory and its subdirectories
            data = processH5Files(item_path, datasetName, phenotype_name, item_name, data);
        end
    end

    % Convert the data to a table
    table_data = convertDataToTable(data);
    
    % Optionally save the table to a CSV file
    if nargin == 4 && ~isempty(savePath)
        writetable(table_data, savePath);
    end
end



