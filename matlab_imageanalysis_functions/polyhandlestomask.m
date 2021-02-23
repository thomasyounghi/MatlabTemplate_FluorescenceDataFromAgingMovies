%Takes a cell array of handles to polygons or rectangles in an image
%returns the mask formed by taking the union of the these locations
%Assumes the handles all refer to the same image
function bw = polyhandlestomask(polyhandles,imagehandle)
    polyhandles = getvalidpolyhand(polyhandles);
    numpoly = size(polyhandles,2);
    imagehandles = mat2cell(repelem(imagehandle,numpoly),1,ones(1,numpoly));
    allbws = cellfun(@createMask,polyhandles,imagehandles,'un',0);
    bw = sum(cat(3,allbws{:}),3) ~=0;
end
