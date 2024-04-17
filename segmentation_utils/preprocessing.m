%%%%%%%
function [K,K1,K2,K3,K4,K5,K6] = preprocessing(numFiles,filteredFileNames)

%%%%%%%%%%check the names of the files 


numFiles = length(filteredFileNames);


datasetName = '/dataset_1';
folderPath = 'D:\project_flying_drosophile\figure55';


[K,K1,K2,K3,K4,K5] = variable_initalization(filteredFileNames);

parfor i = 1:numFiles
    try
        % Read the data from the file
        Data = h5read(filteredFileNames{i}, datasetName);
        
        % Ensure Data is valid
        if isempty(Data)
            disp(['Skipping file due to empty Data: ', filteredFileNames{i}]);
            continue;
        end

        % Crop the body
        [Data_y_cropped, Data_canal, S1_z, S1_y] = xyz_body_crop2(Data, 0.5);
        
        % Check if Data_y_cropped is valid
        if isempty(Data_y_cropped) || size(Data_y_cropped, 3) < 150
            disp(['Skipping file due to invalid Data_y_cropped: ', filteredFileNames{i}]);
            continue;
        end

        [clustered3DImage3,Z,clustered3DImage4,Pre_seg_cropped,Data2,skeleton]=parallel_block_v2(Data_y_cropped,folderPath,filteredFileNames{i});
        
        % Storing results
        K{i} = clustered3DImage3;
        K1{i} = Z;
        K5{i} = clustered3DImage4;
        K3{i} = Pre_seg_cropped;
        K4{i} = Data2;
        K6{i} = skeleton;
        
    catch ME
        disp(['Error processing file: ', filteredFileNames{i}, ' - ', ME.message]);
        % Provide default values to avoid undefined variables
        K{i} = ones(10, 10, 89);
        K1{i} = ones(10, 10, 89);
        K5{i} = ones(10, 10, 89);
        K3{i} = ones(10, 10, 89);
        K4{i} = ones(10, 10, 89);
    end
end

end
