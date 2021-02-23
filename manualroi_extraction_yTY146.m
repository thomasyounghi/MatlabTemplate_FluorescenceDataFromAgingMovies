addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis');

coord = 'trappedcellcoord_7_5_18_yTY149b.mat';
trapfile = 'aliveafterdoxadded_7_5_18yTY149oldover15.csv';

traps = csvread(trapfile,1,0);
prefix = './tifs/7_5_18_yty149b_doxyoungpart2_every3rd_xy';
midfix = ' - Alignedt';
uppermaxtime = 25;

load(coord);

row = 1;
neighborresults = NaN(10000,6);
neighborresultsrow = 1;


for row = 1:size(traps,1)
    xy = traps(row,1);
    trap = traps(row,2);
    maxtime = min(traps(row,4),uppermaxtime);

    for t = 1:maxtime
        yfp = imread(strcat(prefix,num2strwithzeros(xy),midfix,num2strwithzeros(t),'xy1c2.tif'));
        rfp = imread(strcat(prefix,num2strwithzeros(xy),midfix,num2strwithzeros(t),'xy1c3.tif'));

        nearbycoord = nearbypoly{row,t};

        if size(nearbycoord,1) > 0 
            currnearby = nearbycoord{1,1};
            neighbormask = poly2mask(currnearby(:,1),currnearby(:,2),512,512);


            yfpmean = regionprops(neighbormask,yfp,'MeanIntensity');
            yfpmean = yfpmean.MeanIntensity;
            rfpmean = regionprops(neighbormask,rfp,'MeanIntensity');
            rfpmean = rfpmean.MeanIntensity;
            area = regionprops(neighbormask,'Area');
            area = area.Area;

            %Saving the neighbor data
            neighborresults(neighborresultsrow,:) = [xy,trap,t,yfpmean,rfpmean,area]
            neighborresultsrow = neighborresultsrow+1;
        end
    end
end
        
neighborresults(isnan(neighborresults(:,1)),:) = []

neighbortable = array2table(neighborresults,'VariableNames',{'xy','trap','time','yfpmean','rfpmean','area'})

writetable(neighbortable,'7_5_18_yTY149_manualroimeasurements.csv');














