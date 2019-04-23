function [isValid] = validRoot(paths)
% validRoot checks if all files addressed in paths exist
    vec = zeros(size(paths,1));
    for i = 1:size(paths,1)
        filePath = paths(i,:);
        valid = exist(filePath,'file');
        vec(i) = valid;
    end
    if sum(vec ~= 0) ~= size(paths,1)
        isValid = false;
    else
        isValid = true;
    end
end

