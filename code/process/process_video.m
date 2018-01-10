function process_video(videoname,model_size,size_set,bagged_param,shot,record)  
    % save the output video
    if ~exist('record')
        record =0;
    end
    
    
    faceDetector = vision.CascadeObjectDetector('MergeThreshold',4);
    pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

    
    videofile = sprintf('../videos/%s.mp4',videoname);
    v = VideoReader(videofile);

    
    videoFrame = readFrame(v);
    frameSize = size(videoFrame);
    videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

    load('../data/model/classifier.mat');
    cellSize = [10 10];
    numPts = 0;
    runLoop = true;
    frameCount = 0;
    bbox = [];
    box_color = {'red','green','yellow'};
    
    if record ==1
        name = strcat(videoname,'.avi');
        o = VideoWriter(name);
        open(o);
    end
    
    %% process the video
    v.CurrentTime = 0;
    while runLoop && hasFrame(v)
        
        cur_time = v.CurrentTime;
        % Get the next frame.
        videoFrame = readFrame(v);
        videoFrameGray = rgb2gray(videoFrame);
        frameCount = frameCount + 1;
        
        
        if ismember(cur_time,shot)
            videoFrame = readFrame(v);
            videoFrame = readFrame(v);
            videoFrame = readFrame(v);
            % Detection face Using HoG Detector.
            
            disp(cur_time);
            faces = HoG_Detector_face(videoFrame,model_size,size_set,bagged_param);
           
            
            
            tracker = {};
            old ={};
            bboxPoints = {};
            type ={};
           if ~isempty(faces)
                bbox = faces(:,1:4);
                for i=1:size(bbox,1)
                    % identify gender
                    temp_img = videoFrameGray(bbox(i,2):bbox(i,2)+bbox(i,4),bbox(i,1):bbox(i,1)+bbox(i,3));
                    temp_img = mat2gray(temp_img);
                    temp_img = imresize(temp_img,model_size);
                    feature = extractHOGFeatures(temp_img, 'CellSize', cellSize);
                    
                    predictedLabels = predict(classifier, feature);
                    if strcmp(char(predictedLabels), 'male')==1
                        col = box_color{1};
                        videoFrame=insertText(videoFrame,[bbox(i,1) bbox(i,2) ],'Male');
                        type{i} = 'male';
                    else
                        col = box_color{2};
                        videoFrame=insertText(videoFrame,[bbox(i,1) bbox(i,2) ],'female');
                        type{i} = 'female';
                    end
                    
                    % tracking
                    points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(i, :));
                    tracker{i}=vision.PointTracker('MaxBidirectionalError', 2);
                    xyPoints = points.Location;
                    numPts = size(xyPoints,1);

                    bboxPoints{i} = bbox2points(bbox(i, :));
                    release(tracker{i});
                    initialize(tracker{i}, xyPoints, videoFrameGray);
                    
                    % Save a copy of the points.
                    old{i} = xyPoints;


                    % Convert the box corners
                    bboxPolygon = reshape(bboxPoints{i}', 1, []);

                    % Display a bounding box around the detected face.
                    videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3,'Color',col);

                end
           end
        else
            for i=1:size(bbox,1)
                [xyPoints, isFound] = step(tracker{i}, videoFrameGray);
                visiblePoints = xyPoints(isFound, :);
                oldInliers = old{i}(isFound, :);

                numPts = size(visiblePoints, 1);
                
                if numPts >= 3
                    
                    % Estimate the Similarity transformation 
                    [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                        oldInliers, visiblePoints, 'similarity', 'MaxNumTrials', 100);
                    
                    % Apply the transformation to the bounding box.
                    bboxPoints{i} = transformPointsForward(xform, bboxPoints{i});

                    % Convert the box corners
                    bboxPolygon = reshape(bboxPoints{i}', 1, []);
                    if strcmp(type{i}, 'male')==1

                        col = box_color{1};
                        videoFrame=insertText(videoFrame,[bboxPolygon(1) bboxPolygon(2)],'Male');
                    else

                        col = box_color{2};
                        videoFrame=insertText(videoFrame,[bboxPolygon(1) bboxPolygon(2)],'female');
                    end
                    
                    % Plot the Tracked Face-Bounding-Box
                    videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3,'Color',col);

                    % Reset the points.
                    old{i} = visiblePoints;
                    setPoints(tracker{i}, old{i});
                end
            end
         end

        % Display the annotated video frame.
        step(videoPlayer, videoFrame);

        % Check whether the video player window has been closed.
        runLoop = isOpen(videoPlayer);
        
        if record ==1
            writeVideo(o,videoFrame);
        end
    end

    if record ==1
        close(o);
    end
    
    release(videoPlayer);
    release(pointTracker);
    release(faceDetector);
end










