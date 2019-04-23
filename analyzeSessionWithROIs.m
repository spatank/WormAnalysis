function analyzed = analyzeSessionWithROIs(sessionChangeIdx, blueLightIdx, ...
    paths, datePath, ROIs)

            fprintf('Date Path: %s.\n', datePath);
            % analysis file does not exist.
            numSessions = numel(sessionChangeIdx) - 1;
            % the last index in sessionChangeIdx is for ease of access, 
            % it helps determine the end of the penultimate session
            if numel(blueLightIdx) > numSessions
                fprintf('Returning: More Blue Light than Sessions\n');
                return;
                % if the blue light went off more times than there are 
                % session, then declare plate invalid and move on
            end
            numWells = max(max(ROIs));
            if numWells ~= 24
                msg = sprintf(['Autodetection of ROIs failed ' ...
                    'for images ' ...
                    'located in %s. Skipping the plate.'], ...
                    datePath);
                % potentially call email subroutine
                warning(msg);
                fprintf('Returning: ROI Read Fail\n');
                return;
            end
            for k = 1:numSessions
                begIdx = sessionChangeIdx(k);
                endIdx = sessionChangeIdx(k+1) - 1;
                % blueLightIdx = find(allLogs(i).parsed(j).sortIdx == ...
                %     allLogs(i).parsed(j).blueLightIdx(k));
                blueLightIdxSess = blueLightIdx(k);
                jump = 12; 
                % images are taken at 5 s intervals, differences are 
                % evaluated between images that are 60 s apart, i.e. 12 
                % index jumps
                numWells = max(max(ROIs));
                
                % pre-blue light
                lastValidPre = (blueLightIdxSess - 1) - jump;
                % activityPre = zeros(lastValidPre,numWells);
                activityPre = [];
                for l = begIdx:lastValidPre
                    img1Path = strtrim(paths(l,:));
                    img1 = imread(img1Path);
                    im2Idx = l+jump;
                    if im2Idx >= blueLightIdxSess
                        msg = sprintf(['Not enough pre-blue light ' ...
                            'images to compute pixel differences ' ...
                            'in Session %d.' ...
                            'Skipping to the next session/plate.'], ...
                            k);
                        warning(msg);
                        break;
                    end
                    img2Path = strtrim(paths(l+jump,:));
                    img2 = imread(img2Path);
                    activityPre(end+1,:) = computeActivity(img1,img2,ROIs);
                end
                
                % post-blue light
                lastValidPost = endIdx - jump;
                % activityPost = zeros(lastValidPost,numWells);
                activityPost = [];
                for l = (blueLightIdxSess + 1):lastValidPost
                    img1Path = strtrim(paths(l,:));
                    img1 = imread(img1Path);
                    im2Idx = l+jump;
                    if im2Idx > endIdx
                        msg = sprintf(['Not enough post-blue light ' ...
                            'images to compute pixel differences ' ...
                            'in Session %d.' ...
                            'Skipping to the next session/plate.'], ...
                            k);
                        warning(msg);
                        break;
                    end
                    img2Path = strtrim(paths(im2Idx,:));
                    img2 = imread(img2Path);
                    activityPost(end+1,:) = computeActivity(img1,img2,ROIs);
                end
                analyzed(k).pre = activityPre;
                analyzed(k).post = activityPost;
            end
end