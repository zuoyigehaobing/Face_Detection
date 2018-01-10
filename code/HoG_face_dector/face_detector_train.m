function face_detector_train(DataDir,cellSize,model_size)
    trainingSet = imageDatastore(DataDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

    numImages = numel(trainingSet.Files);
    features = [];
    
    fprintf("Training Data, this may take some time \n");
    tic;
    for i=1:numImages

        % origin face
        img = readimage(trainingSet, i);

        % change it from RGB -> Gray
        if size(img,3) > 1
            img = rgb2gray(img);
        end

        % imgresize to fit the window
        img = imresize(img,model_size);

        % save the training feature of this data
        hog = vl_hog(im2single(img),cellSize);
        features(end+1,:) = hog(:);
    end

    % Get labels for each image.
    trainingLabels = trainingSet.Labels;
    
    % Train linear SVM binary classifier
    face_detector = fitclinear(features,trainingLabels);
    
    fprintf("Training Process done, Used Time %0.4f s \n\n",toc);

    %% save the trained Detector
    pth = '../data/model/face_detector.mat';
    save(pth,'face_detector');
end
