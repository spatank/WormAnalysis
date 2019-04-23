function [allLogs] = process_logs(p)

    % cd /Users/Shubhankar/Desktop/Lab/ActivityCode/SPP/WormWatcher/logs
    % cd F:\WormWatcherTest\logs
    cd(p);

    logFileStruct = dir('log_20*.*'); % find all logfiles

    % following loop appends headers to the logfile is none exist
    for j = 1:numel(logFileStruct)
        filename = logFileStruct(j).name;
        fid = fopen(filename);
        line1 = strsplit(fgetl(fid),';');
        fid = fclose(fid);
        string = sprintf('DateTime\tPath\tMean\tStd\tLJStatus\tAcqNote');
        test = strcmp(line1,string);
        if test == 0
            disp('Did this');
            prepend2file(string,filename);
        end
    end
    % cd .. % return to WormWatcher
    % cd /Users/Shubhankar/Desktop/Lab/ActivityCode/SPP/WormWatcher
    % cd C:\WormWatcherTest

    % Read the Logs

    % cd logs 
    % go to Logs Folder
    % cd /Users/Shubhankar/Desktop/Lab/ActivityCode/SPP/WormWatcher/logs
    % cd C:\WormWatcherTest\logs

    % logFile = logFileStruct(19).name;

    numLogs = numel(logFileStruct);

    for i = 1:numLogs

        logFile = logFileStruct(i).name;
        allLogs(i).filename = logFile;
        % fprintf('Filename = %s.\n', logFile); 
        S = tdfread(logFile);
        cellS = struct2cell(S);
        % {1,1} is unusable date and time
        % {2,1} is paths
        % {3,1} is means
        % {4,1} is standard deviations
        % {5,1} is LJ Status
        % {6,1} is Acquisition Note
        % cd .. % return to Wormwatcher
        % cd /Users/Shubhankar/Desktop/Lab/ActivityCode/SPP/WormWatcher
        % cd F:\WormWatcherTest
        
        Paths = cellS{2,1}; % all paths
        LJStatus = cellS{5,1}; % all LJ Status notes
        allMeans = cellS{3,1}; % all mean intensities
        allStds = cellS{4,1}; % all image std
        % saveTimes = extractTimes(Paths);
        blueLightTimes = findBlueLight(Paths, LJStatus);

        % sortrows helps collect users and similar plates together
        % [sortedPaths, idxPaths] = sortrows(cellS{2,1}); 
        [sortedPaths, sortedIndices] = sortrows(cellS{2,1});
        sortedTimes = extractTimes(sortedPaths);
        
        sortedMeans = allMeans(sortedIndices,:);
        sortedStds = allStds(sortedIndices,:);

        plateNamesAll = getPlateNames(sortedPaths);
        plateNames = unique(plateNamesAll,'stable');
        numPlates = numel(plateNames);

        cellArray = cell(8,numPlates); 

        % each row of the cell array represents a plate and will end up becoming a 
        % field in the final parsed logfile output, the fields have the 
        % following meaning:
        % 1: indices of the individual units in the sorted logfile, a unit here 
        %   implies a series of tab seperated values corresponding to a single user
        %   and a single plate.
        % 2: 'times' corresponding to the user and the plate, these are useful to
        %   determine when one imaging session ended and the next began.
        % 3: the index of the beginning of a new image session, note that the index
        %   corresponds not to the end of the last session, but to the beginning of
        %   the new session
        % 4: indices at which the blue light is turned on
        % 5: full path to the images, used eventually to obtain pixel differences
        % 6: path to the date folder, eventually used to check if the analysis
        %   file already exists there

        for j = 1:numPlates
            % get indices of plate i from a sorted list of all plates
            cellArray{1,j} = find(strcmp(plateNamesAll, plateNames(j)));
            % get the saving 'times' for the plate by indexing in sortedTimes using
            % the plate's indices
            cellArray{2,j} = sortedTimes(cellArray{1,j});
            % get the hour, minute and second for each save time for the plate
            % [h, m, s] = parseTimes(cellArray{2,j});
            [h, ~, ~] = parseTimes(cellArray{2,j});
            % compute difference in time between successive saves, if difference 
            % greater than or equal to 2 hours, conclude that the session changed.
            % find locations of such changes and add 1 because looking for start of
            % new session
            % cellArray{3,j} = find(abs(diff(h)) >= 2) + 1;
            cellArray{3,j} = find(abs(diff(h)) >= 1) + 1;
            cellArray{3,j} = [1; cellArray{3,j}; numel(cellArray{1,j})+1]; 
            % in all 'times' for this plate, find if any indices correspond 
            % to the turning on of blue light, and then get these times from all
            % currrent plate save times 
            % [lightTime,iTimes,iBlueTimes] = intersect(cellArray{2,j},blueLightTimes);
            [~,iTimes,~] = intersect(cellArray{2,j},blueLightTimes);
            cellArray{4,j} = cellArray{1,j}(iTimes);
            % get all paths for the plate from the grouped (sorted) paths
            cellArray{5,j} = sortedPaths(cellArray{1,j},:);
            cellArray{6,j} = extractDatePath(sortedPaths(cellArray{1,j},:));
            % get mean and std values
            MeanString = sortedMeans(cellArray{1,j},:);
            StdString = sortedStds(cellArray{1,j},:); 
            cellArray{7,j} = extractVals(MeanString);
            cellArray{8,j} = extractVals(StdString);
        end

        % to make data access and visualization simpler, the cell array of parsed
        % logfile information is converted to a struct with the following fields
        fields = {'sortIdx','time','sessionChangeIdx','blueLightIdx','paths',...
            'datePath','mean','std'};
        parsedStruct = cell2struct(cellArray, fields, 1);
        allLogs(i).parsed = parsedStruct;
        % cd logs
        % cd /Users/Shubhankar/Desktop/Lab/ActivityCode/SPP/WormWatcher/logs
        % cd F:\WormWatcherTest\logs
        
    end

    % cd .. % return to WormWatcher
    % cd /Users/Shubhankar/Desktop/Lab/ActivityCode/SPP/WormWatcher
    % cd F:\WormWatcherTest
   

end