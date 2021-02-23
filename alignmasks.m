addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis')

%For detecting traps/generating masks/extracting fluorescence
prefix = './tifs/8_30_18_yty146a_yty147a_doxoldpart2_every3rd_xy';
midfix = ' - Alignedt01';
suffix = 'xy1c1.tif';
outputprefix = './masks/';
load('roipolygon.mat');
%roipolygon = double([34,24;30,25;28,31;30,34;34,34;39,34;39,30;38,27;34,24])


%For getting a local background mask/extracting fluorescence
maskprefix = './masks/mask_xy';
se = strel('square',45);
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



