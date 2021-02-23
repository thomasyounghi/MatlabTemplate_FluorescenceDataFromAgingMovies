function [mean1, sd1, max1,numpix] = getconvpixstats(mask,image,window)
    imagecved = conv2(image,window,'same');
    maskcved = conv2(mask,window,'same');
    windowfitbinary = maskcved >= 1;
    pixelvalues = regionprops(windowfitbinary,imagecved,'PixelValues');
    pixelvalues  = pixelvalues.PixelValues;
    max1 = max(pixelvalues);
    mean1 = mean(pixelvalues);
    sd1 = std(pixelvalues);
    numpix = size(pixelvalues,1);
end