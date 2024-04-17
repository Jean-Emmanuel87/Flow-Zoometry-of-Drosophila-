function [Vol1 Vol2 denoisedImg] = bodysegmentation(Data_y_cropped)
    % Apply Gaussian filtering
    denoisedImg = imgaussfilt3(double(Data_y_cropped), 1.6);

    % Set options for Gaussian Mixture Model fitting
    options = statset('MaxIter', 1500);

    % Fit a Gaussian Mixture Model with 2 components
    % gm = fitgmdist(denoisedImg(:), 2, 'Options', options);

    % Fit a Gaussian Mixture model with 3 components
    gm = fitgmdist(denoisedImg(:), 3, 'Options', options);

    %%%%%sort 
    [a bidx] = sort(gm.mu);

    % Cluster the data based on the fitted GMM
    idx = cluster(gm, denoisedImg(:));

    % Reshape the clustering result back into the original image size
    Vol = reshape(idx, size(Data_y_cropped));
    Vol1 = zeros(size(Vol));
    for i = 1:3
    Vol1(Vol==(bidx(i))) = i;
    end

    Vol2 = Vol1>1;

    % Vol = logical(Vol-1);
    [n m z] = size(Vol);
    
    
    % if gm.mu(2)>gm.mu(1)
    % Vol1 = Vol;
    % else
    %     Vol1 = imcomplement(Vol);
    % end

    for i =1:z
        Vol1(:,:,i) = bwareaopen(imfill(Vol2(:,:,i),'holes'),3000);
    end

   Vol1 =  bwareaopen(Vol1,1500);
   Vol2 = (Vol2 + Vol1)>0;
end