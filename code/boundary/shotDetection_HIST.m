function [boundary] = shotDetection_HIST(videoname, tolerance,thresh)
    
    
    dir = '../data/boundary/';
    datafile = sprintf('%s_Video_Data_HIST.mat',videoname);
    check_file = [dir datafile];
    
    fprintf("Running HIST Method for shot Detection \n");

    if ~exist(check_file,'file')
    videofile = sprintf('../videos/%s.mp4',videoname);
    v = VideoReader(videofile);
    f_data = [];
    prev = ones(256,1);
    detected_time = -1;
    while hasFrame(v)
        cur_time = v.CurrentTime;
        vidFrame = readFrame(v);
        imagesc(vidFrame);
        h= imhist(vidFrame);
        similarity = sum(h.*prev)/(norm(h)*norm(prev));
        change = 1-similarity;
        if change*100 > thresh && cur_time-detected_time >=tolerance
            detected_time = cur_time;
            disp([num2str(change*100) '%    ||    ' num2str(cur_time)]);
            pause(3);
        else
            disp(cur_time)
        end
        f_data(end+1,1:2) = [change*100 cur_time];
        prev = h;
        pause(1/v.FrameRate);
    end
    save(check_file,'f_data');

    else
        data = load(check_file);
        f_data = data.f_data;
    end
    
    sorted = sortrows(f_data,1,'descend');
    x = find(sorted(:,1) > thresh);
    if isempty(x)
        boundary = [];
        return
    end
    boundary = sorted(x(1):x(end),:);
    % boundary = sorted(x(1):x(end),2);
    boundary = boundary_nms(boundary,tolerance);


    manualname = [dir sprintf('%s.mat',videoname)];
    data = load(manualname);
    manual = sort(data.shot);

    ShotAccuracy(manual,boundary,tolerance);

    


end