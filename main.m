function main()

    p = uigetdir('*.*', 'Select path containing logs.');
    allLogs = process_logs(p); % all logs must return empty if none are found

    % make sure logs were found
    if isempty(allLogs)
        err = errordlg(sprintf('No logs were found in directory:%s',p),...
            'No logs found.');
        return;
    end

    prompt = ['Please type the letter identifying the root folder.' ...
        ' (just the letter)'];
    rootLetter = inputdlg(prompt);

    numLogs = numel(allLogs); % how many log files in all

    for i = 1:numLogs
        numPlates = numel(allLogs(i).parsed);
        logName = allLogs(i).filename; % the name of the log
        string = sprintf('\nWorking with Log: %s.\n\n', logName);
        errorWrite(string);
        for j = 1:numPlates
            allLogs(i).parsed(j).paths(:,1) = rootLetter{1,1};
            allLogs(i).parsed(j).datePath(:,1) = rootLetter{1,1};
            datePath = allLogs(i).parsed(j).datePath;
            if exist(datePath,'dir')
                cd(datePath);
            else
                string = sprintf('\nFolder %s does not exist.\n', datePath);
                errorWrite(string);
                % fprintf('%s',string);
                continue;
            end
            testPath = fullfile(datePath,'analyzed.mat');
            if exist(testPath,'file')
                % analysis file exists.
                string = sprintf('Analysis exists for %s.\n', datePath);
                errorWrite(string);
                continue; 
                % go to next plate
            else
                string = sprintf('\nCommencing analysis of folder %s.\n',...
                    datePath);
                errorWrite(string);
                sessionChangeIdx = allLogs(i).parsed(j).sessionChangeIdx;
                [~, blueLightIdx] = ismember(allLogs(i).parsed(j).blueLightIdx, ...
                    allLogs(i).parsed(j).sortIdx);
                paths = allLogs(i).parsed(j).paths;
                analyzed = analyzeSession(sessionChangeIdx, blueLightIdx, ...
                    paths);
            end
            savefile = [datePath '\analyzed.mat'];
            save(savefile,'analyzed');
        end 
    end


end