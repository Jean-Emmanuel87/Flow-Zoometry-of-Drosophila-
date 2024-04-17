function [clustered3DImage4, Data2, Vol_seg4,clusteredkmeans1,skeleton] = segmented_wing_lastok(Data,Pre_seg);

options = statset('MaxIter', 1500);
Vol_seg = imcomplement((Data==0));

num_Vol = bwlabeln(Vol_seg, 26);  % Labeling the connected components

% Get the unique labels, excluding the background (label 0)
uniqueLabels = unique(num_Vol);
uniqueLabels(uniqueLabels == 0) = [];  % Remove background label if present

% Proceed only if there is more than one unique volume
if length(uniqueLabels) > 1
    % Get properties of the connected components
    props = regionprops3(num_Vol, 'Volume');

    % Find the index of the largest component
    [~, idx] = max(props.Volume);

    % Create a binary volume for the largest component
    largestComponent = num_Vol == idx;

    % largestComponent now contains only the largest connected component
    Vol_seg = largestComponent;
else
    % Only one volume is present; no changes are needed
    Vol_seg = num_Vol > 0;  % Ensure binary output if needed
end






 Data1 = MRIDenoisingODCT(Data,15,15, 0, 0);
 %Data1 = imgaussfilt3(Data,0.6);


% Datat = imgaussfilt3(Data,3)-imgaussfilt3(Data,1);
%Datat = Datat./min(Datat);

%%%%%imporving the body segmentation
% Vol_seg1 = activecontour(Datat./max(Datat(:)),Vol_seg,30);
% Vol_seg4 = zeros(size(Vol_seg1));


Vol_seg1 = Vol_seg;
Vol_seg4 =  zeros(size(Vol_seg1));
for i=1:size(Vol_seg1,3)
aa = bwareaopen(imfill(Vol_seg1(:,:,i),'holes'),100);
Vol_seg4(:,:,i)=aa;
end

Vol_seg4 = bwareaopen(imerode(Vol_seg4,strel('disk',4)),300);

%Data2 = immultiply(Data1,Vol_seg1);
%Data3 = immultiply(Data1,Vol_seg4);

 intensityValues = Data1(Vol_seg4==1);
 n = 3; %number of cluster
 p = log(intensityValues);
 p(p==-inf) = 0;
 intensityValues = p;


 Data2 = zeros(size(Data1));
 intensityValues = (intensityValues-min(intensityValues))./(max(intensityValues)-min(intensityValues));
 %Data2(Vol_seg4==1) = intensityValues;

intensityValues =  normalization_global(sqrt(intensityValues));

Data2(Vol_seg4==1) = intensityValues;
iq = quantile(intensityValues,0.75);
Vol_temp = Data2>iq;

intensityValues = Data2(Vol_temp==1);

%%%%%kmeans clustering
%         n1=3;
%         [c idx] = kmeans(intensityValues,n1,'MaxIter',1000);
%         clusteredkmeans = zeros(size(Data2)); % Or use another value to initialize
%         % Assign the cluster indices back to the original 3D image structure
%         clusteredkmeans(Vol_seg4==1) = c;
% 
%         [aidx bidx] = sort(idx(:,1));
%          clusteredkmeans1 =zeros(size(clusteredkmeans));
%         for i =1:n1
%             clusteredkmeans1(clusteredkmeans==(bidx(i))) = i;
%         end
%         clusteredkmeans2 = clusteredkmeans1==n1;
%         clusteredkmeans2 = bwareaopen(clusteredkmeans2,80);
%         Data4 = bwlabeln(clusteredkmeans2,18);

%%%%%%%%end kmeans clustering

%%%%%kmeans clustering
        n1=2;
        [c idx] = kmeans(intensityValues,n1,'MaxIter',1000);
        clusteredkmeans = zeros(size(Data2)); % Or use another value to initialize
        % Assign the cluster indices back to the original 3D image structure
        clusteredkmeans(Vol_temp==1) = c;

        [aidx bidx] = sort(idx(:,1));
         clusteredkmeans1 =zeros(size(clusteredkmeans));
        for i =1:n1
            clusteredkmeans1(clusteredkmeans==(bidx(i))) = i;
        end
        clusteredkmeans2 = clusteredkmeans1==n1;
        clusteredkmeans2 = bwareaopen(clusteredkmeans2,80);
        Data4 = bwlabeln(clusteredkmeans2,18);


skeleton = bwskel(Data4>0, 'MinBranchLength', 6);

%Data2(Vol_seg4==1) = intensityValues; %+ min(intensityValues);
% 
% %%%%%%test
% Data3 = Data1.*clusteredkmeans2;
% 
% 
% 
% for i =1: size(Data,3)
%     n1=2;
%     slice = Data3(:,:,i);
%     cluster_slice = clusteredkmeans2(:,:,i);
% 
%     slice_segmented = zeros(size(slice));
% 
% intensityValues_slices = slice(cluster_slice==1);
% 
% if length(intensityValues_slices)<3
%     Segemt_2D(:,:,i) = slice_segmented;
% else
% 
% [c1 idx1] = kmeans(intensityValues_slices,n1,'MaxIter',1000);
% 
%  slice_segmented(cluster_slice==1) = c1;
% 
%         [aidx_s bidx_s] = sort(idx1(:,1));
%         slice_segmented_1 =zeros(size(slice_segmented));
%         for j =1:n1
%             slice_segmented_1(slice_segmented==(bidx_s(j))) = j;
%         end
% 
%         Segemt_2D(:,:,i)=slice_segmented_1;
% end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%test finish


