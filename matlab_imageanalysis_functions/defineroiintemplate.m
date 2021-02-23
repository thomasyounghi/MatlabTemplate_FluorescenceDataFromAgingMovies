function roicoord = defineroiintemplate(template,polygon)
    polygon = double(polygon);
    roicoord = 0;
    if size(polygon,1)== 0
        [BW,xi,yi] = roipoly(template*50);
        roicoord = [xi,yi];
    else
        imshow(template*50);
        h = impoly(gca,polygon);
        while true
            w = waitforbuttonpress;
            if w == 1
                break
            end
        end
         
        roicoord = getPosition(h);
        waitfor(h);
    end
    roicoord = int32(round(reshape(roicoord',1,2*size(roicoord,1)),0)) 
end
