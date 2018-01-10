function [miss,miss_score]=logo_test(DataDir,cellSize,model_size)

    testingSet = imageDatastore(DataDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    count = countEachLabel(testingSet);
    total = count.Count;

    data = load('../data/model/logo_detector.mat');
    logo_detector = data.logo_detector;

    accuracy = 0;
    
    fprintf("Testing Logo Data\n");
    for i=1:sum(total)
        im = readimage(testingSet,i);

        % change it from RGB -> Gray
        if size(im,3) > 1
            im = rgb2gray(im);
        end

        % imgresize to fit the model
        im = imresize(im,model_size);

        % BW = edge(img,'Canny',0.4);

        % h = reshape(im(:),[1,size(im(:),1)]);
        hog = vl_hog(im2single(im), cellSize);
        h = reshape(hog(:),[1 size(hog(:),1)]);


        [label,score] = predict(logo_detector,double(h));

        if label == testingSet.Labels(i)
            accuracy = accuracy + 1;
        else
            fprintf('Miss Hit : score = %0.4f  label : %s \n',score(1),string(testingSet.Labels(i)));
            miss = readimage(testingSet,i);
            miss_score = score(1);
        end

    end

    fprintf('The accuracy over %i testing cases is %0.4f %% \n\n',sum(total),100 * accuracy/sum(total));

end