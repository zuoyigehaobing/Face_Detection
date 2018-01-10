function processimg(number)
load('./imdb/imdb.mat');
train_dir = fullfile(pwd,'imdb');

mkdir('female');
mkdir('male');

faceDetector = vision.CascadeObjectDetector('MergeThreshold',6);
for i = 30000:35000
    local_path = imdb.full_path{i};
    path = fullfile(pwd,'imdb',local_path);
    img = imread(path);

    f_location = floor(imdb.face_location{i});
    gen = imdb.gender(i);
    face_score = imdb.face_score(i);
    second_face_score = imdb.second_face_score(i);
    if face_score <3
        continue;
    end
    if ~isnan(second_face_score)
        continue;
    end    
    bbox = faceDetector.step(img);
    if ~isempty(bbox)
        img = img(bbox(1,2):bbox(1,2)+bbox(1,4),bbox(1,1):bbox(1,1)+bbox(1,3));
        img = mat2gray(img);
        img = imresize(img,[180 200]);
        
        if isnan(gen)
            continue;
        elseif gen == 0
            n_name = 'female';
        else
            n_name = 'male';
        end
        saveto = strcat(pwd,'/',n_name,'/',num2str(i),'.jpg');
        imwrite(img,saveto)
    end


end

end
