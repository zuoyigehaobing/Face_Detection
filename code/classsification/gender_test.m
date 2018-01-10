function gender_test(test_dir,model_size,cellSize)

    fprintf('Testing Gender Classifier\n');
    testset = imageDatastore(test_dir,'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    c=countEachLabel(testset);
    load('../data/model/classifier.mat');

    numImages = numel(testset.Files);
    load('../data/model/classifier.mat');

    count = 0;
    female_count=0;
    male_count=0;

    for i = 1:numImages
        img = readimage(testset, i);
        img = imresize(img,model_size);

        feature = extractHOGFeatures(img, 'CellSize', cellSize);
        predictedLabels = predict(classifier, feature);
        if predictedLabels ==  testset.Labels(i)
            if strcmp(string(testset.Labels(i)),'male')
                male_count = male_count + 1;
            else
                female_count = female_count + 1;
            end
            count = count +1;
        end

    end
    
    fprintf("Female Accuracy : %0.4f%% \n",female_count*100/c.Count(1));
    fprintf("Male Accuracy : %0.4f%% \n",male_count*100/c.Count(2));
    fprintf("Testing : Gender Classification Accuracy : %0.4f%% \n\n",count*100/numImages);

end