function allVals = extractVals(String)

% This function extracts the numeric values from a string

    % Paths = cellS{2,1};
    allVals = cell(size(String,1),1);

    for i = 1:size(String,1)
        % seperate numbers from chars
        string = String(i,:);
        out = str2double(regexp(string,'[\d.]+','match'));
        allVals{i} = out;
    end

end
