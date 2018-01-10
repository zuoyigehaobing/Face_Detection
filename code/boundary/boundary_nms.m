function [rval] = boundary_nms(boundary,time_thresh)
    for i=1:size(boundary,1)
        cur = boundary(i,2);
        x = find(abs(boundary(:,2)-cur) <= time_thresh & boundary(:,2) ~= cur);
        if size(x,1) > 1 && cur >= 0
            boundary(x,2) = -1;
        end
    end
    rval = boundary(boundary(:,2)>=0,2);
end


%% first encounter approach
% function [rval] = boundary_nms(boundary,time_thresh)
%     bnd = sortrows(boundary);
%     for i=1:size(bnd,1)
%         cur = bnd(i);
%         x = find(abs(bnd-cur) <= time_thresh);
%         if size(x,1) > 1
%             bnd(i) = -1;
%         end
%     end
%     rval = bnd(bnd>=0);
% end
% 