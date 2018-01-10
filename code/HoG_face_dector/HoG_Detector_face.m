function [faces]=HoG_Detector_face(img,model_size,size_set,bag)
    
    % img = imread('../images/test.jpg');
    cellSize = bag(1);
    stride = bag(2);
    data = load('../data/model/face_detector.mat');
    face_detector = data.face_detector;
    
    window = [model_size-1 3];
    % showboxesMy(im,[col row colend rowend],'r');

    % record vector 1~4:position 5:score
    pth = sprintf('../data/tem_data/hog_trial.mat');
    
    
    if ~exist(pth,'file') || bag(4) == 1
        fprintf("Detecting Faces \n");
        faces = [];

        tic;
        for k=1:size(size_set,2)
            fprintf("%d/%d  ",k,size(size_set,2));
            resize_factor = size_set(k);
            im = imresize(img,resize_factor);
            % figure;axis on;imshow(im);
            

            for i=1:stride:size(im,1) - window(1)
                for j=1:stride:size(im,2) - window(2)
                    patch = im(i:i+window(1),j:j+window(2));

                    if size(patch,3) > 1
                        patch = rgb2gray(patch);
                    end

                    % imgresize to fit the model
                    patch = imresize(patch,model_size);

                    hog = vl_hog(im2single(patch), cellSize);
                    h = reshape(hog(:),[1 size(hog(:),1)]);

                    [label,score] = predict(face_detector,h);

                    if string(label) == 'face'
                        box = [j i j+window(2) i+window(1)];
                        % showboxesMy(im,[j i j+window(2) i+window(1)],'r');
                        box = box/resize_factor;
                        rebox = [box(1) box(2) box(3)-box(1) box(4)-box(2)];
                        faces(end+1,:) = [round(rebox(:));score(1)];
                    end
                end
            end
        end
        fprintf('\n Face Detected Down, Time Cost = %0.4f s \n',toc);
        save(pth,'faces');
    else
        tem_data = load(pth);
        faces = tem_data.faces;
    end
    
    %% fuse multiple detections
    faces = nms_fuse(img,faces,bag(3),'face','y');

end