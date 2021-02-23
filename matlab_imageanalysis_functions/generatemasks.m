%Given a parameter file containing the xy locations for which to generate
%masks, and file prefix, identifies traps and generates masks (saveds as
%tif files in the folder 'masks'
function roicoord = generatemasks(xylocs,uptemplatexy,downtemplatexy,roipolygon,cutofffactor,prefix,midfix,suffix,outputprefix,threshfactor)
%User defines the upward and downward trap templates and offset
%corresponding to the cell location
    framestr = num2strwithzeros(uptemplatexy);
    filename = strcat(prefix,framestr,midfix,suffix);
    image = imread(filename);
    [upwardtrap, rect] = definetrap(image);
    uptemplatepg = imcrop(image,rect);
    uproicoord = defineroiintemplate(uptemplatepg,double(roipolygon));
    
    framestr = num2strwithzeros(downtemplatexy);
    filename = strcat(prefix,framestr,midfix,suffix);
    image = imread(filename);
    [downwardtrap, rect] = definetrap(image);
    downtemplatepg = imcrop(image,rect);
    roicoord = reshape(uproicoord,2,size(uproicoord,2)/2)'
    downroicoord = defineroiintemplate(downtemplatepg,roicoord);
    

    for i=1:length(xylocs)
        currentframe = xylocs(i);

        %string specifying the xy frame
        framestr = num2strwithzeros(currentframe);

        %Defining our mask based on the size of the first image
        filename = strcat(prefix,framestr,midfix,suffix);
        if exist(filename) == 0 
            break
        end
        image = imread(filename);

        [pgoverlaid bw] = identifytraprois(image,upwardtrap,downwardtrap,uproicoord,downroicoord,cutofffactor,threshfactor)
        pgfilename = strcat(outputprefix,'pgoverlay_xy',num2str(currentframe),'.tif')
        bwfilename = strcat(outputprefix,'mask_xy',num2str(currentframe),'.tif');
        imwrite(pgoverlaid*10,pgfilename);
        imwrite(bw,bwfilename);
    end
end

