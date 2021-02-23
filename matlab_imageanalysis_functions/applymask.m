%Apply the masks in the mask folder to all the phase G images
%Number each trap in each image according to 
function measurements = applymask(xylocs,maskprefix,tifprefix,maxtime,channelnum,outputname,f)
    midfix = ' - Alignedt';
    %midfix = 'T';
    measurements = zeros(15*length(xylocs),maxtime);
    currentrow = 1;


    for i = 1:length(xylocs)
        xy = xylocs(i);

        %string specifying the xy frame
        xystr = num2strwithzeros(xy);

        %getting the mask for the current frame
        maskfile = strcat(maskprefix,num2str(xy),'.tif');
        mask = imread(maskfile);
        [l,num]= bwlabel(mask);
        D = regionprops(l,'Centroid');
        centroids = cat(1, D.Centroid);
        centroids = ceil(centroids);

        %Opening the phase G image corresponding to the first timepoint of the current xy frame
        currentimagename = strcat(tifprefix,xystr,midfix,'01xy1c1.tif');
        %currentimagename = strcat(tifprefix,xystr,midfix,'01C1.tif');
        
        currentimage = imread(currentimagename);
        orderedindices = orderrois(centroids);
        labeled = insertText(currentimage*50,centroids(orderedindices,:),1:size(centroids,1));

        %save the numbered phase g images in a folder called numbered.
        numberedname = strcat('./numbered/xy',num2str(xy),'.tif')
        imwrite(labeled,numberedname);

        numrois = size(centroids,1);
        lastrow = currentrow+numrois-1;
        measurements(currentrow:lastrow,1) = xy*ones(numrois,1);
        measurements(currentrow:lastrow,2) = (1:numrois)';
        %looping over all the times;
        for j =1:maxtime
            tstring = num2strwithzeros(j);
            filename = strcat(tifprefix,xystr,midfix,tstring,'xy1c',num2str(channelnum),'.tif');
            %filename = strcat(tifprefix,xystr,midfix,tstring,'C',num2str(channelnum),'.tif');

            if exist(filename)==0
                break
            end
            image = imread(filename);
   
            currentvalues = f(mask,image);
            measurements(currentrow:lastrow,j+2) =  currentvalues(orderedindices)';
        end
        currentrow = currentrow+numrois
    end
end

