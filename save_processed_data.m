function save_processed_data(K9, folderPath, fileNames, numFiles)
    % save_processed_data Saves the processed data to files.
    %
    % Inputs:
    %   K9 - Cell array containing processed data.
    %   folderPath - Path to the folder where the data files will be saved.
    %   fileNames - Cell array with the names of the files to be saved.
    %   numFiles - Number of files to be processed and saved.

    for l1 = 1:numFiles
        % Apply threshold and convert to double
        processedData = double(K9{l1} > 0);
        
        % Save the processed data to a file
        save_data_file(processedData, folderPath, fileNames{l1});
    end

    disp('All processed data files have been saved.');
end