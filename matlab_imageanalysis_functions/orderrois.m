function orderedindices = orderrois(centroids)
    [B I] = sort(centroids(:,2))
    changeinY = diff(B)
    %Find the largest jumps in Y coordinate
    indexofgroupchanges = find(changeinY > 100)
    indexoffirstelementingroup = [1;indexofgroupchanges+1]
    ygroupindices = ygroupassignment(I,indexoffirstelementingroup);
    tosort = [ygroupindices',centroids(:,1)]
    [B I] = sort(tosort);
    orderedindices = I(:,1);
end