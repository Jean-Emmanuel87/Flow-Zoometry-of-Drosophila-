function remove_existing_h5_files(folderPath)
    % remove_existing_h5_files Removes all .h5 files in the specified directory.
    %
    % Inputs:
    %   folderPath - The path to the folder where .h5 files should be removed.

    % Check if the folder exists
    if ~exist(folderPath, 'dir')
        disp(['The folder does not exist: ', folderPath]);
        return;
    end

    % Get a list of .h5 files in the folder
    h5Files = dir(fullfile(folderPath, '*.h5'));

    % Loop through the .h5 files and delete them
    for i = 1:length(h5Files)
        delete(fullfile(folderPath, h5Files(i).name));
        disp(['Deleted file: ', h5Files(i).name]);
    end

    if isempty(h5Files)
        disp('No .h5 files were found to delete.');
    else
        disp(['All .h5 files have been removed from ', folderPath]);
    end
end