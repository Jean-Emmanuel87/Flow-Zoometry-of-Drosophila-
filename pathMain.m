% Initialize the current directory
currentDir = pwd;

% Loop to move up in the directory structure until you find the 'code_for_publication' directory or reach the root
while true
    % Check if the 'main' directory exists in the current directory
    codeDir = fullfile(currentDir, 'main');
    if exist(codeDir, 'dir')
        cd(codeDir);
        disp(['Changed directory to: ' codeDir]);
        break;
    else
        % Check if the current directory is 'code_for_publication'
        [parentDir, currentFolderName, ~] = fileparts(currentDir);
        if strcmp(currentFolderName, 'code_for_publication')
            error(['The directory ' codeDir ' does not exist.']);
        elseif isempty(parentDir) || strcmp(currentDir, parentDir)  % Check if we've reached the root
            error('Reached the root directory without finding ''code_for_publication''.');
        end
        % Update currentDir to move one level up
        currentDir = parentDir;
    end
end