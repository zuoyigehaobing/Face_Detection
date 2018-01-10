function showView(videoname,viewTime)
    videofile = sprintf('../videos/%s.mp4',videoname);
    v = VideoReader(videofile);
    v.CurrentTime = viewTime;
    f = readFrame(v);
    figure;image(f);
end