function [clustered3DImage3,Z,clustered3DImage4,Pre_seg_cropped,Data2,skeleton]=parallel_block_v2(Data_y_cropped,folderPath,filteredFileNames)


        % GMM segmentation
        [Vol1, Vol2, denoisedImg] = bodysegmentation(Data_y_cropped);
      
        % Clustering
        [clustered3DImage3] = clustering_kmeans_quantile(denoisedImg, Vol1);

        % Cluster estimation map
        [num5clust, clustered3DImage3] = cluster_estimation_map(clustered3DImage3, folderPath, filteredFileNames);

        % Cropping wing disk
        [Vol4, Vol5, Data4, Pre_seg] = croppping_wing_disk_3(num5clust, Data_y_cropped, Vol1, Vol2, clustered3DImage3);

        % Additional checks can be implemented here if necessary

        % Wing disk cropping in XY
        [Z, Vol5, Pre_seg_cropped] = wing_disk_cropping_xy(Data4, Vol5, Pre_seg);

        % Last segmentation step
        [clustered3DImage4, Data2, Vol_seg4, clusteredkmeans1,skeleton] = segmented_wing_lastok(Z, Pre_seg_cropped);

end