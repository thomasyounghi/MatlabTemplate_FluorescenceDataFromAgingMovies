function maxpixvalues = getmaxpixel(mask,image)
    s = regionprops(mask,image,'PixelValues');
    s = struct2cell(s);
    maxpixvalues = cellfun(@max,s);
end