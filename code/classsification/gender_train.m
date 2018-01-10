function gender_train(train_dir,model_size,cellSize,mode)
    
    fprintf("Training Gender Classifier \n");
    tic;
    trainingSet = imageDatastore(train_dir,'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    countEachLabel(trainingSet);

    numImages = numel(trainingSet.Files);
    trainingFeatures = [];
    % img = rgb2gray(img);

    % trainingFeatures = zeros(numImages, size(img(:),1), 'single');

    for i = 1:numImages
        img = readimage(trainingSet, i);
        img = imresize(img,model_size);

        trainingFeatures(end+1, :) = single(extractHOGFeatures(img, 'CellSize', cellSize));
    %     trainingFeatures(i, :) = single(img(:));
    end

    trainingLabels = trainingSet.Labels;
    
    %% mode RBF || POLY || linear
    if strcmp(mode,'RBF')
        classifier = fitcsvm(trainingFeatures, trainingLabels,'KernelFunction','RBF','KernelScale','auto');
    elseif strcmp(mode,'poly')
        classifier = fitcsvm(trainingFeatures, trainingLabels,'KernelFunction','poly','KernelScale','auto');
    else
        classifier = fitcsvm(trainingFeatures, trainingLabels,'KernelFunction','linear','KernelScale','auto');
    end
    
    save('../data/model/classifier.mat','classifier');
    
    fprintf("Gender Classifier Training done, Time : %0.4fs\n\n",toc);

end