function dateString = getDateString()

    fid = fopen('params_PlateTray_CurrentState.txt');
    tline = fgetl(fid);
    tlines = cell(0,1);
    while ischar(tline)
        tlines{end+1,1} = tline;
        tline = fgetl(fid);
    end
    fclose(fid);

    path = tlines{end};

    C = strsplit(path,'\'); % splits by \ character, 4th element is date
    dateString = C{4};


end

