function localtotalbg = getlocaltotalbg(localmask,notbg,image)
    localbgpixels = regionprops(localmask,uint16(~notbg) .* image,'PixelValues');
    localtotalbg = cellfun(@sum,struct2cell(localbgpixels))';
end