%%%%%%%%gmm clustering
%  n=4;
%     options = statset('MaxIter', 1500);
%     gm = fitgmdist(intensityValues,n,'Options',options);
%     clusterIdx = cluster(gm,intensityValues);
%     clustered3DImage = zeros(size(Data)); % Or use another value to initialize
%     % Assign the cluster indices back to the original 3D image structure
%     clustered3DImage(Vol_seg4 == 1) = clusterIdx;
%     %clustered3DImage(Data4==1) = clusterIdx;
% 
%     clustered3DImage2 = zeros(size(clustered3DImage));
%     [aidx bidx] = sort(gm.mu(:,1));
% 
%     for i =1:n
%          clustered3DImage2(clustered3DImage==(bidx(i))) = i;
%     end
% 
%     clustered3DImage2 = clustered3DImage2==n;
%     clustered3DImage2 = logical(clustered3DImage2);
%     clustered3DImage3 = bwareaopen(clustered3DImage2,100);
%     Data4 = bwlabeln(clustered3DImage3, 18);


    clustered3DImage4 = Data4;
  
%%%%%%%%%%%%%%estimate correlation
% for i = 1:size(Data1,3)
% C(i) = corr2(clustered3DImage4(:,:,i),std(clusteredkmeans1,[],3));
% end
%%%%%%%%%%%%%%%%%%%%%%%estimate correlation
labels = unique(clustered3DImage4);
labels(labels == 0) = []; % Remove background label if present

% First part: Filtering based on quantile regions be careful with this
for i = 1:length(labels)
  inds = find(clustered3DImage4 == labels(i));  
  [x, y, z] = ind2sub(size(clustered3DImage4), inds);
       inQuantileRegionCount = 0;
   
    for j = 1:length(inds)
        if Pre_seg(x(j), y(j),z(j)) == 1
           inQuantileRegionCount = inQuantileRegionCount + 1;
       end
   end
   
   percentageInQuantileRegion = (inQuantileRegionCount / length(inds)) * 100;
   
   if percentageInQuantileRegion > 12
       clustered3DImage4(clustered3DImage4 == labels(i)) = 0;
   end
end

%%%%%to filter out large shape and small shape

    clustered3DImage4 = bwlabeln(clustered3DImage4>0,18);
    maxLabel = length(unique(clustered3DImage4(:)))-1; % This gives the number of connected components

    % Initialize a vector to store the size of each component
    componentSizes = zeros(1, maxLabel);

    for i = 1:maxLabel
    componentSizes(i) = sum(clustered3DImage4(:) == i); % Count voxels for each label
    end

    id_component = find(componentSizes>2500);
    id_component1 = find(componentSizes<80);

    if isempty(id_component)
     clustered3DImage4 = clustered3DImage4;
    else 
    for i = 1:numel(id_component)
        clustered3DImage4(clustered3DImage4==id_component(i))=0;
    end
    end

    if isempty(id_component1)
     clustered3DImage4 = clustered3DImage4;
    else 
    for i = 1:numel(id_component1)
        clustered3DImage4(clustered3DImage4==id_component1(i))=0;
    end
    end

%%%%%%%filter_out some savlivarygland shape
clustered3DImage4 = bwlabeln(clustered3DImage4>0,18);

labels1 = unique(clustered3DImage4);
labels1(labels1 == 0) = []; 
%%%%%%filter outsome uncircular shape

 J = [];

for i = 1:length(labels1)
    A = zeros(size(Data1,1),size(Data1,2));
    inds = find(clustered3DImage4 == labels1(i));
    [x, y, z] = ind2sub(size(clustered3DImage4), inds);

    for j =1:numel(x)
    A(x(j),y(j)) = 1;
    end
    A = imdilate(A,strel('disk',2));
    J(i) = struct2array(regionprops(A,'Circularity'));
    clear A

end
     

    id_component_J = find(J<0.35);
    if isempty(id_component_J)
     clustered3DImage4 = clustered3DImage4;
    else 

    for i = 1:numel(id_component_J)
        clustered3DImage4(clustered3DImage4==id_component_J(i))=0;
    end
    end

    

    %%%%%%%correlation function
% C1 = (C>0.055);
% [max_start_index, max_end_index] = find_longest_ones_sequence_indices(C1);
% 
% clustered3DImage4 = clustered3DImage4(:,:,max_start_index:max_end_index);

%%%%%%%%%%%correlation function


clustered3DImage4 = bwlabeln(bwareaopen(clustered3DImage4>0,50),18);

%%%%%%%%filter bounding box extension : 
 props = regionprops3( clustered3DImage4, 'BoundingBox');

% Extract z-axis extension for each object
zExtension = zeros(size(props, 1), 1); % Initialize array to store z-axis extensions
for i = 1:size(props, 1)
    % BoundingBox format: [x_min y_min z_min width_x width_y width_z]
    % z-axis extension is given by the 'width_z' component of the bounding box
    zExtension(i) = props.BoundingBox(i, 6);
end

    id_component_ext = find(zExtension<6);
  if isempty(id_component_ext)
     clustered3DImage4 = clustered3DImage4;
    else 
    for i = 1:numel(id_component_ext)
        clustered3DImage4(clustered3DImage4==id_component_ext(i))=0;
    end


      clustered3DImage4 = bwlabeln(clustered3DImage4>0,18);


end

clustered3DImage4 = Data4;






