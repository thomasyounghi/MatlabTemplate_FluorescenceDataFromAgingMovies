%We already have a folder containing tifs in which the interior of each
%trap has been identified.

%We also have a csv file containing our locations of interest - the frame
%of the movie and the trap within that movie.  For every trap in the csv
%file we'd like to allow the user to generate a more detailed mask for the
%cell.  Currently the rois in the mask are smaller than the cells of
%interest.  Since our feature foci can occur anywhere in the cell we need
%to be able to set our search region to be larger than the minimal rois.

%In the course of the script we should be able to open all of the xy
%framees containing cells in our csv file.  It should only highlight those
%cells that were in the file.  

%For a particular xy frame, a gui should pop up containing the xy frame
%at which we want to highlight the region of interest. The gui should have
%2 modes: one that allows me to draw a boundary around my cells of
%interest, and also an automatic detection mode. It should allow me to
%finalize my choice of an roi boundary for each of the cells of interest
%and to save a tif file containing a mask corresponding to my drawn roi
%boundary.  


%Step 1 detect traps.
addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis')

%For detecting traps/generating masks/extracting fluorescence
prefix = './10_10_17_t0tifs/10_10_17_yty139a_10ugdoxoldpgXY';
midfix = '';
suffix = 'T001C1.tif';
outputprefix = './masks/';
load('roipolygon.mat');
%roipolygon = double([34,24;30,25;28,31;30,34;34,34;39,34;39,30;38,27;34,24])


%For getting a local background mask/extracting fluorescence
maskprefix = './masks/mask_xy';
se = strel('square',45);
xylocs = [2:30,32:60];

roicoordfirst = generatemasks(2:30,20,2,roipolygon,0.7,prefix,midfix,suffix,outputprefix);
roicoordfirst = generatemasks([18,28],18,28,roipolygon,0.8,prefix,midfix,suffix,outputprefix);
roicoordsecond = generatemasks(32:60,33,58,roipolygon,0.8,prefix,midfix,suffix,outputprefix);
roicoordsecond = generatemasks(31,31,31,roipolygon,0.8,prefix,midfix,suffix,outputprefix);


%Based on the locations in the budding time info file, open the respective
%locations and highlight the regions corresponding to the locations of
%interest
fid = fopen('10_10_17_revised.csv')
C = textscan(fid,'%d %d %*[^\n]','Delimiter',',','HeaderLines',1)

uniquelocs = unique(C{1});
for (i = 1:length(uniquelocs))
    currentxy = uniquelocs(i);
    
    maskfn = strcat('./masks/mask_xy',int2str(currentxy),'.tif')
    mask = imread(maskfn);
    [l,num]= bwlabel(mask);
    D = regionprops(l,'Centroid');
    centroids = cat(1, D.Centroid);
    centroids = ceil(centroids);
    
    
    
    xystr = num2strwithzeros(currentxy)
    pgfn = strcat('./maxiptifs/10_10_17_yty139a_10ugdox_oldcfpzstacks20sola201mult-maxipt1xy',xystr,'c1.tif')
    pgim = imread(pgfn);
    orderedindices = orderrois(centroids);
    centroidsro = centroids(orderedindices,:);
    traps = C{2}(C{1} == currentxy);
    
    labeled = insertText(pgim*50,centroidsro(traps,:),traps);
    figure()
    imshow(labeled);
    %Allow the user to outline each cell of interest in the phase g image
    %and save a mask
    
    
    
    
    
end


