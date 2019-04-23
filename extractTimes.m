function allTimes = extractTimes(Paths)

% This function extracts the times at which images were taken
% using the argument supplied. 

    % Paths = cellS{2,1};
    allTimes = cell(size(Paths,1),1);

    for i = 1:size(Paths,1)
        % seperate the time from rest in path
        split = strsplit(Paths(i,:)); 
        % seperate the numbers corresponding to time
        out = char(regexp(split{2},'[\d]+','match'));
        saveTime = sprintf('%s-%s-%s',out(1,:),out(2,:),out(3,:));
        allTimes{i} = saveTime;
    end

    % allTimes = unique(allTimes,'stable'); % prevents sorting

end

