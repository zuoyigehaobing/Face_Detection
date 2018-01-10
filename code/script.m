%% set up environment
close all;
addpath(genpath(pwd));
train_face_detector = false;
train_logo_detector = false;
train_gender_classifier = false;

%% Shot Detection

% set up input variable
video = {'Clowns','Lego','Parliament'};
tolerance = 0.4;
videoname = video{3};

% check the manually marked file
check_file = sprintf('../data/boundary/%s.,at',videoname);
if ~exist(check_file,'file')
    manually_shot;
end

% HIST Approach
thresh = 6;
shot = shotDetection_HIST(videoname,tolerance,thresh);

% SAD Approach
thresh = 10;
shotDetection_SAD(videoname,tolerance,thresh);


%% Logo Detection Classifier
cellSize = 20;
resolution_rate = 5;
model_size = round([48 95] * resolution_rate/5);

if ~exist('../data/model/logo_detector.mat','file') || train_logo_detector
    % Train Linear SVM binary classifier
    TrainDataDir = '../data/jpg/logo_train';
    logo_train(TrainDataDir,cellSize,model_size);

    % Test the classifier
    TestDataDir = '../data/jpg/logo_test';
    logo_test(TestDataDir,cellSize,model_size);
end



% Hog Parameters
size_set = [(1:10:30) * 0.01  (30:15:90)*0.015];
stride = 10;
thresh = 0.6;
clean = 1;
bagged_param = [cellSize stride thresh clean];

% Demo Detector
img = imread('../images/search.jpg');
logos = HoG_Detector_logo(img,model_size,size_set,bagged_param);








%% FaceDetection

cellSize = 20;
resolution_rate = 5;
model_size = [14 11] * resolution_rate;


if ~exist('../data/model/face_detector.mat','file') || train_face_detector
    % Train Linear SVM binary classifier
    TrainDataDir = '../data/jpg/cropped_face_train';
    face_detector_train(TrainDataDir,cellSize,model_size);

    % Test the classifier
    TestDataDir = '../data/jpg/cropped_face_test';
    face_detector_test(TestDataDir,cellSize,model_size);
end

% Hog Parameters
size_set = [(1:3:30) * 0.01  (30:15:90)*0.015];
stride = 10;
thresh = 0.6;
clean = 1;
bagged_param = [cellSize stride thresh clean];

% Detector Demo
img = imread('../images/trial.jpg');
faces = HoG_Detector_face(img,model_size,size_set,bagged_param);

% demo
size_set = [(1:3:30) * 0.01  (30:15:70)*0.015];
stride = 10;
thresh = 0.6;
clean = 1;
bagged_param = [cellSize stride thresh clean];
img = imread('../images/test.jpg');
faces = HoG_Detector_face(img,model_size,size_set,bagged_param);



%% Gender Classifier
% if ~exist('../data/model/classifier.mat','file') || train_gender_classifier
%     resolution_rate = 5;
%     gender_model_size = [14 11] * resolution_rate;
%     gender_Cell = [10 10];
%     
%     mode = 'poly'; % 'RBF' , 'poly'
%     
%     % train the classifier
%     train_dir = fullfile('../data/jpg/','train');
%     gender_train(train_dir,gender_model_size,gender_Cell,mode);
%     
%     % test the classifier
%     test_dir = fullfile('../data/jpg/','test');
%     gender_test(train_dir,gender_model_size,gender_Cell);
%     
% end



%% video with face tracking and gender classifier
% process_video(videoname,model_size,size_set,bagged_param,shot,0);

