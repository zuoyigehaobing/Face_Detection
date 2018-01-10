%% clown.mp4
collect = [    0.0 3.3 6.2 10.7;
              16.1 18.2 22.3 26.9;
              30.2 31.7 36.1 37.7;
              40.1 41.9 46.5 50.2;
              58.2 60.0 62.5 63.8;
              64.7 67.3 70.0 72.2;
              81.1 86.5 88.6 90.8;
              99.5 103.7 107.4 111.7;
              115.7 118.3 120.6 123.3];
shot = collect(:);
filename = '../data/boundary/Clowns.mat';
save(filename,'shot');

%% Parliament.mp4
collect = [0.0 19.5 26.3];
shot = collect(:);
filename = '../data/boundary/Parliament.mat';
save(filename,'shot');


%% Lego.mp4
collect = [0.0 4.93 5.53 7.6 25.8 30.2 32.4 36.1 44.6 47.4 49.8 54.4 57.5 60.5 63.9 67.7 71.6 76.0 80.7 86.6 97.7 105.1 107.1 108.7 111.1 113.9 115.9 119.0 126.8 129.7];
shot = collect(:);
filename = '../data/boundary/Lego.mat';
save(filename,'shot');