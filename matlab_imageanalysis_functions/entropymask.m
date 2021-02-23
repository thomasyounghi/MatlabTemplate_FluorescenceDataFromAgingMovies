%applies an entropy filter to the input image, followed by imfill, and
%thresholding to identify cells
function bw = entropymask(image,nhoodsize,entropyco,opensesize)
    image = im2double(image);
    openSE = strel('rectangle',[opensesize opensesize]);
    bw = imopen(imfill(entropyfilt(image,true(nhoodsize)))>entropyco,openSE);
end