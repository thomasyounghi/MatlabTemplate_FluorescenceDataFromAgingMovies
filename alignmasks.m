%For each xy location, aligns the first phaseg image for part1 of the aging movie to the first phaseg image for part2 of the aging movie.aging
%Applies the transformation that aligns the two images to the corresponding binary mask for the same xy location (saved in './masks/mask_xy__.tif')
%The aligned masks are saved as './masks/mask_xy__.tif')
%The aligned masks are also overlaid onto the first phaseg image of part 2 of the aging movie for visual inspection. They are saved as './masks/pgoverlaidal_xy__.tif'

addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis')

%For detecting traps/generating masks/extracting fluorescence
prefix = './tifs/8_30_18_yty146a_yty147a_doxoldpart2_every3rd_xy';
midfix = ' - Alignedt01';
suffix = 'xy1c1.tif';
outputprefix = './masks/';


%For getting a local background mask/extracting fluorescence
maskprefix = './masks/mask_xy';
se = strel('square',45);

%manually set the xy locations to consider to avoid locations lacking cells or with too many cells
xylocs = [1:38,40:73];

prefix1 = './phasegt1/8_30_18_yty146a_yty147a_doxoldxy'
suffix1 = 't1c1.tif'




optimizer = registration.optimizer.RegularStepGradientDescent();
metric = registration.metric.MeanSquares();
[optimizer, metric] = imregconfig('multimodal')
for i = xylocs
    xystr = num2strwithzeros(i);
    pg = imread(strcat(prefix,xystr,midfix,suffix));
    pg = im2double(pg);
    
    mask = imread(strcat(maskprefix,num2str(i),'.tif'));
   
    figure()
    subplot(1,3,1)
    overlaid = ~mask.*pg/mean(mean(pg));
    imshow(overlaid)

    
    pgfirst = imread(strcat(prefix1,xystr,suffix1));
    pgfirst = im2double(pgfirst);
    subplot(1,3,2)
    overlaid2 = ~mask.*pgfirst/mean(mean(pgfirst));
    imshow(overlaid2)
  
    
    tform = imregtform(pgfirst,pg,'translation',optimizer,metric);
    tform.T
    maskreg = imwarp(mask,tform,'OutputView',imref2d(size(pg)));
    maskfn = strcat('./masks/maskal_xy',num2str(i),'.tif');
    imwrite(maskreg,maskfn);
    overlaid3 = ~maskreg.*pg/mean(mean(pg));
    pgoverlaidfn = strcat('./masks/pgoverlaidal_xy',num2str(i),'.tif');
    imwrite(overlaid3,pgoverlaidfn);
    subplot(1,3,3);
    imshow(overlaid3);
    
end



