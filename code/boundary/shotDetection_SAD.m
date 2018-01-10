function [boundary]=shotDetection_SAD(videoname,tolerance,thresh)
    
    fprintf("Running SAD(SSD) Method for shot Detection \n");


    dir = '../data/boundary/';
    datafile = sprintf('%s_Video_Data_SSD.mat',videoname);
    check_file = [dir datafile];

    if ~exist(check_file,'file')
        videofile = sprintf('../videos/%s.mp4',videoname);
        v = VideoReader(videofile);
        f_data = [];
        prev = zeros(v.Height,v.Width) + 1;
        detected_time = -1;
        
        while hasFrame(v)
            cur_time = v.CurrentTime;
            vidFrame = readFrame(v);
            imagesc(vidFrame);
            con = double(rgb2gray(vidFrame));
            similarity = sum(con(:).*prev(:))/(norm(con(:))*norm(prev(:)));
            change = 1 - similarity;
            if change*100 > thresh && cur_time-detected_time >=tolerance
                disp([num2str(change*100) '%    ||    ' num2str(cur_time)]);
                detected_time = cur_time;
                pause(1.5);
            else
                disp(cur_time);
            end
            f_data(end+1,1:2) = [change*100 cur_time];
            prev = con;
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
    
    boundary = boundary_nms(sorted(x(1):x(end),[1 2]),tolerance);

    manualname = [dir sprintf('%s.mat',videoname)];
    data = load(manualname);
    manual = sort(data.shot);


    ShotAccuracy(manual,boundary,tolerance);
end
