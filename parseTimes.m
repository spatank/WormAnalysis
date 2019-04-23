function [h, m, s] = parseTimes(Times)

% This function extracts the hour, minutes and seconds for all elements in
% a cell array of time stamps.

    h = cell(size(Times));
    m = cell(size(Times));
    s = cell(size(Times));
    
    for i = 1:numel(Times)
        out = char(regexp(Times{i},'[\d]+','match'));
        h{i} = out(1,:);
        m{i} = out(2,:);
        s{i} = out(3,:);
    end
    
    h = str2double(h);
    m = str2double(m);
    s = str2double(s);

end