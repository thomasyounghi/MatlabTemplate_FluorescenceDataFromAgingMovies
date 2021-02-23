%Given a mask and image, applies the mask to the image and finds the the
%3x3 set of pixels that has the maximum total fluorescence value
%returns the total fluorescence of this square of pixels for each of the 
%rois in the mask

%It only makes sense to search 3x3 regions that are containined inside our
%regions of interest (trapped cells that we analyzed).  

%If we searched the entire image, a lot of the bright spots we identify
%will not be within our regions of interest.  Then we'd have to go through
%all of them and ask whether they lie within our regions of interest.  

%We can already get the pixel values for each roi pretty easily. Suppose we
%have a transformed image in which the pixel value is the sum of that pixel
%value and neighboring pixel values.  

%If a foci is present, it would correspond to a small set of connected
%pixels that is very bright.
%It wouldn't be a real foci if most of the cell was already bright to begin
%with.  
%Need to subtract background first.


%1)  Transform the image so that each pixel contains the sum of pixel
%values nearby.  The transformed image should be the same size as the
%original image and the mask.  (Before any of this, the background should
%be subtracted)

%2) Apply the mask to the image and use region props to get the
%transformed pixel list for each region of interest.  THe brightest pixel
%in the list is a candidate foci.  

%To assess whether we actually have a foci, the brightest 3x3 region should
%contain a large portion of the fluorescence in the cell. >=25% of the
%total pixel sum

%If we have a diffuse nuclear distribution of Rad52- the fluorescence
%should be spread out over a greater area.


function means = getcandidatefoci(mask,image)
    %ge
    s = regionprops(mask,image,'MeanIntensity');
    
    
    
    
    means = cell2mat(struct2cell(s));
end