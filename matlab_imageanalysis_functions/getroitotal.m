function totals = getroitotal(mask,image)
    s = regionprops(mask,image,'PixelValues');
    s = struct2cell(s);
    totals = cellfun(@sum,s);
end