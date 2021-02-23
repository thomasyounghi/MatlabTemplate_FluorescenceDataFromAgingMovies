addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis')


%Detecting traps and generating masks corresponding to the region
%containing the trapped cell
prefix = './phasegt1/8_30_18_yty146a_yty147a_doxoldxy'
suffix = 't1c1.tif'
midfix = ''

outputprefix = './masks/';
load('roipolygon.mat');
%roipolygon = double([34,24;30,25;28,31;30,34;34,34;39,34;39,30;38,27;34,24])


%For getting a local background mask/extracting fluorescence
maskprefix = './masks/mask_xy';
se = strel('square',45);
xylocs = [1:38,40:73];


roicoordfirst = generatemasks(1:38,2,37,roipolygon,0.8,prefix,midfix,suffix,outputprefix,0.9);
roicoordfirst = generatemasks([26,27,30,31,32,38],26,27,roipolygon,0.95,prefix,midfix,suffix,outputprefix,0.9);
roicoordfirst = generatemasks([1,11],1,11,roipolygon,0.95,prefix,midfix,suffix,outputprefix,0.9);
roicoordfirst = generatemasks(1,1,1,roipolygon,0.8,prefix,midfix,suffix,outputprefix,0.9);
roicoordfirst = generatemasks(38,38,38,roipolygon,0.8,prefix,midfix,suffix,outputprefix,0.9);
roicoordfirst = generatemasks(23,23,23,roipolygon,0.8,prefix,midfix,suffix,outputprefix,0.9);


roicoordfirst = generatemasks(40:73,71,48,roipolygon,0.8,prefix,midfix,suffix,outputprefix,0.9);





%For detecting traps/generating masks/extracting fluorescence


%Generate a mask corresponding to a local region around each trap. This
%will be used to determine the local backgorund fluorescence
almaskprefix = './masks/maskal_xy';
prefix = './tifs/8_30_18_yty146a_yty147a_doxoldpart2_every3rd_xy';
midfix = ' - Alignedt';
suffix = 'xy1c1.tif';
%For extracting fluorescence
maxtime = 38;

%Generate a mask corresponding to a local region around each trap. This
%will be used to determine the local backgorund fluorescence
generatebgmask(xylocs,almaskprefix,se,prefix,midfix,suffix);


%Extracting fluorescence for individual cells and local background

yfprois = applymask(xylocs,almaskprefix,prefix,maxtime, 2,'YFPmeasurements.csv',@getroimeans);
rfprois = applymask(xylocs,almaskprefix,prefix,maxtime, 3,'RFPmeasurements.csv',@getroimeans);
yfpbgrois = applymask(xylocs,'./bgmasks/xy',prefix,maxtime, 2,'YFPmeasurements.csv',@getroiquantiles);
rfpbgrois = applymask(xylocs,'./bgmasks/xy',prefix,maxtime, 3,'YFPmeasurements.csv',@getroiquantiles);
figure()
subplot(2,2,1)
plot(yfprois')
title('yfprois');
subplot(2,2,2)
plot(rfprois')
title('rfpfois');
ylim([0 500]);
subplot(2,2,3)
plot(yfpbgrois')
title('yfpbg tenth percentile');
subplot(2,2,4)
plot(rfpbgrois')
title('rfpbg tenth percentile');
ylim([0 500]);
plot(yfprois' - yfpbgrois')
plot(rfprois' - rfpbgrois')
%save so we can compare to our old output
csvwrite('rfprois.csv',rfprois);
csvwrite('yfprois.csv',yfprois);
csvwrite('rfpbg10pctrois.csv',rfpbgrois);
csvwrite('yfpbg10pctrois.csv',yfpbgrois);
