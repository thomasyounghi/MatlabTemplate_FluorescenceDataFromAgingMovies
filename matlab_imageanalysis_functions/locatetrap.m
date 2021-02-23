%This function takes an image of interest (represented as a matrix), 
%the image of trap to locate, and a threshold.  Returns a list containing
%the coordinates of the centroid of each identified region in which the
%match metric was below a given threshold

%There are two thresholds. One is for the input image before matching

function [centroids, matchstatistics] = locatetrap(image,template,ithresh,matchthresh,padl)
    timage = im2double(im2double(image)<ithresh);
    
    timagepadded = padarray(timage,[padl,padl]);
    timage = timagepadded;
    htm = vision.TemplateMatcher;
    set(htm,'OutputValue','Metric matrix');
    metmatt = step(htm,timage,template);
    
    
    %Plotting the output
    figure()
    subplot(1,3,1);
    imshow(timage);
    subplot(1,3,2);
    imshow(template);
    subplot(1,3,3);
    imshow(metmatt<matchthresh);
    
    
    %Merge adjacent pixels below matchthresh to one region. Return the
    %centroids of the regions
    [l,num]= bwlabel(metmatt<matchthresh);
    D = regionprops(l,'Centroid');
    centroids = cat(1, D.Centroid);
    
    %also output the mean match statistic for each region
    matchstatistics = cell2mat(struct2cell(regionprops(l,metmatt,{'MeanIntensity'})))

end
