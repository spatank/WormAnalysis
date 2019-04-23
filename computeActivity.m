function [activity] = computeActivity(img1,img2,ROIs)
% computeActivity This function computes the pixel difference between two 
% images at the locations specified by the masks in the ROI Image

    activityThresh = 0.25;
    x = -5:5;
    y = x;
    [xx, yy] = meshgrid(x,y);
    gs = 1;
    gau = exp(-sqrt(xx.^2+yy.^2)/gs^2);    
    numWells = max(max(ROIs));
    activity = zeros(1,numWells);
    img1 = double(img1);
    img2 = double(img2);
    for i = 1:numWells
        pixelDiff = abs(img2.*(ROIs == i) - img1.*(ROIs == i));
        normalizedPD = pixelDiff./(img1+img2);
        activityTemp = conv2(normalizedPD,gau,'same');
        activityTemp = activityTemp > activityThresh;
        activity(i) = sum(sum(activityTemp)); 
    end
end

