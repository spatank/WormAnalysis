function dateFolderPath = extractDatePath(Paths)

% This function extracts the path to the date folder from the full path
% supplied. 

    dateFolderPath = cell(size(Paths,1),1);

    for i = 1:size(Paths,1)
        % seperate the path using '\' as delimiter
        split = strsplit(Paths(1,:),'\');
        % merge the first 4 split components (they combine to become the
        % date path)
        dateFolderPath{i} = strjoin(split(1:4),'\');
    end
    
    dateFolderPath = unique(dateFolderPath);
    dateFolderPath = char(dateFolderPath);
    
end

