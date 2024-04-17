function features = extract_features(binary_mask)

% extract_features Extracts various geometric and intensity-based features from a 3D binary mask.
% These feature includes volume, bounding box dimensions, solidity,
% principal axis lengths, extent, and compatcness. Additional features
% beased on pairewise distances within each component are also computed.

% Input :
% binary_mask -A 3D binary image where the features are to be extracted.
%
%Outputs :
%   features - A row vector containing all the computed features for the
%   input mask


    % Use regionprops3 to compute properties of connected components in 3D
  
disp('Extracting features for random forest...')

    if all(binary_mask(:) == 0)
        % If the binary mask is empty, return zeros for all features
        num_features = 30; % Number of features
        features = zeros(1, num_features);
        return; % Exit the function
    end

    % Use regionprops3 to compute properties of connected components in 3D
    stats = regionprops3(bwlabeln(binary_mask,18), 'Volume', 'BoundingBox', 'Solidity', 'PrincipalAxisLength', 'Extent','SurfaceArea','VoxelList');
    
    % Extract features from the region properties
    num_objects = numel(stats.Volume);
    
    % Initialize arrays to store feature values
    volumes = [stats.Volume];
    bounding_boxes = [stats.BoundingBox];
    solidities = [stats.Solidity];
    principal_axes_lengths = [stats.PrincipalAxisLength];
    extents = [stats.Extent];
    surface_areas = [stats.SurfaceArea];


    % Reshape bounding boxes to extract width, height, and depth
    bounding_boxes = reshape(bounding_boxes, 6, [])';
    bounding_box_widths = bounding_boxes(:, 4);
    bounding_box_heights = bounding_boxes(:, 5);
    bounding_box_depths = bounding_boxes(:, 6);
    
    % Compute additional features if needed
    
    
    
    % Compute ratios of principal axes lengths
    principal_axis_ratio_1_2 = principal_axes_lengths(:, 1) ./ principal_axes_lengths(:, 2);
    principal_axis_ratio_1_3 = principal_axes_lengths(:, 1) ./ principal_axes_lengths(:, 3);
    
    % Compute average and maximum values for each feature category
    avg_volume = mean(volumes);
    max_volume = max(volumes);
    avg_bounding_box_width = mean(bounding_box_widths);
    max_bounding_box_width = max(bounding_box_widths);
    avg_bounding_box_height = mean(bounding_box_heights);
    max_bounding_box_height = max(bounding_box_heights);
    avg_bounding_box_depth = mean(bounding_box_depths);
    max_bounding_box_depth = max(bounding_box_depths);
    avg_solidity = mean(solidities);
    max_solidity = max(solidities);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute compactness as the ratio of volume to surface area
    % Assuming you have computed the surface area as a feature
    compactness =  (surface_areas.^3)./(volumes.^2);



    % Compute average and maximum compactness
    avg_compactness = mean(compactness);
    max_compactness = max(compactness);
    
    % Compute average and maximum ratios of principal axes lengths
    avg_principal_axis_ratio_1_2 = mean(principal_axis_ratio_1_2);
    max_principal_axis_ratio_1_2 = max(principal_axis_ratio_1_2);
    avg_principal_axis_ratio_1_3 = mean(principal_axis_ratio_1_3);
    max_principal_axis_ratio_1_3 = max(principal_axis_ratio_1_3);
    
    % Compute average and maximum extent
    avg_extent = mean(extents);
    max_extent = max(extents);
    % compactness

    %%%%%%%D2s 

   voxel_coords = stats.VoxelList;
   num_shapes = numel(voxel_coords); % Number of shapes
    
    % Initialize variables to store histograms for each shape
    all_feature_I = zeros(num_shapes, 6); % Cell array to store histograms
    
    % Loop through each shape to compute its histogram
    for i = 1:num_shapes
        % Concatenate voxel coordinates for the current shape
        shape_coords = voxel_coords{i};
        
        % Compute pairwise distances for the current shape
        distances = pdist(shape_coords);
        
        % Convert pairwise distances to a square distance matrix
        distance_matrix = squareform(distances);
        
        % Remove the diagonal elements (distances between points and themselves)
        distance_matrix(logical(eye(size(distance_matrix)))) = NaN;
        
        % Select only the upper triangular part of the distance matrix
        distance_matrix = triu(distance_matrix);


        upper_triangular_intensities = distance_matrix(logical(triu(ones(size(distance_matrix)), 1)));
        
        feature_I = [quantile(upper_triangular_intensities,0.05) quantile(upper_triangular_intensities,0.25) quantile(upper_triangular_intensities,0.5) quantile(upper_triangular_intensities,0.75) quantile(upper_triangular_intensities,0.95) quantile(upper_triangular_intensities,1)];
        % Compute the 2D histogram for the current shape
        all_feature_I(i,:) = feature_I;
    end

    if num_shapes==1 
    average_2ds = mean(all_feature_I,1);
    max_2ds = max(all_feature_I,1);
    else
    average_2ds = mean(all_feature_I);
    max_2ds = max(all_feature_I);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Store features in a vector
    features = [avg_volume, max_volume, ...
                avg_bounding_box_width, max_bounding_box_width, ...
                avg_bounding_box_height, max_bounding_box_height, ...
                avg_bounding_box_depth, max_bounding_box_depth, ...
                avg_solidity, max_solidity, ...
                avg_principal_axis_ratio_1_2, max_principal_axis_ratio_1_2, ...
                avg_principal_axis_ratio_1_3, max_principal_axis_ratio_1_3, ...
                avg_extent, max_extent,avg_compactness,max_compactness,average_2ds,max_2ds];
end