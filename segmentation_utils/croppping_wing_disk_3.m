
function [Vol4, Vol5, Data4, Pre_seg] = croppping_wing_disk_3(num5clust,Data_y_cropped,Vol1,Vol2,clustered3DImage2);
    
   
% Calculate the weighted average (centroid)
x = 1:length(num5clust);
    % centroid = sum(x .* num5clust) / sum(num5clust);

% Find the midpoint of the x-axis
midpoint = round((max(x) + min(x)) / 2);
weight_left = sum(num5clust(1:midpoint));
weight_right = sum(num5clust(midpoint+1:end));

% Determine if more weight is on the left or right of the midpoint
if weight_right > weight_left
%     disp('head is on the right');
    numElementsToZero = ceil(length(num5clust) / 3);
    
    % Set the first 1/3 of num5clust to 0
    num5clust(1:numElementsToZero) = 0;

else weight_right < midpoint
%     disp('head is on the left');

    % Calculate the number of elements to set to zero
    numElementsToZero = ceil(length(num5clust) / 3);
    
    % Set the last 1/3 of num5clust to 0
    num5clust(end-numElementsToZero+1:end) = 0;
end


%%%%%%%%find longest distance
[max_start_index, max_end_index] = find_longest_ones_sequence_indices(num5clust>5);

maxSize = size(Data_y_cropped, 3);
 if weight_right > weight_left
    % Calculate start and end indices
    startIdx = max_start_index - 30;
    endIdx = max_end_index + 40;

    % Test and adjust indices to ensure they are within bounds
    if startIdx > 1 || endIdx < maxSize
        % Adjust indices
        startIdx = max(1, startIdx);
        endIdx = min(maxSize, endIdx);
        disp('Adjusted indices for right-weighted data to fit within bounds.');
    end

% Slice the matrix with adjusted indices
    Data4 = Data_y_cropped(:,:,startIdx:endIdx);
    Vol4 = Vol1(:,:,startIdx:endIdx);
    Vol5 = Vol2(:,:,startIdx:endIdx);
    Pre_seg = clustered3DImage2(:,:,startIdx:endIdx);
else
    % Calculate start and end indices
    startIdx = max_start_index -40;
    endIdx = max_end_index +30;

    % Test and adjust indices to ensure they are within bounds
    if startIdx > 1 || endIdx < maxSize
        % Adjust indices
        startIdx = max(1, startIdx);
        endIdx = min(maxSize, endIdx);
        disp('Adjusted indices for left-weighted data to fit within bounds.');
    end

    % Slice the matrix with adjusted indices
    Data4 = Data_y_cropped(:,:,startIdx:endIdx);
    Vol4 = Vol1(:,:,startIdx:endIdx);
    Vol5 = Vol2(:,:,startIdx:endIdx);
    Pre_seg = clustered3DImage2(:,:,startIdx:endIdx);
 end


if weight_right < weight_left

    Data4 = flip(Data4,3);
    Vol4 = flip(Vol4,3);
    Vol5 = flip(Vol5,3);
    Pre_seg = flip(Pre_seg,3);
end

%%%%%%%%%%%%%%%%%%%%%%%%


end