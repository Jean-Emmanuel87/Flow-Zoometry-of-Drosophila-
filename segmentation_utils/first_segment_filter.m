function K8 = first_segment_filter(K5,numFiles)

% Assume D1 is your 3D binary image
for l =1:numFiles
% Compute the properties of connected components in the binary image
stats = regionprops3(bwlabeln(K5{l},18), 'all');

% Find the indices of components with the principal axis longer than 20
toRemove = find(max([stats.PrincipalAxisLength],[],2) < 20);

D1 = K5{l};
% Create a new binary image without these components
for i = 1:length(toRemove)
    voxelList = stats.VoxelIdxList{toRemove(i)};
    D1(voxelList) = 0;
end

% If you want to relabel the remaining components
D1 = bwlabeln(D1);
K8{l} = D1;
end

end
