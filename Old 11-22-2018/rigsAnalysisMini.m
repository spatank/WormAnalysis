load('nov14.mat');
load('ROIs.mat');
datePath = 'G:\\AllRigs\cam0\2018-11-14';
sessionChangeIdx = nov14.sessionChangeIdx;
blueLightIdx = nov14.blueLightIdx;
paths = nov14.paths;
paths(:,1) = 'G';
tic;
analyzed = analyzeSessionWithROIs(sessionChangeIdx, blueLightIdx, ...
    paths, datePath, ROIs);
toc;