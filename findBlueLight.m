function blueLightTimes = findBlueLight(Paths, LJStatus)

% This function extracts the times at which blue light images were taken
% using the arguments supplied. 
    
    blueLightIdx = false(size(LJStatus,1),1);

    for i = 1:size(LJStatus,1)
        string = LJStatus(i,:);
        % blueLightIdx(i) = contains(string,'blue');
        % contains() was introduced with 2016a. use strfind for legacy
        blueLightIdx(i) = ~isempty(strfind(string,'blue'));
    end
    
    blueLightPaths = Paths(blueLightIdx,:);
    blueLightTimes = cell(size(blueLightPaths,1),1);

    for i = 1:size(blueLightPaths,1)
        % seperate the time from rest in path
        split = strsplit(blueLightPaths(i,:)); 
        % seperate the numbers corresponding to time
        out = char(regexp(split{2},'[\d]+','match'));
        timeBlueLight = sprintf('%s-%s-%s',out(1,:),out(2,:),out(3,:));
        blueLightTimes{i} = timeBlueLight;
    end

    blueLightTimes = unique(blueLightTimes,'stable'); 
    % prevent sorting using 'stable'

end