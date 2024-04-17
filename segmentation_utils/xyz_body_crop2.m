function [Data_z_cropped_3,Data_canal, S1_z,S1_y] = xyz_body_crop2(Data,thresh);
   

        try
        
        Data = ipermute(Data,[3 1 2]);

        Data1 = Data(2:end-2,2:end-2,5:end-5);
        [n, m, z] = size(Data1);
        a_z = zeros(1, z);

        for i = 1:z
            a_z(i) = sum(sum(Data1(:, :, i) == 0));
        end

        index_z = find(a_z < n * m * 0.85);
        Data_z = double(Data1(:, :, index_z));
        S1_z = zeros(1, length(index_z));
 
       
        for i = 1:length(index_z)
            p1 = Data_z(:, :, i);
            p1b = p1(p1 ~= 0);
            S1_z(i) = skewness(p1b);
        end

        Sk_t_z = S1_z > thresh;
        [max_start_index_z, max_end_index_z] = find_longest_ones_sequence_indices(Sk_t_z);
        %%%%%%Data_z_cropped
        Data_z_cropped = Data_z(:, :, max_start_index_z:max_end_index_z);
        
        %%%%%%%to find canal slice
        idx = find(S1_z<0.2);

        if length(idx)==0
            idx = find(S1_z<0.5);
        end

        Data_t = Data_z(:,:,idx);
        z1 = size(Data_t,3);
        
        at = [];
        for i =  1:z1
        at(i) = length(find(double(Data_t(:,:,i))==0));
        end
        
if ~isempty(at)
    idx = find(at == 0);
end

Data_canal = Data_t(:,:,idx);

        

        %%%%%%Cropping in x-direction 
%         J = imnlmfilt(mean(Data_canal,3),'DegreeOfSmoothing',5);
%         J = double(J);
%         p2 = imgaussfilt(J,2)-imgaussfilt(J,1);
%         p3 = p2(:,40:60);
%         p4 = mean(p3,2);
%         %plot(p4)
%         idx = kmeans(p4,3);
%         idx_diff = diff(idx);
%         [max_start_index_y, max_end_index_y] = find_longest_zeros_sequence_indices(idx_diff);
%         Data_y_cropped = Data_z_cropped(max_start_index_y:max_end_index_y, :, :);
% 
% 

        % Cropping in x-dimension
        [n, m, z] = size(Data_z_cropped);
        S1_y = zeros(1, n);
        for i = 1:n
            p1 = reshape(Data_z_cropped(i, :, :), 1, []);
            p1b = p1(p1 ~= 0);
            S1_y(i) = skewness(p1b);
        end

        Sk_t_y = S1_y > thresh;
        [max_start_index_y, max_end_index_y] = find_longest_ones_sequence_indices(Sk_t_y);
        Data_z_cropped_2 = Data_z_cropped(max_start_index_y:max_end_index_y, :, :);

      

        %%%%replace 0 value with average value of the canal
        m = mean(Data_canal(:));
        if isempty(Data_z_cropped_2(Data_z_cropped_2==0))==0
        Data_z_cropped_2(Data_z_cropped_2==0)=m;
        Data_z_cropped_3 = Data_z_cropped_2;
        else
            Data_z_cropped_3 = Data_z_cropped_2; 
        end
%             
        catch ME
        % Error handling
        fprintf('An error occurred in xyz_body_crop: %s\n', ME.message);
%           
         % Return empty or default values
        Data_z_cropped_3 = [];
        Data_canal = [];
        S1_z = [];
        S1_y = [];
        end 

    end

  


