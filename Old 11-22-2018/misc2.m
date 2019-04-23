i = 21; j = 5;
sessionChangeIdx = allLogs(i).parsed(j).sessionChangeIdx;
[boolVec, blueLightIdx] = ismember(allLogs(i).parsed(j).blueLightIdx, ...
    allLogs(i).parsed(j).sortIdx);
paths = allLogs(i).parsed(j).paths;
means = allLogs(i).parsed(j).mean;
std = allLogs(i).parsed(j).std;

% %% Plots
% 
% cd G:
% load('AretaEVPlateDay1.mat');
% % load('AretaM1A4M1A4Day1.mat');
% 
% % pre-blue light: session 1
% vec1 = mean(analyzed(1).pre,2);
% % post-blue light: session 1
% vec2 = mean(analyzed(1).post,2);
% combined = [vec1 ; vec2];
% 
% figure;
% plot(1:numel(combined), combined);
% title('EV Plate: November 10');
% % title('M1A4M1A4 Plate: November 13');
% xlabel('Frames');
% ylabel('Activity');
% 
% clc; clear;
% 
% load('AretaEVPlateDay2.mat');
% % load('AretaM1A4M1A4Day2.mat');
% 
% % pre-blue light: session 1
% vec1 = mean(analyzed(1).pre,2);
% % post-blue light: session 1
% vec2 = mean(analyzed(1).post,2);
% combined = [vec1 ; vec2];
% 
% figure;
% plot(1:numel(combined), combined);
% title('EV Plate: November 11');
% % title('M1A4M1A4 Plate: November 14');
% xlabel('Frames');
% ylabel('Activity');
