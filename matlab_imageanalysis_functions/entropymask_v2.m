%applies an entropy filter to the input image, followed by imfill, and
%thresholding to identify cells
function bw = entropymask_v2(image,nhoodsize,entropyco,opensesize)
    %image = im2double(image);
    openSE = strel('rectangle',[opensesize opensesize]);
    bw = imopen(imfill(entropyfilt(image,ones(3)))>entropyco,openSE);
    bw = imopen(imfill(entropyfilt(image,true(nhoodsize)))>entropyco,openSE);
end