function ROIs = detectROIs(img)

    thresholdValue = mean(mean(img));
    binaryImage = img < thresholdValue;
    labeledImage = bwlabeln(binaryImage);
    ROIData = regionprops(labeledImage, img, 'all');
    ROIAreas = [ROIData.Area];
    [~, idx] = sort(ROIAreas,'descend');
    deleteROIs = idx(30:end);
    binaryImage(ismember(labeledImage,deleteROIs)) = 0; % set smaller ROIs to 0
    labeledImage2 = bwlabel(binaryImage); % regenerate ROIS as matrix of 1s
    ROIs = bwlabeln(imfill(labeledImage2,'holes'));
    ROIDataNew = regionprops(ROIs, img, 'all');
    ROIAreasNew = [ROIDataNew.Area];
    [sortAreasNew, idxNew] = sort(ROIAreasNew,'descend');

    if sortAreasNew(2) < (sortAreasNew(1) - 0.10*sortAreasNew(1))
        ROIs(ROIs == idxNew(1)) = 0; % set largest ROI to 0
        sortAreasNew(1) = [];
        idxNew(1) = [];
    end

    idxDelete = sortAreasNew < (mean(sortAreasNew(1:10)) - 0.05*mean(sortAreasNew(1:10)));
    deleteROIsNew = idxNew(idxDelete);
    ROIs(ismember(ROIs,deleteROIsNew)) = 0; % set smaller ROIs to 0
    ROIs = bwlabeln(ROIs);
    
    % coloredROIs = label2rgb(ROIs,'hsv','k','shuffle');
    % figure; imshow(coloredROIs);
    
end

