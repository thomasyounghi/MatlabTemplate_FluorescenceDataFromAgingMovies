function indiceslabeledbygroup = ygroupassignment(indicestolabel,indexoffirstgroupelements)
    indiceslabeledbygroup = zeros(1,size(indicestolabel,1));
    numberofgroups = size(indexoffirstgroupelements,1);
    
    for i = 1:(numberofgroups-1)
        firstindexingroup = indexoffirstgroupelements(i);
        lastindexingroup = indexoffirstgroupelements(i+1)-1;
        indiceslabeledbygroup(indicestolabel(firstindexingroup:lastindexingroup))=i;
    end
    
    firstindexoflastgroup = indexoffirstgroupelements(numberofgroups);
    lastindexoflastgroup = size(indicestolabel,1);
    indiceslabeledbygroup(indicestolabel(firstindexoflastgroup:lastindexoflastgroup)) = numberofgroups
end