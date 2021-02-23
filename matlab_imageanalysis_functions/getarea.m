function area = getarea(l)
    s = regionprops(l,'Area');
    s = struct2cell(s);
    area = cell2mat(s);
end