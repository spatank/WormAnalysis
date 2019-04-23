load('nov13.mat');

datePath = 'E:\\AllRigs\cam0\2018-11-13';
sessionChangeIdx = nov13.sessionChangeIdx;
blueLightIdx = nov13.blueLightIdx;
paths = nov13.paths;
paths(:,1) = 'G';
analyzed = analyzeSession(sessionChangeIdx, blueLightIdx, ...
    paths, datePath);