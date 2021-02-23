function means = getroimeans(mask,image)
    s = regionprops(mask,image,'MeanIntensity');
    means = cell2mat(struct2cell(s));
end