function K9 = second_label_filtering(K8,K4,numFiles);



K9 = cell(1, numFiles); % Initialize K9 to store the output


for i  = 1 : numFiles
    temps_k = K8{i};
    temps_intensity = K4{i};

    % Check if either K8{i} or K4{i} is empty
    if isempty(K8{i}) || isempty(K4{i})
        K9{i} = zeros(10, 10, 69); % Assign default zeros array
        continue; % Skip to the next iteration
    end

N  = unique(temps_k);
N(1)=[];
if numel(N)>3;
for j1 =1:numel(N)
inds = find(temps_k == j1);
Me(j1) = mean(temps_intensity(inds));
end
Me = Me/max(Me);
stats = table2array(regionprops3(temps_k, 'Centroid'));
[aidx bidx] = kmeans([Me' 0.75*stats./max(stats)],3);

% [t1 t2] = sort(bidx);
% index_remove = t2(1);
% index_remove_pos = find(aidx==index_remove(1));


[t1 t2] = sort(bidx(:,1));
index_remove = t2(1:2);
index_remove_pos = find((aidx==index_remove(1)| (aidx==index_remove(2))));


for tp = 1:numel(index_remove_pos)
    inds = find(temps_k == index_remove_pos(tp));
    temps_k(inds)=0;
end

end

% if numel(N)<=4 | numel(N)>2;
% for j1 =1:numel(N)
% inds = find(temps_k == j1);
% Me(j1) = mean(temps_intensity(inds));
% end
% Me = Me/max(Me);
% stats = table2array(regionprops3(temps_k, 'Centroid'));
% [aidx bidx] = kmeans([Me' 0.75*stats./max(stats)],2);
% 
% % [t1 t2] = sort(bidx);
% % index_remove = t2(1);
% % index_remove_pos = find(aidx==index_remove(1));
% 
% [t1 t2] = sort(bidx);
% index_remove = t2(1);
% index_remove_pos = find(aidx==index_remove(1));
% 
% 
% for tp = 1:numel(index_remove_pos)
%     inds = find(temps_k == index_remove_pos(tp));
%     temps_k(inds)=0;
% end
% end


K9{i} = bwlabeln(temps_k>0,18);

clear Me
end
end
