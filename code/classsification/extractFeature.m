function feature = extractFeature(dir)
%EXTRACTFEATURE Summary of this function goes here
%   Detailed explanation goes here
img = imread(dir);
cellSize = [10 10];
img = rgb2gray(img);
Hog = extractHOGFeatures(img, 'CellSize', cellSize);
Lbp = extractLBPFeatures(img);

feature = [Hog Lbp];
end

