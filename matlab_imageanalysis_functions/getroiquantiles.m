function quantiles = getroiquantiles(mask,image)
    percentile = 0.1
    s = regionprops(mask,image,'PixelValues');
    [l,num]= bwlabel(mask);
    quantiles = cellfun(@quantile,struct2cell(s),num2cell(percentile*ones(1,num)));
end