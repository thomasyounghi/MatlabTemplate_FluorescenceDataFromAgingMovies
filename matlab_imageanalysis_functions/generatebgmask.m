%Generate a mask corresponding to a local region around each trap.
%Used the traps as identified in the 'masks' folder

function generatebgmask(xylocs,maskprefix,se,prefix,midfix,suffix)
    for i = 1:length(xylocs)
       xy = xylocs(i);

       %getting the mask for the current frame
       maskfile = strcat(maskprefix,num2str(xy),'.tif');
       mask = imread(maskfile);
       [l,num]= bwlabel(mask);
       D = regionprops(l,'Centroid');
       centroids = cat(1, D.Centroid);
       centroids = round(centroids,0);

       %Opening the phase G image corresponding to the first timepoint of the current xy frame
       xystr = num2strwithzeros(xy);
       currentimagename = strcat(prefix,xystr,midfix,'01',suffix);
       image = imread(currentimagename);
       numrows = size(image,1);
       numcols = size(image,2);

       %Using the structuring element to generate a larger mask containing each
       %trap
       mask = gettrapmask(centroids,numrows,numcols,se);
       overlaid = mask.*im2double(image*50)

      %save background masks, and overlaid images in the folder 'bgmasks'
       overlaidname = strcat('./bgmasks/overlayxy',num2str(xy),'.tif')
       maskname = strcat('./bgmasks/xy',num2str(xy),'.tif')
       imwrite(overlaid,overlaidname);
       imwrite(mask,maskname);
    end

end
