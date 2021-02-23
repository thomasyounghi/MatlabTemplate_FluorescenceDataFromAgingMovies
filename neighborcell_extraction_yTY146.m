addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis');

neighborcoord = 'neighborcellcoord_8_30_18_yTY146a.mat';
trapfile = 'aliveafterdoxadded_8_30_18yTY146oldover15.csv';

traps = csvread(trapfile,1,0);
prefix = './tifs/8_30_18_yty146a_yty147a_doxoldpart2_every3rd_xy';
midfix = ' - Alignedt';
uppermaxtime = 25;

load(neighborcoord);
load('roipolygon.mat');
roicoord = double(roipolygon) - repmat(mean(roipolygon),size(roipolygon,1),1);


row = 1;
neighborresults = NaN(10000,8);
neighborresultsrow = 1;

bgresults = NaN(100000,6);
bgresultsrow = 1;


for row = 1:size(traps,1)
    xy = traps(row,1);
    trap = traps(row,2);
    maxtime = min(traps(row,4),uppermaxtime);
    localrect = imread(strcat('./manualbgmasks/rect_t',num2str(1),'xy',num2str(xy),'.tif'));
    roimask = imread(strcat('./masks/maskal_xy',num2str(xy),'.tif'));

    D = regionprops(roimask,'Centroid');
    centroids = cat(1, D.Centroid);
    orderedcentroids = orderrois(centroids);
    orderedtrappos = centroids(orderedcentroids,:);

    %Finding the positions
    localrectpos = regionprops(localrect,'Centroid');
    localrectpos = cat(1,localrectpos.Centroid);
    D = pdist2(localrectpos,orderedtrappos);
    [M, localrectlabel] = min(D,[],2);


    localrectcoord = regionprops(localrect,'BoundingBox');
    localrectcoord = cat(1,localrectcoord.BoundingBox);

    %Find the local rect corresponding to the trap of interest
    currect = localrectcoord(localrectlabel==trap,:);



    for t = 1:maxtime
        yfp = imread(strcat(prefix,num2strwithzeros(xy),midfix,num2strwithzeros(t),'xy1c2.tif'));
        rfp = imread(strcat(prefix,num2strwithzeros(xy),midfix,num2strwithzeros(t),'xy1c3.tif'));
        notbgfn = strcat('./manualbgmasks/notbg_t',num2str(t),'xy',num2str(xy),'.tif');
        if exist(notbgfn,'file') == 0 
            strcat(notbgfn,' does not exist')
            continue
        end
            
            
        notbg = imread(notbgfn);


        nearbycoord = nearbypoly{row,t};

        if size(nearbycoord,1) > 0 
          for j = 1:size(nearbycoord,2)
                currnearby = nearbycoord{1,j};
                neighbormask = poly2mask(currnearby(:,1),currnearby(:,2),512,512);


                yfpmean = regionprops(neighbormask,yfp,'MeanIntensity');
                yfpmean = yfpmean.MeanIntensity;
                rfpmean = regionprops(neighbormask,rfp,'MeanIntensity');
                rfpmean = rfpmean.MeanIntensity;
                area = regionprops(neighbormask,'Area');
                area = area.Area;
             
                %Get a mask corresponding the draw roipolygon
                D = bwdist(neighbormask);
                roicenter = ceil(orderedtrappos(trap,:));
                roitoneighdist = D(roicenter(2),roicenter(1));
                
                %Temporary put this here to figure out a problem. 4/9/17
%                 imshow(notbg);
%                 impoly(
%                 if roitoneighdist>50
%                    break 
%                 end
                
                %Saving the neighbor data
                neighborresults(neighborresultsrow,:) = [xy,trap,t,j,yfpmean,rfpmean,area,roitoneighdist]
                neighborresultsrow = neighborresultsrow+1;

                %Cropping to find the nearby test bgs
                yfpcrop = imcrop(yfp,currect);
                rfpcrop = imcrop(rfp,currect);
                neighborcrop = imcrop(neighbormask,currect);
                notbgcrop = imcrop(notbg,currect);

                imshow(neighborcrop)
                yfpbgs = roimeanatdistance(neighborcrop,notbgcrop,yfpcrop,roitoneighdist,6,roicoord);
                rfpbgs = roimeanatdistance(neighborcrop,notbgcrop,rfpcrop,roitoneighdist,6,roicoord);
                numbgs = size(yfpbgs,1);
                if numbgs > 0 
                   bgresults(bgresultsrow:(bgresultsrow+numbgs-1),:) = [repmat([xy,trap,t,j],numbgs,1), yfpbgs,rfpbgs];
                   bgresultsrow = bgresultsrow+numbgs;
                end

            end
        end
    end
end
        
bgresults(isnan(bgresults(:,1)),:) = []
neighborresults(isnan(neighborresults(:,1)),:) = []

neighbortable = array2table(neighborresults,'VariableNames',{'xy','trap','time','neighborid','yfpmean','rfpmean','area','disttotrapcenter'})
bgtable = array2table(bgresults,'VariableNames',{'xy','trap','time','neighborid','yfpmean','rfpmean'})

writetable(neighbortable,'8_30_18_yTY146_neighbormeasurements.csv');
writetable(bgtable,'8_30_18_yTY146_neighbgmeasurements.csv');













