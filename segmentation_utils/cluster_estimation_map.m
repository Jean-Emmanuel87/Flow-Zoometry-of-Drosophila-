function [num5clust clustered3DImage3] = cluster_estimation_map(clustered3DImage2,folderPath,filter)

    num5clust = zeros(1,size(clustered3DImage2,3));
    for ko = 1:size(clustered3DImage2,3)
        ref = clustered3DImage2(:,:,ko);
    num5clust(ko) = sum(ref(:)==1);
    end
    
    clustered3DImage3 = clustered3DImage2;

%     [~, baseFileName, ~] = fileparts(filter);
%     fig = figure;
%     plot(num5clust);
%     %imageFileName = sprintf('%s%04d%s', baseFileName, i, fileExtension1);
%     imageFileName = sprintf('%s_cluster6.png', baseFileName);
%     fullFilePath = fullfile(folderPath, imageFileName);
%     frame = getframe(fig);
%     imwrite(frame.cdata, fullFilePath);
%      close (fig)
    % close (fig)
end


 