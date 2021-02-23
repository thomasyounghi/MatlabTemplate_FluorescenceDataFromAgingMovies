addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis')

%prefix for files to open
prefix = './tifs/8_30_18_yty146a_yty147a_doxoldpart2_every3rd_xy';
midfix = ' - Alignedt';
c2suffix = 'xy1c2.tif';
c3suffix = 'xy1c3.tif';

%prefixes for the masks
notbgprefix = './manualbgmasks/notbg_t';
localrectprefix = './manualbgmasks/rect_t';
cellroiprefix = './masks/maskal_xy';

%Only extract bg for known cells
%This file specifies the cells for which the bg was determined
bgtable = csvread('aliveafterdoxadded_8_30_18yTY146oldover15.csv',1,0);
bgtable1 = csvread('aliveafterdoxadded_8_30_18yTY147oldover15.csv',1,0);
bgtable = [bgtable;bgtable1];


%outputfn
outputfn = 'manualbg_aliveafterdox_8_30_18_all.csv'

%times for which bg was measured.  
times = [1:38];



%Now loop through the each xy location and determine the cells that we set
%out to measure and the times that they were measured.
xys = unique(bgtable(:,1))
%xys = xys(xys<=25)



%Save the results as a file in which each row corresponds to a measurement,
%and there are columns for xy, trap, number of bg pixels, total pixels in
%the local rectangle, average c2 fluorescence, average c3 fluorescence.  6
%columns
%Number of rows is the number of traps x the number of time measurements
results = NaN(size(bgtable,1)*size(times,2),8)

currrow = 1;
for i = 1:size(xys,1)
    xy = xys(i,1);
    traps = bgtable(bgtable(:,1)==xy,2);
    firstobstime = bgtable(bgtable(:,1)==xy,3);
    lastobstime = bgtable(bgtable(:,1)==xy,4);
    
    cellroifilename = strcat(cellroiprefix,num2str(xy),'.tif');
    cellroi = imread(cellroifilename);
    
    %The centroids for all the traps in the roi mask
    D = regionprops(cellroi,'Centroid');
    centroids = cat(1, D.Centroid);
    orderedtrappos = centroids(orderrois(centroids),:);
    
    %The centroids for the local rectangular regions for which bg pixels
    %were observed
    localrectfilename = strcat(localrectprefix,'1','xy',num2str(xy),'.tif');
    localrect = imread(localrectfilename);
    localrectpos = regionprops(localrect,'Centroid');
    localrectpos = cat(1,localrectpos.Centroid);
    D = pdist2(localrectpos,orderedtrappos);
    [M, localrectlabel] = min(D,[],2);
    numrect = size(localrectlabel,1);
    xylabels = xy * ones(numrect,1)
    
    %Finding the area of each local rectangle
    rectareas = regionprops(localrect,'Area')
    rectareas = cat(1,rectareas.Area);
    
    for j = 1:size(times,2)
        t = times(j);
        
        %Open the files
        notbgfilename = strcat(notbgprefix,num2str(t),'xy',num2str(xy),'.tif');
        c2filename = strcat(prefix,num2strwithzeros(xy),midfix,num2strwithzeros(t),c2suffix);
        c3filename = strcat(prefix,num2strwithzeros(xy),midfix,num2strwithzeros(t),c3suffix);
        
        if exist(notbgfilename, 'file') == 2
            timelabel = t*ones(numrect,1);
            notbg = imread(notbgfilename);
            c2 = imread(c2filename);
            c3 = imread(c3filename);
        
            %Finding the number of background pixels, avg c3 bg, and avg c2 bg
            numbg = getlocaltotalbg(localrect,notbg,uint16(~notbg));
            c3totalbg = getlocaltotalbg(localrect,notbg,c3);
            c2totalbg = getlocaltotalbg(localrect,notbg,c2);
            c3avgbg = c3totalbg ./ numbg;
            c2avgbg = c2totalbg ./ numbg;

            %We don't care about the the times listed to the traps to look at
            %file.  Some of the saved measurements are not valid because the
            %traps weren't inspected - cells were marked as interefered with or
            %dead.
            results(currrow:(currrow+numrect-1),:) = [xylabels,localrectlabel,timelabel, rectareas,numbg,c2avgbg,c3avgbg,M];
            currrow = currrow + numrect;
        end
        
    end
end

results = results(~isnan(results(:,1)),:)
results = array2table(results,'VariableNames',{'xy','trap','time','numlocalpix','numbgpix','c2avgbgpix','c3avgbgpix','roitorectdist'})
writetable(results,outputfn);
hist(table2array(results(:,8)));
scatter(table2array(results(:,3)),table2array(results(:,7)))
scatter(table2array(results(:,3)),table2array(results(:,6)))

