function meanintensities = roimeanatdistance(centermask,notbgmask,image,dtocenter,dtonotbg,roicoord)
    Dcenter = bwdist(centermask);
    Dnotbg = bwdist(notbgmask);
    
    centerlocus = (Dcenter>dtocenter-1) .* (Dcenter <= dtocenter+1);
%     imshow(imadjust(im2double(image).* centerlocus))

    notbglocus = (Dnotbg > dtonotbg);
    
%     figure()
%     imshow(imadjust(im2double(image).*~centerlocus));
%     green = cat(3, zeros(size(notbgmask)),ones(size(notbgmask)),zeros(size(notbgmask))); 
%     hold on;
%     h = imshow(green);
%     set(h,'AlphaData',notbglocus*0.25);
%     hold off;


    %We only place our test roi at points that are greater than distance
    %dtonotbg from our notbg mask, and within 1 of dtocenter from
    %centermask
    locus = centerlocus & notbglocus;
    
    %For each point in the locus, we place and roi at that point and
    %compute the mean yfp.
    locuspoints = regionprops(locus,'PixelList');
    imshow(centerlocus | notbglocus);
    
    
    if size(locuspoints,1) > 0 
        %Now we place the roi at these various points and find the mean
        %intensity.
        locuspoints = locuspoints.PixelList;
        meanintensities = NaN(floor(size(locuspoints,1)/3),1);
        numvertices = size(roicoord,1);
        m  = size(image,1);
        n = size(image,2);
        k = 3;
        for i = 1:floor(size(locuspoints,1)/k);
    %         figure()
            polycoord = roicoord + repmat(locuspoints(k*i,:),numvertices,1);
            bw = poly2mask(polycoord(:,1),polycoord(:,2),m,n);

    %         imshow(imadjust(im2double(image)).*~locus.*~bw);

            meanint = regionprops(bw,image,'MeanIntensity');
            meanintensities(i) = meanint.MeanIntensity;
        end
    else
       meanintensities = []; 
    end

    
    
end
