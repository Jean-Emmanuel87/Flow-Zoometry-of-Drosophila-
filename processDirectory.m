function folderPath1 = processDirectory(directory, codeDir, categories, datePattern, basePreprocessPath)
    
% Construct the full path to the directory
    targetDir = fullfile(codeDir, directory);

    pathParts = strsplit(directory, filesep);

    % Initialize variables for category and date
    category = '';
    datePart = '';

    % Identify the category and date from the path parts
    for i = 1:length(pathParts)
        if any(strcmp(pathParts{i}, categories))
            category = pathParts{i};
        end
        if isempty(datePart) && ~isempty(regexp(pathParts{i}, datePattern, 'once'))
            datePart = pathParts{i};
        end
    end

    % Ensure a category is assigned
    if isempty(category)
        category = 'generic';
    end

    % Create the full path for output data
    folderPath1 = fullfile(basePreprocessPath, category, datePart);

    % Create the directory if it doesn't exist
    if ~exist(folderPath1, 'dir')
        mkdir(folderPath1);
        disp(['Created directory: ' folderPath1]);
    else
        disp(['Directory already exists: ' folderPath1]);
    end
    
    % Change to the target directory to process files
    cd(targetDir);
    disp(['Changed directory to: ' targetDir]);

    
    % Return to the initial directory
    %cd(initialDir);

end