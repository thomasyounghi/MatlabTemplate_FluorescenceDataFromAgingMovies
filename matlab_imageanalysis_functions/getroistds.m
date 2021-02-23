function stds = getroistds(mask,image)
    s = regionprops(mask,image,'PixelValues');
    [l,num]= bwlabel(mask);
    stds = cellfun(@std2,struct2cell(s));
end