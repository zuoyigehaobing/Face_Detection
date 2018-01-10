function logo_train(DataDir,cellSize,model_size)
    

    trainingSet = imageDatastore(DataDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    cont = countEachLabel(trainingSet);

    numImages = numel(trainingSet.Files);
    features = [];
    
    fprintf("Training Logo Detector \n");
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

        hog = vl_hog(im2single(img), cellSize);
        h = reshape(hog(:),[1 size(hog(:),1)]);

        % save the training feature of this data
        features(end+1,:) = double(h(:));
    end


    % Get labels for each image.
    trainingLabels = trainingSet.Labels;
    

    %% Linear
    % logo_detector = fitcsvm(features,trainingLabels,'KernelFunction','linear','KernelScale','auto');

    %% RBF
    logo_detector = fitcsvm(features,trainingLabels,'KernelFunction','RBF','KernelScale','auto');

    %% POLY
    % logo_detector = fitcsvm(features,trainingLabels,'KernelFunction','polynomial','KernelScale','auto','PolynomialOrder',2);


    %% save the trained Detector
    pth = '../data/model/logo_detector.mat';
    save(pth,'logo_detector');

    fprintf('Training Done, Time used : %0.4fs \n\n',toc);
end