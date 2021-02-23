function validpolyhand = getvalidpolyhand(polyhandles)
    onlypolyhandles = polyhandles(1,find(~cellfun('isempty',polyhandles)));
    validpolyhand = onlypolyhandles(1,find(cellfun(@isvalid,onlypolyhandles)));
end