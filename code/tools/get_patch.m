videoname = '../videos/generate2.mp4';
v = VideoReader(videoname);

H = v.Height;
W = v.Width;

pth = '../jpg/face_test/non_faces/';
k = 1;


while hasFrame(v)
    vidFrame = readFrame(v);
    h = randi([1 H-200]);
    w = randi([1 W-200]);
    box = vidFrame(h:h+199,w:w+199,:);
    imagesc(box);
    disp(size(box));
    v.CurrentTime = v.CurrentTime + 5;
    name = sprintf('%i.jpg',k);
    k = k + 1;
    filename = [pth name];
    imwrite(box,filename);
    pause(0.4);
end
    