clc; close all; clear;

cd /Users/Shubhankar/Desktop/Lab/'Activity Code'/SPP/WormWatcher

% Image collection is finished for the day, have WormWatcher call Analysis.
% Step 1: Check if data for the day is already analyzed. If not then, 
% read log to get all image times.
% Step 2: Read log to get all blue light times. Add a line to flag that the
% data for the day has now passed through Analysis so the log is not read
% tomorrow.
% Step 3: For every user for every plate for current date, seperate the
% images into two folders [Session 1, Session 2]
% At the same time, for every user for every plate for current data, for
% the two newly created folders, compute pixel difference.

%% Process the Log File for the Day

% this must happen inside WormWatcher Folder

filename = 'log_2018-10-05.txt';
S = tdfread(filename);
saveTimes = extractTimes(S);
blueLightTimes = findBlueLight(S);

%% Go to Right Date

%%%%% Go to external Hard Drive
cd /Volumes/'My Passport';

%%%%% Go to User 
% parentPath = '';
parentPath = 'SampleUser';
cd(parentPath);

%%%%% Go to Plate
% platePath = '';
platePath = 'C1_06C_1';
cd(platePath);

%%%%% Go to Folder for the Day
% datePath = ''
datePath = '2018-5-26';
cd(datePath);

%%%%% Go to Session


% for user
%   for plate
%       for day
%           for session
                % filename = '2018-05-26 (12-58-30).png';

                % img = imread(filename);
                % ROIs = detectROIs(img);

                % coloredROIs = label2rgb(ROIs,'hsv','k','shuffle');
                % figure; imshow(coloredROIs);
          % end
      % end
  % end
% end





