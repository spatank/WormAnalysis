function plateNames = getPlateNames(Paths)

% This function extracts the plate names using the paths

    plateNames = cell(size(Paths,1),1);

    for i = 1:size(Paths,1)
        % seperate the time from rest in path
        split = strsplit(Paths(i,:)); 
        % split = strsplit(Paths(1,:));
        C = strsplit(split{1,1},'\'); % {1,1} element contains plate name
        plateNames{i} = C{1,3}; % {1,3} element is plate name
    end
    
    % plateNames = unique(plateNames,'stable'); % prevents sorting

end