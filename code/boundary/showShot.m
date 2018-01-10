function showShot(filename,shotTime)
    v = VideoReader(filename);
    gap = 1/v.FrameRate;
    v.CurrentTime = shotTime-gap;
    f1 = readFrame(v);
    readFrame(v);
    f2 = readFrame(v);
    blank = uint8(zeros(size(f1,1),100,3));
    f = [f1 blank f2];
    figure;image(f);
    figure;imhist(f1);
    figure;imhist(f2);
end