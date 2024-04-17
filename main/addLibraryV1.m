function add_library_vf1
% ADD_LIBRARY_VF1 Adds necessary paths for the segmentation_utils package.

% Define the path to 'segmentation_utils' relative to this file's location
segmentationUtilsPath = fullfile('..', 'segmentation_utils');

% Check if the segmentation_utils directory exists before adding it
if ~exist(segmentationUtilsPath, 'dir')
    error('The directory %s does not exist.', segmentationUtilsPath);
end

% Add the segmentation_utils directory itself
addpath(segmentationUtilsPath);
disp(['Added ' segmentationUtilsPath ' to the path.']);

% Add specific subdirectories within segmentation_utils
% Add specific subdirectories within segmentation_utils
subdirectories = {'gui', 'spm8', 'MRIDenoisingPackage'};
for i = 1:length(subdirectories)
    subDirPath = fullfile(segmentationUtilsPath, subdirectories{i});
    if exist(subDirPath, 'dir')
        addpath(genpath(subDirPath));
        fprintf('Successfully added %s to the path.\n', subDirPath);
    else
        fprintf('Warning: %s does not exist and was not added to the path.\n', subDirPath);
    end
end


end