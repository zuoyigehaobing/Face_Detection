files = dir('../jpg/face_train/face/*.jpg');
num = size(files,1);

for i=1:num
    name = [files(i).folder '/' files(i).name];
    im = imread(name);
    cropped = im(40:end-20,40:end-30,:);
    cropped = imresize(cropped,[140 110]);
    pth = ['../jpg/cropped_face_train/face/' files(i).name];
    imwrite(cropped,pth);
end

files = dir('../jpg/face_test/face/*.jpg');
num = size(files,1);

for i=1:num
    name = [files(i).folder '/' files(i).name];
    im = imread(name);
    cropped = im(40:end-20,40:end-30,:);
    cropped = imresize(cropped,[140 110]);
    pth = ['../jpg/cropped_face_test/face/' files(i).name];
    imwrite(cropped,pth);
end
