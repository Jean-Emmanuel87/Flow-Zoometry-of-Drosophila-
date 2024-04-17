function clustered3DImage3 = clustering_kmeans_quantile(denoisedImg,Vol1)        

        denoisedImg2 = denoisedImg;
        intensityValues = denoisedImg2(Vol1==1);

        % %%%option
        % [n m z] = size(Vol1);
        % for i =1:z
        % a2 = Vol1(:,:,i);
        % Vol2(:,:,i) = a2.*i;
        % end
        % intensityValues = denoisedImg2(Vol1==1);
        % bin = Vol2(Vol1==1);
        

        %bin = Vol2(Vol1==1);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        iq = quantile(intensityValues,0.99);
        Vol_temp = denoisedImg2>iq;
       % Vol_temp = Vol1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %intensityValues = denoisedImg2(Vol_temp==1); to include for
        %quantile
        %%%%%kmeans
%         [c idx] = kmeans(([intensityValues]),6,'MaxIter',1000);
%         clustered3DImage = zeros(size(denoisedImg2)); % Or use another value to initialize
%         % Assign the cluster indices back to the original 3D image structure
        %clustered3DImage(Vol1==1) = c;

       % clustered3DImage(Vol_temp==1) = c;
%%%%kmeans

%%%%%%%%%%%%%%%%%%%%%%%kmeans
%         [aidx bidx] = sort(idx(:,1));
%          clustered3DImage2 =zeros(size(clustered3DImage));
%         for i =1:6
%             clustered3DImage2(clustered3DImage==(bidx(i))) = i;
%         end
%         %%%%%%%%kmeans
%         clustered3DImage3 = clustered3DImage2==6;



        clustered3DImage3 = Vol_temp;   %%%%%%to imclude for the quantile
        clustered3DImage3 = bwareaopen(clustered3DImage3>0,3500);
       
        end