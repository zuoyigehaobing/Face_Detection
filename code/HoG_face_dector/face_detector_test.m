function [miss,miss_score] = face_detector_test(DataDir,cellSize,model_size)
    
    data = load('../data/model/face_detector.mat');
    face_detector = data.face_detector;
    testingSet = imageDatastore(DataDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    count = countEachLabel(testingSet);
    total = count.Count;

    accuracy = 0;
    
    fprintf("Testing Data\n");
    tic;
    for i=1:sum(total)
        im = readimage(testingSet,i);

        % change it from RGB -> Gray
        if size(im,3) > 1
            im = rgb2gray(im);
        end

        % imgresize to fit the model
        im = imresize(im,model_size);


        hog = vl_hog(im2single(im), cellSize);
        h = reshape(hog(:),[1 size(hog(:),1)]);
        [label,score] = predict(face_detector,h);
        if label == testingSet.Labels(i)
            accuracy = accuracy + 1;
        else
            miss = readimage(testingSet,i);
            miss_score = score(1);
        end

    end

    fprintf('The accuracy over %i testing cases is %0.4f %% \n',sum(total),100 * accuracy/sum(total));
    


    im = imread('../images/hog_image.jpg');
    % change it from RGB -> Gray
    if size(im,3) > 1
        im = rgb2gray(im);
    end
    % imgresize to fit the model
    im = imresize(im,model_size);

    hog = vl_hog(im2single(im), cellSize);
    h = reshape(hog(:),[1 size(hog(:),1)]);
    [label,score] = predict(face_detector,h);

    fprintf('House with prediction : %s || score : %0.4f \n',string(label),score(1));



    im = imread('../images/trial2.png');
    % change it from RGB -> Gray
    if size(im,3) > 1
        im = rgb2gray(im);
    end
    % imgresize to fit the model
    im = imresize(im,model_size);

    hog = vl_hog(im2single(im), cellSize);
    h = reshape(hog(:),[1 size(hog(:),1)]);
    [label,score] = predict(face_detector,h);
    fprintf('Face with prediction : %s || score : %0.4f \n\n',string(label),score(1));

    fprintf("Testing Done, Time used %0.4f s \n\n",toc);


end