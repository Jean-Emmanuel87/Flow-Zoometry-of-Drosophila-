function directories = generateDirectories(baseDir, categories)
    % Initialize the output cell array
    directories = {};
    
    % Iterate over each category
    for i = 1:length(categories)
        categoryDir = fullfile(baseDir, categories{i});
        
        % Check if the category directory exists
        if ~exist(categoryDir, 'dir')
            warning(['Directory does not exist: ' categoryDir]);
            continue;  % Skip to the next category if the directory doesn't exist
        end
        
        % Get a list of subdirectories in the category directory
        subDirs = dir(categoryDir);
        
        % Filter out the '.' and '..' directories and any files
        subDirs = subDirs([subDirs.isdir]);
        subDirs = subDirs(~ismember({subDirs.name}, {'.', '..'}));
        
        % Iterate over each subdirectory
        for j = 1:length(subDirs)
            % Check if the subdirectory name matches the date pattern
            if ~isempty(regexp(subDirs(j).name, '\d{8}', 'once'))
                % Construct the full path and add it to the output list
                directories{end + 1} = fullfile(categoryDir, subDirs(j).name);
            end
        end
    end

    
    fprintf('Directories to preprocess and segment:\n');
    for i = 1:length(directories)
        fprintf('%d: %s\n', i, directories{i});
    end

end