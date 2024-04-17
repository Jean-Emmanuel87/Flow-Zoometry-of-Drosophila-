function [numFiles,filteredFileNames] = open_files_larva

% open_files_larva filters and lists names in the raw data directory
%
% Outputs:
% numFiles - Number of files that match the filtering criteria (.h5 files)
% filteredFileNames - Cell array containing the names of the filtered files.


disp('Opening files in progress...')

fileExtension = '.dcimg.h5';
%fileExtension1 = '.png';

%%%%%%%%opneing in a list the files names
dirInfo = dir(); % Get the list of all files and folders in the directory
% Initialize a cell array to store the filtered file names
filteredFileNames = {};
% Filter file names that start with 'ds4x'
for k = 1:length(dirInfo)
if startsWith(dirInfo(k).name, 'ds4x') && contains(dirInfo(k).name, '.h5')
% Add the full path to the file name
filteredFileNames{end + 1} = fullfile(dirInfo(k).name);
end
end
% Check if there are any files to process
if isempty(filteredFileNames)
disp('No files found matching the criteria.');
return;
end

k1 = 0;
numFiles = length(filteredFileNames);

disp('File opening operation completed')

end