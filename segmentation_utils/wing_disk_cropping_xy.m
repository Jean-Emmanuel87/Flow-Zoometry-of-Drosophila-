function [Z,Vol5,Pre_seg] = wing_disk_cropping_xy(Data4,Vol5,Pre_seg)
    
    Z = immultiply(Data4,Vol5);
    Vol6 = sum(Vol5,3);
    yy = find(sum(Vol6)==0);
    xx = find(sum(Vol6')==0);

    Vol5(xx,:,:) = [];
    Vol5(:,yy,:)= [];
    Z(xx,:,:) = [];
    Z(:,yy,:) = [];
    Pre_seg(xx,:,:) = [];
    Pre_seg(:,yy,:) = [];
end
   
