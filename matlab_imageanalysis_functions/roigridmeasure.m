function results = roigridmeasure(cellmask,yfp,rfp,roipolygon)
    roidim = max(roipolygon)-min(roipolygon);
    rectdim = fliplr(size(cellmask));
    numroifitdim = floor(rectdim ./ roidim);
    smallestxs = 0:6:((numroifitdim(1)-1)*roidim(1))
    smallestys = 0:6:((numroifitdim(2)-1)*roidim(2))
    centerxs = smallestxs + roidim(1)/2;
    centerys = smallestys + roidim(2)/2;

    %A matrix with pixels containing the distance to the cell
    D = bwdist(cellmask);
    
    %a matrix that holds the distance from the roi to the cell
    %and the average pixel intensity of the roi
    results = NaN(size(centerxs,2)*size(centerys,2)*6,5);
    row = 1;
    for i = centerxs
        for j = centerys
            distancetocell = D(j,i);
            if distancetocell >= 2;
                newcoord = roipolygon + repmat([i,j],size(roipolygon,1),1);
                xi = newcoord(:,1)';
                yi = newcoord(:,2)';
                bwroi = poly2mask(xi,yi,size(cellmask,1),size(cellmask,2));
%                 figure();
%                 imshow(bwroi);
                
                meanyfp = regionprops(bwroi,yfp,'MeanIntensity');
                meanyfp = meanyfp.MeanIntensity(1);
                meanrfp = regionprops(bwroi,rfp,'MeanIntensity');
                meanrfp = meanrfp.MeanIntensity(1);

                yfppix = regionprops(bwroi,yfp,'PixelValues');
                yfpstd = std(double(cell2mat(struct2cell(yfppix))));
                
                rfppix = regionprops(bwroi,rfp,'PixelValues');
                rfpstd = std(double(cell2mat(struct2cell(rfppix))));
                
                results(row,:) = [distancetocell,meanyfp,meanrfp,yfpstd,rfpstd];
                row = row+1;
                
            end
        end
    end
    
    results = results(1:(row-1),:)
    yfpcell = regionprops(cellmask,yfp,'MeanIntensity');
    yfpcell = yfpcell.MeanIntensity(:);
    rfpcell = regionprops(cellmask,rfp,'MeanIntensity');
    rfpcell = rfpcell.MeanIntensity(:);
    cellmeasurements = repmat([yfpcell,rfpcell],size(results,1),1);
    results = [results,cellmeasurements];
    
    results = array2table(results,'VariableNames',{'disttoobj','yfproi','rfproi','yfpstd','rfpstd','yfpcell','rfpcell'});
end