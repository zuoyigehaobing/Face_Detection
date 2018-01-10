function [collect]=nms_fuse(img,boxes,thresh,name,color)
    
    collect = [];
    if isempty(boxes)
        return
    end

    % perform fuse multiple detections
    sorted = sortrows(boxes,5,'descend');

    for i=1:size(sorted,1)
        if sorted(i,5) > thresh
            collect(end+1,:) = sorted(i,:);
            img = insertObjectAnnotation(img, 'rectangle', sorted(i,1:4), name,'Color','g');
            x = find(bboxOverlapRatio(sorted(:,1:4),sorted(i,1:4)) >0.15);
            sorted(x,5) = -1;
            
        end
    end
    
    figure;imshow(img);

end
