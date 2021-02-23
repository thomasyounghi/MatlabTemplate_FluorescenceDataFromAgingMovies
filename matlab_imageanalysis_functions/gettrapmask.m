%Given a vector of (x,y) coordinates and dimensions of a matrix,
%returns a logical matrix that is the result of dilating each (x,y)
%location by the given structuring element

function mask = gettrapmask(locations,numrows,numcols,se)
    binarymask = zeros(numrows,numcols);
    for i=1:size(locations,1)
        binarymask(locations(i,2),locations(i,1))=1;
    end
    mask = imdilate(binarymask,se);
    mask = (mask>0);
end
