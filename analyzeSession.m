function analyzed = analyzeSession(sessionChangeIdx, blueLightIdx, ...
    paths)

            analyzed = [];
            
            numSessions = numel(sessionChangeIdx) - 1;
            % the last index in sessionChangeIdx is for ease of access, 
            % it helps determine the end of the penultimate session
            
            for k = 1:numSessions
                
                begIdx = sessionChangeIdx(k);
                endIdx = sessionChangeIdx(k+1) - 1;
                string = sprintf('Session %d.\n',k);
                errorWrite(string);
                
                blue = (blueLightIdx > begIdx) & (blueLightIdx < endIdx);
                if sum(blue) > 1
                    string = sprintf(['More than one blue light image detected'...
                        ' in this session. Skipping session.\n']);
                    errorWrite(string);
                    continue;
                end
                
                blueLightIdxSess = blueLightIdx(blue);
                jump = 12; 
                
                    
                pref = 'C:\WormWatcher\SampleImages\for reference';
                fname_ref_mat = fullfile(pref,'Reference_Robot_24well.mat');
                ROIImgPath = strtrim(paths(endIdx-1,:));
                % the last image - 1 in the session is chosen because there
                % are instances from old data where a session may begin 
                % recording but the first few images are absent, the last
                % image - 1 in a session, however, is always present. The
                % last image is not chosen because sometimes the last image
                % is blank. Here's to hoping that last - 1 will never be
                % blank!
                if exist(ROIImgPath,'file')
                    [ROIs,~,~,~,~,~,score_reg] = ...
                        registerWellRoisToPlate(fname_ref_mat,ROIImgPath);
                else
                    string = sprintf(['Image %s does not exist. ' ...
                        'ROIs cannot be detected. This happens only ' ...
                        'when there are not enough images in a supposed ' ...
                        'session. Safe to skip to next session.\n'], ROIImgPath);
                    errorWrite(string);
                    continue;
                end
                numWells = max(max(ROIs));
                
                if score_reg < 0.55
                    string = sprintf(['Image registration score for %s'...
                        ' less than 0.55. Skipped analysis of Session %d.\n'], ROIImgPath,k);
                    errorWrite(string);
                    continue;
                end
            
                if numWells ~= 24
                    string = sprintf(['Failed to detect 24 wells. Skipped analysis'
                    ' of Session %d.\n'],k);
                    errorWrite(string);
                    fprintf('%s',string);
                    continue;
                end
                
                % pre-blue light
                
                lastValidPre = (blueLightIdxSess - 1) - jump;
                activityPre = [];
                for l = begIdx:lastValidPre
                    img1Path = strtrim(paths(l,:));
                    if exist(img1Path,'file')
                        img1 = imread(img1Path);
                    else
                        string = sprintf(['Image %s does not exist. ' ...
                            'Skipping the image and its would-be' ...
                            ' partner.\n'], img1Path);
                        errorWrite(string);
                        continue;
                    end
                    % for now ignore blank images
                    if mean(mean(img1)) < 2
                        string = sprintf(['Image at %s is blank. ' ...
                            'Skipping this pair of images for pixel ' ...
                            'difference computation.\n'], ...
                            img1Path);
                        errorWrite(string);
                        continue;
                    end
                    im2Idx = l+jump;
                    if im2Idx >= blueLightIdxSess
                        string = sprintf(['Not enough pre-blue light ' ...
                            'images to compute pixel differences ' ...
                            'in Session %d.' ...
                            'Skipping to the next session if there is one.\n'], ...
                            k);
                        errorWrite(string);
                        break;
                    end
                    img2Path = strtrim(paths(l+jump,:));
                    if exist(img2Path,'file')
                        img2 = imread(img2Path);
                    else
                        string = sprintf(['Image %s does not exist. ' ...
                            'Skipping the image and its would-be' ...
                            ' partner.\n'], img2Path);
                        errorWrite(string);
                        continue;
                    end
                    % for now ignore blank images
                    if mean(mean(img2)) < 2
                        string = sprintf(['Image at %s is blank. ' ...
                            'Skipping this pair of images for pixel ' ...
                            'difference computation.\n'], ...
                            img2Path);
                        errorWrite(string);
                        continue;
                    end
                    activityPre(end+1,:) = computeActivity(img1,img2,ROIs);
                end
                
                % post-blue light
                lastValidPost = endIdx - jump;
                activityPost = [];
                for l = (blueLightIdxSess + 1):lastValidPost
                    img1Path = strtrim(paths(l,:));
                    if exist(img1Path,'file')
                        img1 = imread(img1Path);
                    else
                        string = sprintf(['Image %s does not exist. ' ...
                            'Skipping the image and its would-be' ...
                            ' partner.\n'], img1Path);
                        errorWrite(string);
                        continue;
                    end
                    % for now ignore blank images
                    if mean(mean(img1)) < 2
                        string = sprintf(['Image at %s is blank. ' ...
                            'Skipping this pair of images for pixel ' ...
                            'difference computation.\n'], ...
                            img1Path);
                        errorWrite(string);
                        continue;
                    end
                    im2Idx = l+jump;
                    if im2Idx > endIdx          
                        string = sprintf(['Not enough post-blue light ' ...
                            'images to compute pixel differences ' ...
                            'in Session %d.' ...
                            'Skipping to the next session if there is one.\n'], ...
                            k);
                        errorWrite(string);
                        break;  
                    end
                    img2Path = strtrim(paths(im2Idx,:));
                    if exist(img2Path,'file')
                        img2 = imread(img2Path);
                    else
                        string = sprintf(['Image %s does not exist. ' ...
                            'Skipping the image and its would-be' ...
                            ' partner.\n'], img2Path);
                        errorWrite(string);
                        continue;
                    end
                    % for now ignore blank images
                    if mean(mean(img2)) < 2
                        string = sprintf(['Image at %s is blank. ' ...
                            'Skipping this pair of images for pixel ' ...
                            'difference computation.\n'], ...
                            img2Path);
                        errorWrite(string);
                        continue;  
                    end
                    activityPost(end+1,:) = computeActivity(img1,img2,ROIs);
                end
                analyzed(k).pre = activityPre;
                analyzed(k).post = activityPost;
            end
end